import 'dart:typed_data';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/image_url_helper.dart';

class ImageDownloadService extends GetxService {
  static ImageDownloadService get to => Get.find();

  late final Dio _dio;
  final Map<String, Uint8List> _imageCache = {};
  final Map<String, bool> _failedUrls = {};
  SharedPreferences? _prefs;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
    _initPrefsAndLoadImages();
  }

  Future<void> _initPrefsAndLoadImages() async {
    _prefs = await SharedPreferences.getInstance();
    // Load all keys that start with 'image_cache_'
    final keys = _prefs!.getKeys().where((k) => k.startsWith('image_cache_'));
    for (final key in keys) {
      final url = key.replaceFirst('image_cache_', '');
      final base64 = _prefs!.getString(key);
      if (base64 != null) {
        try {
          final bytes = base64Decode(base64);
          _imageCache[url] = bytes;
        } catch (_) {}
      }
    }
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'Accept-Encoding': 'gzip, deflate, br',
        'DNT': '1',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'Sec-Fetch-Dest': 'image',
        'Sec-Fetch-Mode': 'no-cors',
        'Sec-Fetch-Site': 'cross-site',
        'Cache-Control': 'no-cache',
      },
    ));

    // Add interceptors for better error handling
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        print(
            'Dio error for  [32m${error.requestOptions.uri} [0m: ${error.message}');
        handler.next(error);
      },
    ));
  }

  /// Download image with multiple fallback attempts
  Future<Uint8List?> downloadImage(String url, {bool useCache = true}) async {
    // 1. Check in-memory cache
    if (useCache && _imageCache.containsKey(url)) {
      return _imageCache[url];
    }
    // 2. Check SharedPreferences
    if (_prefs != null) {
      final base64 = _prefs!.getString(_spKey(url));
      if (base64 != null) {
        try {
          final bytes = base64Decode(base64);
          _imageCache[url] = bytes;
          return bytes;
        } catch (_) {}
      }
    }
    // 3. Check failed URLs
    if (_failedUrls.containsKey(url)) {
      return null;
    }
    // 4. Try network download
    final urls = _getImageUrls(url);
    for (final imageUrl in urls) {
      try {
        print('Attempting to download image from: $imageUrl');
        final response = await _dio.get(
          imageUrl,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
            maxRedirects: 5,
          ),
        );
        if (response.statusCode == 200 && response.data != null) {
          final imageData = response.data as Uint8List;
          // Validate that it's actually an image
          if (_isValidImage(imageData)) {
            if (useCache) {
              _imageCache[url] = imageData;
            }
            // Save to SharedPreferences
            if (_prefs != null) {
              await _prefs!.setString(_spKey(url), base64Encode(imageData));
            }
            print('Successfully downloaded image from: $imageUrl');
            return imageData;
          } else {
            print('Invalid image data received from: $imageUrl');
          }
        }
      } catch (e) {
        print('Failed to download from $imageUrl: $e');
        continue;
      }
    }
    _failedUrls[url] = true;
    print('All download attempts failed for: $url');
    return null;
  }

  String _spKey(String url) => 'image_cache_$url';

  /// Get multiple URLs to try for an image
  List<String> _getImageUrls(String originalUrl) {
    if (ImageUrlHelper.isGoogleDriveUrl(originalUrl)) {
      return ImageUrlHelper.getAlternativeGoogleDriveUrls(originalUrl);
    }
    return [originalUrl];
  }

  /// Check if the downloaded data is a valid image
  bool _isValidImage(Uint8List data) {
    if (data.length < 4) return false;
    // JPEG
    if (data[0] == 0xFF && data[1] == 0xD8 && data[2] == 0xFF) return true;
    // PNG
    if (data[0] == 0x89 &&
        data[1] == 0x50 &&
        data[2] == 0x4E &&
        data[3] == 0x47) return true;
    // GIF
    if (data[0] == 0x47 && data[1] == 0x49 && data[2] == 0x46) return true;
    // WebP
    if (data[0] == 0x52 &&
        data[1] == 0x49 &&
        data[2] == 0x46 &&
        data[3] == 0x46) return true;
    return false;
  }

  /// Clear image cache (memory and SharedPreferences)
  Future<void> clearCache() async {
    _imageCache.clear();
    _failedUrls.clear();
    if (_prefs != null) {
      final keys = _prefs!.getKeys().where((k) => k.startsWith('image_cache_'));
      for (final key in keys) {
        await _prefs!.remove(key);
      }
    }
  }

  /// Get cached image
  Uint8List? getCachedImage(String url) {
    return _imageCache[url];
  }

  /// Check if image is cached
  bool isImageCached(String url) {
    return _imageCache.containsKey(url);
  }

  /// Check if URL failed to download
  bool hasUrlFailed(String url) {
    return _failedUrls.containsKey(url);
  }

  /// Preload multiple images
  Future<void> preloadImages(List<String> urls) async {
    for (final url in urls) {
      if (!isImageCached(url) && !hasUrlFailed(url)) {
        await downloadImage(url);
      }
    }
  }
}
