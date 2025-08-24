import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/connectivity_service.dart';
import '../services/article_service.dart';

class SyncIndicator extends StatelessWidget {
  const SyncIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();
    final articleService = Get.find<ArticleService>();

    return Obx(() {
      final isConnected = connectivityService.hasInternetConnection;
      final isSyncing = articleService.isSyncing.value;
      final lastSync = articleService.lastSyncTime;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isConnected ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isConnected ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Connection status icon
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              size: 16,
              color: isConnected ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            
            // Sync status text
            Text(
              isConnected ? 'Online' : 'Offline',
              style: TextStyle(
                fontSize: 12,
                color: isConnected ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            if (isConnected) ...[
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 16,
                color: Colors.green.withOpacity(0.3),
              ),
              const SizedBox(width: 8),
              
              // Sync button or status
              if (isSyncing)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                )
              else
                GestureDetector(
                  onTap: () => connectivityService.forceSyncArticles(),
                  child: Icon(
                    Icons.sync,
                    size: 16,
                    color: Colors.green,
                  ),
                ),
              
              if (lastSync != null) ...[
                const SizedBox(width: 8),
                Text(
                  'Last: ${_formatLastSync(lastSync)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ],
        ),
      );
    });
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
