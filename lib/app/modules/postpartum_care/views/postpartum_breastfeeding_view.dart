import 'package:flutter/material.dart';
import '../../../data/models/postpartum_models.dart';
import 'widgets/breastfeeding_sections.dart';
import 'widgets/inline_video_player.dart';

class PostpartumBreastfeedingView extends StatelessWidget {
  final BreastfeedingContent content;
  const PostpartumBreastfeedingView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const InlineVideoPlayer(assetPath: 'assets/videos/breastfeeding.mp4'),
        const SizedBox(height: 12),
        BreastfeedingSections(content: content),
      ],
    );
  }
}
