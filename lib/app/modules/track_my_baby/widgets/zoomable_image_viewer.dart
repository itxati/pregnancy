import 'package:flutter/material.dart';

class ZoomableImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? title;

  const ZoomableImageViewer({
    Key? key,
    required this.imageUrl,
    this.title,
  }) : super(key: key);

  @override
  State<ZoomableImageViewer> createState() => _ZoomableImageViewerState();
}

class _ZoomableImageViewerState extends State<ZoomableImageViewer> {
  final TransformationController _transformationController =
      TransformationController();
  final double _minScale = 1.0;
  final double _maxScale = 5.0;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < _maxScale) {
      final newScale = (currentScale * 1.5).clamp(_minScale, _maxScale);
      _transformationController.value = Matrix4.identity()..scale(newScale);
    }
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > _minScale) {
      final newScale = (currentScale / 1.5).clamp(_minScale, _maxScale);
      _transformationController.value = Matrix4.identity()..scale(newScale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.title ?? 'Image Viewer',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: _zoomOut,
            tooltip: 'Zoom Out',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: _zoomIn,
            tooltip: 'Zoom In',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetZoom,
            tooltip: 'Reset Zoom',
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: _minScale,
          maxScale: _maxScale,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Image.asset(
              widget.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Image not found',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.imageUrl,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
