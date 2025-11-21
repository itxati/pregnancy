import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SpeechService extends GetxController {
  static SpeechService get instance => Get.find<SpeechService>();

  late FlutterTts flutterTts;
  bool isUrdu = true; // default
  final RxBool _isPlaying = false.obs;
  final RxString _currentText = ''.obs;
  final RxBool _isInitialized = false.obs;
  final RxBool _isPaused = false.obs;

  bool get isPlaying => _isPlaying.value;
  String get currentText => _currentText.value;
  bool get isInitialized => _isInitialized.value;

  @override
  void onInit() {
    super.onInit();
    initTts();
  }

  void initTts() async {
    flutterTts = FlutterTts();

    if (kIsWeb) {
      // Web: English
      isUrdu = false;
      await flutterTts.setLanguage("en-US");
    } else {
      // Mobile: Urdu
      isUrdu = true;
      await flutterTts.setLanguage("en-US");
    }

    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setVolume(1.0);

    // Try to find a female voice
    try {
      List<dynamic> voices = await flutterTts.getVoices;
      for (var voice in voices) {
        if (voice is Map &&
            voice['name'] != null &&
            voice['name'].toString().toLowerCase().contains("female")) {
          await flutterTts.setVoice({
            'name': voice['name'],
            'locale': voice['locale'],
          });
          break;
        }
      }
    } catch (e) {
      print("Voice selection error: $e");
    }

    // Set up handlers for play/pause state
    flutterTts.setStartHandler(() {
      print('[TTS] setStartHandler called');
      _isPlaying.value = true;
      _isPaused.value = false;
    });
    flutterTts.setCompletionHandler(() {
      print('[TTS] setCompletionHandler called');
      _isPlaying.value = false;
      _isPaused.value = false;
      _currentText.value = '';
    });
    flutterTts.setCancelHandler(() {
      print('[TTS] setCancelHandler called');
      _isPlaying.value = false;
      _isPaused.value = false;
      _currentText.value = '';
    });
    flutterTts.setPauseHandler(() {
      print('[TTS] setPauseHandler called');
      _isPlaying.value = false;
      _isPaused.value = true;
    });
    flutterTts.setContinueHandler(() {
      print('[TTS] setContinueHandler called');
      _isPlaying.value = true;
      _isPaused.value = false;
    });
    flutterTts.setErrorHandler((msg) {
      print('[TTS] setErrorHandler called: $msg');
      _isPlaying.value = false;
      _currentText.value = '';
    });

    _isInitialized.value = true;
    print("TTS initialized successfully");
  }

  Future<void> speak(String text) async {
    try {
      if (!_isInitialized.value) {
        print("TTS not initialized yet, trying to initialize...");
        initTts();
        await Future.delayed(const Duration(milliseconds: 500));
      }
      // If paused and same text, resume instead of restarting
      if (_isPaused.value && _currentText.value == text) {
        await resume();
        return;
      }
      // If already playing this text, pause it
      if (_isPlaying.value && _currentText.value == text) {
        await pause();
        return;
      }
      // If playing something else, stop and play new text
      if (_isPlaying.value && _currentText.value != text) {
        await stop();
      }
      _currentText.value = text;
      _isPaused.value = false;
      await flutterTts.speak(text);
    } catch (e) {
      print("Error in speak method: $e");
    }
  }

  Future<void> pause() async {
    try {
      await flutterTts.pause();
      _isPlaying.value = false;
    } catch (e) {
      print("Error in pause: $e");
    }
  }

  Future<void> resume() async {
    try {
      // FlutterTts doesn't have a direct resume method, so we restart from the beginning
      // This is a common limitation - we'll restart the speech
      if (_currentText.value.isNotEmpty && _isPaused.value) {
        final textToResume = _currentText.value;
        await flutterTts.stop();
        await Future.delayed(const Duration(milliseconds: 100));
        _isPaused.value = false;
        await flutterTts.speak(textToResume);
      }
    } catch (e) {
      print("Error in resume: $e");
    }
  }

  Future<void> stop() async {
    try {
      await flutterTts.stop();
      _isPlaying.value = false;
      _isPaused.value = false;
      _currentText.value = '';
    } catch (e) {
      print("Error in stop: $e");
    }
  }

  // Check if speech is paused (not playing but has current text)
  bool isPaused() {
    return _isPaused.value && _currentText.value.isNotEmpty;
  }

  // Check if specific text is paused
  bool isTextPaused(String text) {
    return _isPaused.value &&
        _currentText.value.trim().toLowerCase() == text.trim().toLowerCase();
  }

  bool isCurrentTextPlaying(String text) {
    return _isPlaying.value &&
        _currentText.value.trim().toLowerCase() == text.trim().toLowerCase();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
