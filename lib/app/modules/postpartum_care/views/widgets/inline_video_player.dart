import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class InlineVideoPlayer extends StatefulWidget {
  final String assetPath;
  const InlineVideoPlayer({super.key, required this.assetPath});

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _muted = true;
  bool _lastIsPlaying = false;

  void _onControllerUpdate() {
    final isPlaying = _controller.value.isPlaying;
    if (isPlaying != _lastIsPlaying && mounted) {
      setState(() {
        _lastIsPlaying = isPlaying;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..addListener(_onControllerUpdate)
      ..initialize().then((_) {
        if (!mounted) return;
        _controller.setVolume(0);
        _controller.play();
        setState(() {
          _initialized = true;
          _muted = true;
          _lastIsPlaying = _controller.value.isPlaying;
        });
      });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const CircularProgressIndicator(),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio == 0
          ? 16 / 9
          : _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: VideoPlayer(_controller),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _muted = !_muted;
                      _controller.setVolume(_muted ? 0 : 1);
                    });
                  },
                  icon: Icon(
                    _muted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                  ),
                ),
                // Expanded(
                //   child: VideoProgressIndicator(
                //     _controller,
                //     allowScrubbing: true,
                //     colors: VideoProgressColors(
                //       playedColor: Colors.white,
                //       bufferedColor: Colors.white54,
                //       backgroundColor: Colors.white30,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
