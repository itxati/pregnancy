import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';
import 'package:get/get.dart';
import '../../../data/models/pregnancy_week_data.dart';

class PregnancyDevelopmentInfo extends StatelessWidget {
  final PregnancyWeekData data;
  const PregnancyDevelopmentInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(data.week),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.emoji ?? '',
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  data.comparison?.tr ?? '',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                    child: _buildMeasurementCard(
                        context,
                        'size'.tr,
                        (data.size == null || data.size!.isEmpty)
                            ? '-'
                            : data.size!)),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildMeasurementCard(
                        context,
                        'weight'.tr,
                        (data.weight == null || data.weight!.isEmpty)
                            ? '-'
                            : data.weight!)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementCard(
      BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
