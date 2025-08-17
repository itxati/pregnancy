import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';

class BabyArticlePage extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String content;
  final String? subtitle;

  const BabyArticlePage({
    Key? key,
    required this.title,
    required this.imageAsset,
    required this.content,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: NeoSafeColors.primaryPink),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.share, color: NeoSafeColors.primaryPink),
              onPressed: () {
                // TODO: Implement share functionality
                Get.snackbar(
                  'Share',
                  'Sharing article...',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: NeoSafeGradients.backgroundGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // Hero Image Section
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  // Background Image
                  Container(
                    height: 280,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      child: Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
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
                            child: Icon(
                              Icons.article_outlined,
                              size: 60,
                              color: NeoSafeColors.primaryPink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Dark overlay for better text readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Article Tag
                  Positioned(
                    top: 100,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            NeoSafeColors.primaryPink.withOpacity(0.9),
                            NeoSafeColors.roseAccent.withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: NeoSafeColors.primaryPink.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.article_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Article",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Title and Subtitle
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            subtitle!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reading Time Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: NeoSafeColors.primaryPink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: NeoSafeColors.primaryPink.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: NeoSafeColors.primaryPink,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${_calculateReadingTime(content)} min read",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: NeoSafeColors.primaryPink,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Article Content
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: NeoSafeColors.primaryPink.withOpacity(0.08),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: NeoSafeColors.primaryPink.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Content Text
                          Text(
                            content,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: NeoSafeColors.primaryText,
                                      height: 1.6,
                                      fontSize: 16,
                                    ),
                          ),

                          const SizedBox(height: 24),

                          // Divider
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  NeoSafeColors.primaryPink.withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Article Footer
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: NeoSafeColors.primaryPink
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                  color: NeoSafeColors.primaryPink,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Did you find this helpful?",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: NeoSafeColors.primaryText,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      "Share your thoughts with us",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: NeoSafeColors.secondaryText,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateReadingTime(String content) {
    // Average reading speed is 200-250 words per minute
    // We'll use 225 words per minute for calculation
    final wordCount = content.split(' ').length;
    final readingTime = (wordCount / 225).ceil();
    return readingTime < 1 ? 1 : readingTime;
  }
}
