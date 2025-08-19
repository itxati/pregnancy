import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/track_my_pregnancy_controller.dart';

class BabySizeCard extends StatelessWidget {
  final TrackMyPregnancyController controller;

  const BabySizeCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weekData = controller.currentWeekData.value;
    final String? comparison = weekData?.comparison;

    // If no fruit/size comparison available for this week, hide the card
    if (comparison == null || comparison.isEmpty) {
      return const SizedBox.shrink();
    }

    String _titleCase(String input) {
      final words = input.replaceAll('_', ' ').split(' ');
      return words
          .where((w) => w.isNotEmpty)
          .map((w) => w[0].toUpperCase() + w.substring(1))
          .join(' ');
    }

    final String fruitName = _titleCase(comparison);
    final int weekNumber = weekData!.week;
    // Expecting assets to be added later like assets/fruit/week{N}.png
    final String fruitImageAsset = 'assets/Safe/week$weekNumber.jpg';

    return GestureDetector(
      onTap: () {
        // Get.toNamed('/baby_size_discovery');
      },
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF0E5F0).withOpacity(0.8), // NeoSafeColors.softLavender
              Color(0xFFE8C5E8), // NeoSafeColors.lavenderPink
              Color(0xFFF5D5D5), // NeoSafeColors.blushRose
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8C5E8)
                  .withOpacity(0.3), // NeoSafeColors.lavenderPink
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Fruit image as background for current week
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  fruitImageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF0E5F0)
                              .withOpacity(0.8), // NeoSafeColors.softLavender
                          Color(0xFFE8C5E8), // NeoSafeColors.lavenderPink
                          Color(0xFFF5D5D5), // NeoSafeColors.blushRose
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Dark overlay for text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 4, left: 12, right: 12),
                      child: Text(
                        "The size of your baby is",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fruitName,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
