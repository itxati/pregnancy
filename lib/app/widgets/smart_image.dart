import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:typed_data';
import '../utils/neo_safe_theme.dart';
import '../utils/image_url_helper.dart';
import '../services/image_download_service.dart';

class SmartImage extends StatelessWidget {
  final String imageSource;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const SmartImage({
    Key? key,
    required this.imageSource,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

    bool get _isNetworkImage {
    return imageSource.startsWith('http://') || 
           imageSource.startsWith('https://') ||
           imageSource.startsWith('gs://');
  }

  /// Convert Google Drive share links to direct download links
  String _convertGoogleDriveUrl(String url) {
    return ImageUrlHelper.convertGoogleDriveUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    // Default placeholder and error widgets
    final defaultPlaceholder = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.primaryPink.withOpacity(0.3),
            NeoSafeColors.lightPink.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 40,
              color: NeoSafeColors.primaryPink,
            ),
            SizedBox(height: 8),
            Text(
              'Loading...',
              style: TextStyle(
                color: NeoSafeColors.primaryPink,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );

    final defaultErrorWidget = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.primaryPink.withOpacity(0.3),
            NeoSafeColors.lightPink.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 40,
              color: NeoSafeColors.primaryPink,
            ),
            SizedBox(height: 8),
            Text(
              'Image Error',
              style: TextStyle(
                color: NeoSafeColors.primaryPink,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );

    Widget imageWidget;

    if (_isNetworkImage) {
        // Handle network images with caching
        if (ImageUrlHelper.isGoogleDriveUrl(imageSource)) {
          // For Google Drive, use a fallback mechanism
          imageWidget = _buildGoogleDriveImageWithFallback();
        } else {
          // For other network images
          imageWidget = CachedNetworkImage(
            imageUrl: imageSource,
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) => placeholder ?? defaultPlaceholder,
            errorWidget: (context, url, error) => errorWidget ?? defaultErrorWidget,
            memCacheWidth: 800,
            memCacheHeight: 600,
          );
        }
      } else {
      // Handle local asset images
      imageWidget = Image.asset(
        imageSource,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? defaultErrorWidget,
      );
    }

    // Apply borderRadius if provided
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Build a fallback widget for Google Drive images that fail to load
  Widget _buildGoogleDriveFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.primaryPink.withOpacity(0.3),
            NeoSafeColors.lightPink.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_download_outlined,
              size: 40,
              color: NeoSafeColors.primaryPink,
            ),
            SizedBox(height: 8),
            Text(
              'Google Drive Image',
              style: TextStyle(
                color: NeoSafeColors.primaryPink,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build Google Drive image with fallback mechanism
  Widget _buildGoogleDriveImageWithFallback() {
    return FutureBuilder<Uint8List?>(
      future: ImageDownloadService.to.downloadImage(imageSource),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ?? Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.primaryPink.withOpacity(0.3),
                  NeoSafeColors.lightPink.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: NeoSafeColors.primaryPink,
                    strokeWidth: 2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: NeoSafeColors.primaryPink,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return errorWidget ?? _buildGoogleDriveFallback();
        }

        // Display the downloaded image
        return Image.memory(
          snapshot.data!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? _buildGoogleDriveFallback();
          },
        );
      },
    );
  }
}
