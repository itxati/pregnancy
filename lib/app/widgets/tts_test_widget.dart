import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSTestWidget extends StatefulWidget {
  const TTSTestWidget({Key? key}) : super(key: key);

  @override
  State<TTSTestWidget> createState() => _TTSTestWidgetState();
}

class _TTSTestWidgetState extends State<TTSTestWidget> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  String status = "Not initialized";

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  Future<void> _initTTS() async {
    try {
      setState(() {
        status = "Initializing...";
      });

      // Set language
      await flutterTts.setLanguage("en-US");
      
      // Set speech rate
      await flutterTts.setSpeechRate(0.5);
      
      // Set volume
      await flutterTts.setVolume(1.0);
      
      // Set pitch
      await flutterTts.setPitch(1.0);

      // Set handlers
      flutterTts.setStartHandler(() {
        setState(() {
          isPlaying = true;
          status = "Playing...";
        });
      });

      flutterTts.setCompletionHandler(() {
        setState(() {
          isPlaying = false;
          status = "Completed";
        });
      });

      flutterTts.setErrorHandler((msg) {
        setState(() {
          isPlaying = false;
          status = "Error: $msg";
        });
      });

      setState(() {
        status = "Ready";
      });
    } catch (e) {
      setState(() {
        status = "Error: $e";
      });
    }
  }

  Future<void> _speak() async {
    try {
      setState(() {
        status = "Attempting to speak...";
      });
      
      await flutterTts.speak("Hello, this is a test of text to speech functionality.");
    } catch (e) {
      setState(() {
        status = "Speak error: $e";
      });
    }
  }

  Future<void> _stop() async {
    try {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
        status = "Stopped";
      });
    } catch (e) {
      setState(() {
        status = "Stop error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TTS Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Status: $status',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isPlaying ? null : _speak,
              child: Text(isPlaying ? 'Playing...' : 'Speak Test'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isPlaying ? _stop : null,
              child: const Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
