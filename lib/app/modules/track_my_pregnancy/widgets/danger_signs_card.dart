import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/data/const/danger.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';

class DangerSignsCard extends StatefulWidget {
  const DangerSignsCard({Key? key}) : super(key: key);

  @override
  State<DangerSignsCard> createState() => _DangerSignsCardState();
}

class _DangerSignsCardState extends State<DangerSignsCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.error.withOpacity(0.12),
            NeoSafeColors.creamWhite.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.error.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: NeoSafeColors.error.withOpacity(0.18),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: NeoSafeColors.error.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: NeoSafeColors.error,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'danger_signs_in_pregnancy'.tr,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: NeoSafeColors.error,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              // Dropdown/expand button
              Container(
                decoration: BoxDecoration(
                  color: NeoSafeColors.error.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(0),
                child: IconButton(
                  icon: Icon(_isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                  color: NeoSafeColors.error,
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  splashRadius: 22,
                ),
              ),
            ],
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const SizedBox(height: 18),
                ...kDangerSigns.map((sign) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle,
                              size: 8, color: NeoSafeColors.error),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              sign.tr,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 350),
          ),
        ],
      ),
    );
  }
}
