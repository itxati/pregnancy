import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';

class PregnancyBabyImage extends StatelessWidget {
  final int week;
  const PregnancyBabyImage({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxHeight * 0.8;
        final imageSize = size.clamp(150.0, 280.0);
        return Container(
          key: ValueKey(week),
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
                Colors.transparent,
              ],
              stops: const [0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: imageSize * 0.85,
                height: imageSize * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      NeoSafeColors.blushRose.withOpacity(0.3),
                      NeoSafeColors.coralPink.withOpacity(0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
              Container(
                width: imageSize * 0.7,
                height: imageSize * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: NeoSafeColors.primaryPink.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/Safe/week$week.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              NeoSafeColors.babyPink,
                              NeoSafeColors.coralPink,
                              NeoSafeColors.blushRose,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 20 + (week * 2.0),
                            height: 20 + (week * 2.0),
                            decoration: BoxDecoration(
                              color: NeoSafeColors.primaryPink,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: NeoSafeColors.primaryPink
                                      .withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
