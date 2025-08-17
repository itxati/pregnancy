import 'package:flutter/material.dart';
import '../../../data/models/postpartum_models.dart';
import '../../../utils/neo_safe_theme.dart';

class PostpartumTipsView extends StatelessWidget {
  final Tips tips;
  const PostpartumTipsView({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _sectionHeader(context, Icons.check_circle, 'Do\'s'),
        const SizedBox(height: 8),
        _plainList(context, tips.dos, positive: true),
        const SizedBox(height: 20),
        _sectionHeader(context, Icons.block, 'Don\'ts'),
        const SizedBox(height: 8),
        _plainList(context, tips.donts, positive: false),
      ],
    );
  }

  Widget _sectionHeader(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: NeoSafeGradients.primaryGradient,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: NeoSafeColors.primaryText,
              ),
        ),
      ],
    );
  }

  Widget _plainList(BuildContext context, List<String> items,
      {required bool positive}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.5)),
      ),
      child: Column(
        children: items
            .asMap()
            .entries
            .map((e) =>
                _rowItem(context, e.value, isLast: e.key == items.length - 1))
            .toList(),
      ),
    );
  }

  Widget _rowItem(BuildContext context, String text, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: NeoSafeColors.softGray.withOpacity(0.3)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: NeoSafeGradients.primaryGradient,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
