import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/article.dart';
import '../../services/article_service.dart';
import '../../utils/image_url_helper.dart';

class ImageDownloaderView extends StatefulWidget {
  const ImageDownloaderView({super.key});

  @override
  State<ImageDownloaderView> createState() => _ImageDownloaderViewState();
}

class _ImageDownloaderViewState extends State<ImageDownloaderView> {
  final Dio _dio = Dio();
  bool _isDownloading = false;
  String _status = '';
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _loadExistingImages();
  }

  Future<Directory> _getImagesDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/images');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<void> _loadExistingImages() async {
    final dir = await _getImagesDir();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) =>
            f.path.endsWith('.jpg') ||
            f.path.endsWith('.jpeg') ||
            f.path.endsWith('.png') ||
            f.path.endsWith('.webp'))
        .where((f) => _isValidImageFileSync(f))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    print(
        '[ImagePreview] images dir: ${dir.path}, valid images found: ${files.length}');
    setState(() {
      _images = files;
    });
  }

  String _extFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final last =
        uri?.pathSegments.isNotEmpty == true ? uri!.pathSegments.last : '';
    final dot = last.lastIndexOf('.');
    if (dot != -1 && dot < last.length - 1) {
      final ext = last.substring(dot + 1).toLowerCase();
      if (ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp') {
        return ext;
      }
    }
    return 'jpg';
  }

  bool _isValidImageBytes(List<int> data) {
    if (data.length < 4) return false;
    // JPEG
    if (data[0] == 0xFF && data[1] == 0xD8 && data[2] == 0xFF) return true;
    // PNG
    if (data[0] == 0x89 &&
        data[1] == 0x50 &&
        data[2] == 0x4E &&
        data[3] == 0x47) return true;
    // GIF
    if (data[0] == 0x47 && data[1] == 0x49 && data[2] == 0x46) return true;
    // WebP (RIFF header)
    if (data[0] == 0x52 &&
        data[1] == 0x49 &&
        data[2] == 0x46 &&
        data[3] == 0x46) return true;
    return false;
  }

  bool _isValidImageFileSync(File file) {
    try {
      final raf = file.openSync(mode: FileMode.read);
      final bytes = raf.readSync(16);
      raf.closeSync();
      return _isValidImageBytes(bytes);
    } catch (_) {
      return false;
    }
  }

  Future<bool> _downloadImageToFile(String url, String filepath) async {
    try {
      print('[Download]   -> GET $url');
      final response = await _dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          headers: const {
            'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
            'Cache-Control': 'no-cache',
          },
        ),
      );
      final data = response.data;
      if (data == null || !_isValidImageBytes(data)) {
        print('[Download]   xx Invalid bytes from $url');
        return false;
      }
      final file = File(filepath);
      await file.writeAsBytes(data, flush: true);
      print('[Download]   OK Saved ${file.path} (${data.length} bytes)');
      return true;
    } catch (_) {
      print('[Download]   !! Error fetching $url');
      return false;
    }
  }

  Future<bool> _tryDownloadWithAlternatives(
      String originalUrl, String filepath) async {
    List<String> candidates;
    if (ImageUrlHelper.isGoogleDriveUrl(originalUrl)) {
      candidates = ImageUrlHelper.getAlternativeGoogleDriveUrls(originalUrl);
      candidates.sort((a, b) {
        int score(String u) {
          if (u.contains('export=download')) return 0;
          if (u.contains('export=view')) return 1;
          if (u.contains('/view')) return 2;
          if (u.contains('/preview')) return 3;
          return 4;
        }

        return score(a).compareTo(score(b));
      });
    } else {
      candidates = [originalUrl];
    }

    for (final u in candidates) {
      print('[Download]   Trying candidate: $u');
      final ok = await _downloadImageToFile(u, filepath);
      if (ok) return true;
    }
    return false;
  }

  Future<void> _downloadAll() async {
    if (_isDownloading) return;
    setState(() {
      _isDownloading = true;
      _status = 'Preparing downloads...';
    });

    try {
      final articleService = Get.find<ArticleService>();
      // Ensure local lists are loaded
      final List<ArticleModel> all = [
        ...articleService.getPregnancyArticles(),
        ...articleService.getBabyArticles(),
      ];

      if (all.isEmpty) {
        setState(() {
          _status = 'No articles found.';
        });
        return;
      }

      final dir = await _getImagesDir();
      int success = 0;
      int fail = 0;
      print('[Download] Articles total: ${all.length}');

      for (int i = 0; i < all.length; i++) {
        final a = all[i];
        String url = a.image;
        if (url.isEmpty) continue;
        final ext = _extFromUrl(url);
        final safeId = a.id.isNotEmpty
            ? a.id
            : a.title.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
        final filepath = '${dir.path}/${safeId}_$i.$ext';

        setState(() {
          _status = 'Downloading ${i + 1}/${all.length}';
        });

        print(
            '[Download] [$i/${all.length}] START id="${a.id}" title="${a.title}"');
        final ok = await _tryDownloadWithAlternatives(url, filepath);
        if (ok) {
          success++;
          print('[Download] [$i/${all.length}] DONE -> $filepath');
        } else {
          try {
            final f = File(filepath);
            if (await f.exists()) await f.delete();
          } catch (_) {}
          fail++;
          print('[Download] [$i/${all.length}] FAIL');
        }
      }

      await _loadExistingImages();
      final imagesDir = await _getImagesDir();
      final totalFiles = imagesDir
          .listSync()
          .whereType<File>()
          .where((f) =>
              f.path.endsWith('.jpg') ||
              f.path.endsWith('.jpeg') ||
              f.path.endsWith('.png') ||
              f.path.endsWith('.webp'))
          .length;
      print(
          '[Download] Completed. Success: $success, Fail: $fail, Images on disk: $totalFiles');
      setState(() {
        _status =
            'Done: $success succeeded, $fail failed. Images on disk: $totalFiles';
      });
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Downloader Preview'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _isDownloading ? null : _downloadAll,
                  child: Text(_isDownloading
                      ? 'Downloading...'
                      : 'Download Article Images'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _loadExistingImages,
                  child: const Text('Refresh'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _status,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _images.isEmpty
                ? const Center(child: Text('No images downloaded yet.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      final file = _images[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(file, fit: BoxFit.cover),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
