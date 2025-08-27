import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/article.dart';
import '../utils/image_url_helper.dart';

class ArticleService extends GetxController {
  static ArticleService get to => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();

  // Observable lists for articles
  final RxList<ArticleModel> pregnancyArticles = <ArticleModel>[].obs;
  final RxList<ArticleModel> babyArticles = <ArticleModel>[].obs;

  // Loading states
  final RxBool isLoadingPregnancyArticles = false.obs;
  final RxBool isLoadingBabyArticles = false.obs;
  final RxBool isSyncing = false.obs;

  // Storage keys
  static const String _pregnancyArticlesKey = 'pregnancy_articles';
  static const String _babyArticlesKey = 'baby_articles';
  static const String _lastSyncKey = 'last_articles_sync';

  @override
  void onInit() {
    super.onInit();
    _loadLocalArticles();
  }

  /// Load articles from local storage
  Future<void> _loadLocalArticles() async {
    try {
      // Load pregnancy articles
      final pregnancyData = _storage.read(_pregnancyArticlesKey);
      if (pregnancyData != null) {
        final List<dynamic> articlesJson = json.decode(pregnancyData);
        pregnancyArticles.value =
            articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      }

      // Load baby articles
      final babyData = _storage.read(_babyArticlesKey);
      if (babyData != null) {
        final List<dynamic> articlesJson = json.decode(babyData);
        babyArticles.value =
            articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      }

      // Download/sync images to disk for preview
      await downloadAndSaveArticleImagesToDisk();
    } catch (e) {
      print('Error loading local articles: $e');
    }
  }

  /// Save articles to local storage
  Future<void> _saveLocalArticles() async {
    try {
      // Save pregnancy articles
      final pregnancyJson = json.encode(
        pregnancyArticles.map((article) => article.toJson()).toList(),
      );
      await _storage.write(_pregnancyArticlesKey, pregnancyJson);

      // Save baby articles
      final babyJson = json.encode(
        babyArticles.map((article) => article.toJson()).toList(),
      );
      await _storage.write(_babyArticlesKey, babyJson);

      // Update last sync timestamp
      await _storage.write(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      print('Error saving local articles: $e');
    }
  }

  /// Download articles from Firebase on first login
  Future<void> downloadArticlesOnFirstLogin() async {
    try {
      isLoadingPregnancyArticles.value = true;
      isLoadingBabyArticles.value = true;

      // Check if we have local articles
      if (pregnancyArticles.isEmpty && babyArticles.isEmpty) {
        await _downloadFromFirebase();
      }
    } catch (e) {
      print('Error downloading articles on first login: $e');
    } finally {
      isLoadingPregnancyArticles.value = false;
      isLoadingBabyArticles.value = false;
    }
  }

  /// Download articles from Firebase
  Future<void> _downloadFromFirebase() async {
    try {
      // Download pregnancy articles
      final pregnancySnapshot =
          await _firestore.collection('pregnancyarticles').get();

      final List<ArticleModel> newPregnancyArticles = [];
      for (final doc in pregnancySnapshot.docs) {
        final data = doc.data();
        // Prefer provided 'id' field (e.g., pregnancy1) if present; fallback to document id
        if ((data['id'] == null) ||
            (data['id'] is String && (data['id'] as String).isEmpty)) {
          data['id'] = doc.id;
        }
        newPregnancyArticles.add(ArticleModel.fromJson(data));
      }

      pregnancyArticles.value = newPregnancyArticles;

      // Download baby articles
      final babySnapshot = await _firestore.collection('babyarticles').get();

      final List<ArticleModel> newBabyArticles = [];
      for (final doc in babySnapshot.docs) {
        final data = doc.data();
        if ((data['id'] == null) ||
            (data['id'] is String && (data['id'] as String).isEmpty)) {
          data['id'] = doc.id;
        }
        newBabyArticles.add(ArticleModel.fromJson(data));
      }

      babyArticles.value = newBabyArticles;

      // Save to local storage
      await _saveLocalArticles();

      // Download/sync images to disk for preview
      await downloadAndSaveArticleImagesToDisk();

      print(
          'Downloaded ${newPregnancyArticles.length} pregnancy articles and ${newBabyArticles.length} baby articles');
    } catch (e) {
      print('Error downloading from Firebase: $e');
      // If Firebase fails, try to load from local storage
      await _loadLocalArticles();
    }
  }

  /// Sync local articles with Firebase when internet is available
  Future<void> syncArticles() async {
    try {
      isSyncing.value = true;

      // Check if we have internet connection by trying to access Firestore
      await _firestore.collection('pregnancyarticles').limit(1).get();

      // If we reach here, we have internet connection
      await _downloadFromFirebase();

      // Download/sync images to disk for preview
      await downloadAndSaveArticleImagesToDisk();

      print('Articles synced successfully');
    } catch (e) {
      print('No internet connection or sync failed: $e');
      // Load from local storage if sync fails
      await _loadLocalArticles();
    } finally {
      isSyncing.value = false;
    }
  }

  /// Get pregnancy articles (from local storage)
  List<ArticleModel> getPregnancyArticles() {
    return pregnancyArticles.toList();
  }

  /// Get baby articles (from local storage)
  List<ArticleModel> getBabyArticles() {
    return babyArticles.toList();
  }

  /// Get small pregnancy articles (for horizontal scrolling)
  List<ArticleModel> getSmallPregnancyArticles() {
    return pregnancyArticles.where((article) => !article.isHorizontal).toList();
  }

  /// Get large pregnancy articles (for vertical layout)
  List<ArticleModel> getLargePregnancyArticles() {
    return pregnancyArticles.where((article) => article.isHorizontal).toList();
  }

  /// Get small baby articles (for horizontal scrolling)
  List<ArticleModel> getSmallBabyArticles() {
    return babyArticles.where((article) => !article.isHorizontal).toList();
  }

  /// Get large baby articles (for vertical layout)
  List<ArticleModel> getLargeBabyArticles() {
    return babyArticles.where((article) => article.isHorizontal).toList();
  }

  /// Check if articles are available
  bool get hasPregnancyArticles => pregnancyArticles.isNotEmpty;
  bool get hasBabyArticles => babyArticles.isNotEmpty;

  /// Get last sync time
  DateTime? get lastSyncTime {
    final syncString = _storage.read(_lastSyncKey);
    if (syncString != null) {
      try {
        return DateTime.parse(syncString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Clear all local articles (for testing or reset)
  Future<void> clearLocalArticles() async {
    try {
      await _storage.remove(_pregnancyArticlesKey);
      await _storage.remove(_babyArticlesKey);
      await _storage.remove(_lastSyncKey);

      pregnancyArticles.clear();
      babyArticles.clear();

      print('Local articles cleared');
    } catch (e) {
      print('Error clearing local articles: $e');
    }
  }

  // Image downloading, caching, and refreshing removed

  // ===================== Image Download to Disk & Preview Helpers =====================

  final Dio _dio = Dio();

  Future<Directory> _getImagesDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/images');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _safeIdFor(ArticleModel a) {
    if (a.id.isNotEmpty) return a.id;
    return a.title.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  }

  String _extFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final last =
        uri?.pathSegments.isNotEmpty == true ? uri!.pathSegments.last : '';
    final dot = last.lastIndexOf('.');
    if (dot != -1 && dot < last.length - 1) {
      final ext = last.substring(dot + 1).toLowerCase();
      if (ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp')
        return ext;
    }
    return 'jpg';
  }

  bool _isValidImageBytes(List<int> data) {
    if (data.length < 4) return false;
    if (data[0] == 0xFF && data[1] == 0xD8 && data[2] == 0xFF)
      return true; // JPEG
    if (data[0] == 0x89 &&
        data[1] == 0x50 &&
        data[2] == 0x4E &&
        data[3] == 0x47) return true; // PNG
    if (data[0] == 0x47 && data[1] == 0x49 && data[2] == 0x46)
      return true; // GIF
    if (data[0] == 0x52 &&
        data[1] == 0x49 &&
        data[2] == 0x46 &&
        data[3] == 0x46) return true; // WebP (RIFF)
    return false;
  }

  Future<bool> _downloadBytesToFile(String url, String filepath) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          headers: const {
            'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
            'Cache-Control': 'no-cache',
          },
        ),
      );
      final data = response.data;
      if (data == null || !_isValidImageBytes(data)) return false;
      final file = File(filepath);
      await file.writeAsBytes(data, flush: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _tryDownloadWithAlternatives(
      String originalUrl, String filepath) async {
    List<String> candidates;
    if (ImageUrlHelper.isGoogleDriveUrl(originalUrl)) {
      candidates = ImageUrlHelper.getAlternativeGoogleDriveUrls(originalUrl);
      candidates.sort((a, b) {
        int score(String u) {
          if (u.contains('export=download')) return 0;
          if (u.contains('export=view')) return 1;
          if (u.contains('/view')) return 2;
          if (u.contains('/preview')) return 3;
          return 4;
        }

        return score(a).compareTo(score(b));
      });
    } else {
      candidates = [originalUrl];
    }

    for (final u in candidates) {
      final ok = await _downloadBytesToFile(u, filepath);
      if (ok) return true;
    }
    return false;
  }

  Future<void> downloadAndSaveArticleImagesToDisk() async {
    try {
      final dir = await _getImagesDir();
      int success = 0;
      int fail = 0;

      final List<ArticleModel> all = [
        ...pregnancyArticles,
        ...babyArticles,
      ];

      for (int i = 0; i < all.length; i++) {
        final a = all[i];
        final url = a.image;
        if (url.isEmpty) continue;
        final ext = _extFromUrl(url);
        final safeId = _safeIdFor(a);
        // Ensure only one file per article id by removing old variants
        for (final e in const ['jpg', 'jpeg', 'png', 'webp']) {
          final existing = File('${dir.path}/$safeId.$e');
          if (await existing.exists()) {
            try {
              await existing.delete();
            } catch (_) {}
          }
        }
        final filepath = '${dir.path}/$safeId.$ext';
        final ok = await _tryDownloadWithAlternatives(url, filepath);
        if (ok) {
          success++;
        } else {
          fail++;
        }
      }
      print('Article images download complete. Success: $success, Fail: $fail');
    } catch (e) {
      print('Error downloading/saving article images: $e');
    }
  }

  Future<File?> findLocalImageForArticle(ArticleModel article) async {
    try {
      final dir = await _getImagesDir();
      final safeId = _safeIdFor(article);
      for (final e in const ['jpg', 'jpeg', 'png', 'webp']) {
        final f = File('${dir.path}/$safeId.$e');
        if (await f.exists()) return f;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<File?> findLocalImageForUrl(String url,
      {String? articleId, String? articleTitle}) async {
    if (articleId != null && articleId.isNotEmpty) {
      final temp = ArticleModel(
        id: articleId,
        title: articleTitle ?? '',
        image: url,
        content: '',
      );
      return findLocalImageForArticle(temp);
    }
    return null;
  }
}
