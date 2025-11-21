import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/speech_service.dart';

class SpeechButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  final EdgeInsets? padding;

  const SpeechButton({
    Key? key,
    required this.text,
    this.color,
    this.size = 24.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final speechService = Get.find<SpeechService>();
    return Obx(() {
      final isPlaying = speechService.isCurrentTextPlaying(text);
      final isPaused = speechService.isPaused() &&
          speechService.currentText.trim().toLowerCase() ==
              text.trim().toLowerCase();

      // final isPaused = speechService.isTextPaused(text);
      print(
          'SpeechButton: isPlaying= [32m$isPlaying [0m, isPaused=$isPaused, currentText="${speechService.currentText}", buttonText="$text"');
      return GestureDetector(
        onTap: () {
          // // The speak method handles the toggle logic:
          // // - If playing same text -> pauses
          // // - If paused same text -> resumes
          // // - If not playing -> starts
          // speechService.speak(text);
          if (isPlaying) {
            // If currently playing, pause it
            speechService.pause();
          } else if (isPaused) {
            // If paused, resume it (will restart from beginning)
            speechService.resume();
          } else {
            // If not playing, start speaking
            speechService.speak(text);
          }
        },
        child: Container(
          padding: padding ?? const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: (color ?? Colors.blue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            isPlaying
                ? Icons.pause
                : (isPaused ? Icons.play_arrow : Icons.volume_up),
            size: size,
            color: color ?? Colors.blue,
          ),
        ),
      );
    });
  }
}
