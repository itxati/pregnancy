import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/services/article_service.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/views/article_page.dart';
// Removed SmartImage usage for article cards
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
            "this_weeks_essential_reads".tr,
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
                  final lang = Get.locale?.languageCode;
                  final localizedTitle = article.localizedTitle(lang);
                  final localizedContent = article.localizedContent(lang);
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 180,
                      child: _buildArticleCard(
                        context,
                        localizedTitle,
                        article.image,
                        articleId: article.id,
                        aspectRatio: 1.2,
                        onTap: () {
                          Get.to(() => ArticlePage(
                                title: localizedTitle,
                                imageAsset: article.image,
                                content: localizedContent,
                                articleId: article.id,
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
                    article.localizedTitle(Get.locale?.languageCode),
                    article.image,
                    articleId: article.id,
                    subtitle:
                        article.localizedContent(Get.locale?.languageCode),
                    aspectRatio: 2.5,
                    onTap: () {
                      Get.to(() => ArticlePage(
                            title: article
                                .localizedTitle(Get.locale?.languageCode),
                            imageAsset: article.image,
                            content: article
                                .localizedContent(Get.locale?.languageCode),
                            articleId: article.id,
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
    String? articleId,
    String? subtitle,
    double aspectRatio = 1.5,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: NeoSafeColors.primaryPink.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: NeoSafeColors.primaryPink.withOpacity(0.1),
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
                      NeoSafeColors.lightPink.withOpacity(0.8),
                      NeoSafeColors.palePink.withOpacity(0.6),
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
                    FutureBuilder(
                      future: ArticleService.to.findLocalImageForUrl(
                        imageAsset,
                        articleId: articleId,
                        articleTitle: title,
                      ),
                      builder: (context, snapshot) {
                        final file = snapshot.data;
                        return Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: file != null
                                ? Image.file(file, fit: BoxFit.cover)
                                : Container(color: Colors.transparent),
                          ),
                        );
                      },
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.primaryPink.withOpacity(0.9),
            NeoSafeColors.lightPink.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.3),
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
            'article'.tr,
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
