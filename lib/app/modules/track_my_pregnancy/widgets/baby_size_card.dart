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
    return GestureDetector(
      onTap: () {
        Get.toNamed('/baby_size_discovery');
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
            // Size image as background
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/logos/size.png',
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
                        "Tap to discover the size of your baby!",
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
