class ImageUrlHelper {
  /// Convert Google Drive share links to direct download links
  static String convertGoogleDriveUrl(String url) {
    if (url.contains('drive.google.com')) {
      // Handle different Google Drive URL formats
      if (url.contains('/file/d/')) {
        // Format: https://drive.google.com/file/d/FILE_ID/view
        final fileId = _extractFileId(url);
        if (fileId != null) {
          // Use the preview URL which is more reliable for images
          return 'https://drive.google.com/file/d/$fileId/preview';
        }
      } else if (url.contains('/uc?export=view&id=')) {
        // Already in correct format, but convert to preview for better reliability
        final fileId = _extractFileIdFromQuery(url);
        if (fileId != null) {
          return 'https://drive.google.com/file/d/$fileId/preview';
        }
      } else if (url.contains('id=')) {
        // Format: https://drive.google.com/open?id=FILE_ID
        final fileId = _extractFileIdFromQuery(url);
        if (fileId != null) {
          return 'https://drive.google.com/file/d/$fileId/preview';
        }
      }
    }
    return url;
  }

  /// Check if a URL is a Google Drive link
  static bool isGoogleDriveUrl(String url) {
    return url.contains('drive.google.com');
  }

  /// Extract file ID from Google Drive URL
  static String? _extractFileId(String url) {
    final regex = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  /// Extract file ID from query parameters
  static String? _extractFileIdFromQuery(String url) {
    final regex = RegExp(r'[?&]id=([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  /// Get alternative URLs for Google Drive images
  static List<String> getAlternativeGoogleDriveUrls(String originalUrl) {
    final fileId = _extractFileId(originalUrl) ?? _extractFileIdFromQuery(originalUrl);
    if (fileId != null) {
      return [
        'https://drive.google.com/file/d/$fileId/preview',
        'https://drive.google.com/uc?export=view&id=$fileId',
        'https://drive.google.com/uc?export=download&id=$fileId',
        'https://drive.google.com/file/d/$fileId/view',
      ];
    }
    return [originalUrl];
  }
}
