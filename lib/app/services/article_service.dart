import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models/article.dart';
import '../utils/image_url_helper.dart';
import 'image_download_service.dart';

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

      // Download and cache images for loaded articles
      await downloadArticleImages();
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
        data['id'] = doc.id; // Add document ID
        newPregnancyArticles.add(ArticleModel.fromJson(data));
      }

      pregnancyArticles.value = newPregnancyArticles;

      // Download baby articles
      final babySnapshot = await _firestore.collection('babyarticles').get();

      final List<ArticleModel> newBabyArticles = [];
      for (final doc in babySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID
        newBabyArticles.add(ArticleModel.fromJson(data));
      }

      babyArticles.value = newBabyArticles;

      // Save to local storage
      await _saveLocalArticles();

      // Download and cache images
      await downloadArticleImages();

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

      // Download and cache images after sync
      await downloadArticleImages();

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

  /// Preload and cache images from article URLs
  Future<void> preloadArticleImages(List<ArticleModel> articles) async {
    try {
      final imageUrls = articles
          .where((article) => _isNetworkImage(article.image))
          .map((article) => article.image)
          .toList();

      if (imageUrls.isNotEmpty) {
        await ImageDownloadService.to.preloadImages(imageUrls);
        print('Preloaded ${imageUrls.length} article images');
      }
    } catch (e) {
      print('Failed to preload article images: $e');
    }
  }

  /// Check if the image source is a network URL
  bool _isNetworkImage(String imageSource) {
    return imageSource.startsWith('http://') ||
        imageSource.startsWith('https://') ||
        imageSource.startsWith('gs://');
  }

  /// Convert Google Drive share links to direct download links
  String _convertGoogleDriveUrl(String url) {
    return ImageUrlHelper.convertGoogleDriveUrl(url);
  }

  /// Download and cache images for all articles
  Future<void> downloadArticleImages() async {
    try {
      // Preload pregnancy article images
      await preloadArticleImages(pregnancyArticles);

      // Preload baby article images
      await preloadArticleImages(babyArticles);

      print('Article images downloaded and cached successfully');
    } catch (e) {
      print('Error downloading article images: $e');
    }
  }

  /// Manually trigger image download (for testing or manual sync)
  Future<void> refreshArticleImages() async {
    try {
      print('Manually refreshing article images...');
      await downloadArticleImages();
      print('Article images refreshed successfully');
    } catch (e) {
      print('Error refreshing article images: $e');
    }
  }
}
