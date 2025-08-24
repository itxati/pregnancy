import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'article_service.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find();

  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = false.obs;
  final RxBool isInitialized = false.obs;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  /// Initialize connectivity monitoring
  Future<void> _initializeConnectivity() async {
    try {
      // Check initial connectivity status
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);

      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
        onError: (error) {
          print('Connectivity error: $error');
        },
      );

      isInitialized.value = true;
    } catch (e) {
      print('Error initializing connectivity: $e');
      isInitialized.value = true;
    }
  }

  /// Update connection status and trigger sync if needed
  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = isConnected.value;
    final isNowConnected = result != ConnectivityResult.none;

    isConnected.value = isNowConnected;

    // If connection was restored, sync articles
    if (!wasConnected && isNowConnected) {
      _syncArticlesOnConnectionRestored();
    }

    print('Connectivity changed: ${result.name}, Connected: $isNowConnected');
  }

  /// Sync articles when internet connection is restored
  Future<void> _syncArticlesOnConnectionRestored() async {
    try {
      print('Internet connection restored, syncing articles...');
      final articleService = Get.find<ArticleService>();
      await articleService.syncArticles();
    } catch (e) {
      print('Error syncing articles on connection restore: $e');
    }
  }

  /// Check if currently connected to internet
  bool get hasInternetConnection => isConnected.value;

  /// Get current connectivity status
  ConnectivityResult get currentConnectivityStatus {
    if (!isInitialized.value) return ConnectivityResult.none;
    return isConnected.value
        ? ConnectivityResult.wifi
        : ConnectivityResult.none;
  }

  /// Manually check connectivity
  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  /// Force sync articles (useful for manual refresh)
  Future<void> forceSyncArticles() async {
    try {
      final articleService = Get.find<ArticleService>();
      await articleService.syncArticles();
    } catch (e) {
      print('Error force syncing articles: $e');
    }
  }
}
