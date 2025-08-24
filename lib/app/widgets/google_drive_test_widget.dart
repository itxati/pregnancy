import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/image_url_helper.dart';
import 'smart_image.dart';

class GoogleDriveTestWidget extends StatefulWidget {
  const GoogleDriveTestWidget({Key? key}) : super(key: key);

  @override
  State<GoogleDriveTestWidget> createState() => _GoogleDriveTestWidgetState();
}

class _GoogleDriveTestWidgetState extends State<GoogleDriveTestWidget> {
  final TextEditingController _urlController = TextEditingController();
  String? _convertedUrl;
  String? _testImageUrl;

  @override
  void initState() {
    super.initState();
    // Add a sample Google Drive URL for testing
    _urlController.text = 'https://drive.google.com/file/d/1ABC123DEF456/view';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Drive Image Test'),
        backgroundColor: Colors.pink[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Google Drive Image URLs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Google Drive URL',
                hintText: 'Paste your Google Drive share link here',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _convertUrl,
                  child: const Text('Convert URL'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _testImage,
                  child: const Text('Test Image'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_convertedUrl != null) ...[
              const Text(
                'Converted URL:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SelectableText(_convertedUrl!),
              ),
              const SizedBox(height: 16),
            ],
            if (_testImageUrl != null) ...[
              const Text(
                'Test Image:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SmartImage(
                    imageSource: _testImageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Supported URL Formats:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildUrlExample(
              'https://drive.google.com/file/d/FILE_ID/view',
              'Standard share link',
            ),
            _buildUrlExample(
              'https://drive.google.com/open?id=FILE_ID',
              'Open link',
            ),
            _buildUrlExample(
              'https://drive.google.com/uc?export=view&id=FILE_ID',
              'Direct export link',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlExample(String url, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.link, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  url,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _convertUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _convertedUrl = ImageUrlHelper.convertGoogleDriveUrl(url);
      });
    }
  }

  void _testImage() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _testImageUrl = ImageUrlHelper.convertGoogleDriveUrl(url);
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
