import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/services/article_service.dart';
import 'package:babysafe/app/services/theme_service.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/views/article_page.dart';
import 'package:babysafe/app/widgets/smart_image.dart';
import '../controllers/track_my_pregnancy_controller.dart';

class EssentialReadsSection extends StatelessWidget {
  final TrackMyPregnancyController controller;

  const EssentialReadsSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articleService = Get.find<ArticleService>();
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      final smallArticles = articleService.getSmallPregnancyArticles();
      final largeArticles = articleService.getLargePregnancyArticles();

      // Show nothing if no articles
      if (smallArticles.isEmpty && largeArticles.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This week's essential reads",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3D2929),
                ),
          ),
          const SizedBox(height: 16),
          if (smallArticles.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: smallArticles.map((article) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 180,
                      child: _buildArticleCard(
                        context,
                        article.title,
                        article.image,
                        aspectRatio: 1.2,
                        onTap: () {
                          Get.to(() => ArticlePage(
                                title: article.title,
                                imageAsset: article.image,
                                content: article.content,
                              ));
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (largeArticles.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...largeArticles.map((article) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildArticleCard(
                    context,
                    article.title,
                    article.image,
                    subtitle: article.content,
                    aspectRatio: 2.5,
                    onTap: () {
                      Get.to(() => ArticlePage(
                            title: article.title,
                            imageAsset: article.image,
                            content: article.content,
                          ));
                    },
                  ),
                )),
          ],
        ],
      );
    });
  }

  Widget _buildArticleCard(
    BuildContext context,
    String title,
    String imageAsset, {
    String? subtitle,
    double aspectRatio = 1.5,
    VoidCallback? onTap,
  }) {
    final themeService = Get.find<ThemeService>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: themeService.getPrimaryColor().withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: themeService.getPrimaryColor().withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeService.getPaleColor().withOpacity(0.8),
                      themeService.getBabyColor().withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: SmartImage(
                          imageSource: imageAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 12,
                      left: 12,
                      child: _ArticleTag(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3D2929),
                          height: 1.2,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B5555),
                            height: 1.3,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleTag extends StatelessWidget {
  const _ArticleTag();

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeService.getPrimaryColor().withOpacity(0.9),
            themeService.getAccentColor().withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: themeService.getPrimaryColor().withOpacity(0.3),
            blurRadius: 4,
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
