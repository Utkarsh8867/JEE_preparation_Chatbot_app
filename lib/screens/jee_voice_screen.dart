

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../services/chatbot_api_service.dart';

class VoiceAssistantScreen extends StatefulWidget {
  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final ChatbotApiService _chatbotService = ChatbotApiService();

  String _spokenText = "";
  String _responseText = "";
  bool _isListening = false;
  bool _isLoadingResponse = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  // Future<void> _initTTS() async {
  //   await _flutterTts.setLanguage("en-US");
  //   await _flutterTts.setSpeechRate(0.5);
  //   await _flutterTts.setPitch(1.0);
  //   _flutterTts.setCompletionHandler(() {
  //     setState(() {
  //       _isSpeaking = false;
  //     });
  //   });
  // }



Future<void> _initTTS() async {
  try {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  } catch (e) {
    print("TTS Initialization Error: $e");
  }
}
  void _startListening() async {
    try {
      bool available = await _speechToText.initialize();

      if (available) {
        setState(() {
          _isListening = true;
          _spokenText = "";
          _responseText = "";
        });

        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _spokenText = result.recognizedWords;
            });
          },
        );
      } else {
        setState(() {
          _spokenText = "⚠️ Your device does not support speech recognition.";
        });
      }
    } catch (e) {
      setState(() {
        _spokenText =
            "⚠️ Unable to access your microphone.\nPlease check app permissions or your device settings.";
      });
      print("SpeechToText Plugin Error: $e");
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });

    if (_spokenText.isNotEmpty) {
      _fetchChatbotResponse(_spokenText);
    }
  }

  Future<void> _fetchChatbotResponse(String prompt) async {
    setState(() {
      _isLoadingResponse = true;
    });

    try {
      final response = await _chatbotService.fetchJEEAnswer(prompt);
      setState(() {
        _responseText = response;
        _speakResponse(response);
      });
    } catch (e) {
      setState(() {
        _responseText =
            "⚠️ Failed to fetch response. Please check your internet connection.";
      });
    } finally {
      setState(() {
        _isLoadingResponse = false;
      });
    }
  }

  void _speakResponse(String text) async {
    setState(() {
      _isSpeaking = true;
    });

    await _flutterTts.speak(text);
  }

  void _stopSpeaking() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Talking to JEE Bot",
          style: GoogleFonts.poppins(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isListening ? "Listening..." : "Tap the mic to speak",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),

          // Speaking animation
          if (_isSpeaking) _buildSpeakingAnimation(),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              _spokenText.isNotEmpty
                  ? 'You said: $_spokenText'
                  : 'Press the mic and ask your question.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 30),

          if (_isLoadingResponse)
            const CircularProgressIndicator(color: Colors.blue)
          else if (_responseText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "JEE Bot: $_responseText",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🎤 Mic Button
              IconButton(
                iconSize: 80,
                icon: Icon(
                  _isListening ? Icons.mic_off : Icons.mic,
                  color: _isListening ? Colors.redAccent : Colors.white,
                ),
                onPressed: _isListening ? _stopListening : _startListening,
              ),

              const SizedBox(width: 20),

              // 🛑 Stop Button (Only visible if speaking)
              if (_isSpeaking)
                IconButton(
                  iconSize: 80,
                  icon: const Icon(Icons.stop_circle, color: Colors.red),
                  onPressed: _stopSpeaking,
                ),
            ],
          ),
        ],
      ),
    );
  }

  // 🎶 Speaking Animation Effect
  Widget _buildSpeakingAnimation() {
    return Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.blueAccent,
                Colors.greenAccent,
                Colors.purpleAccent,
              ],
            ),
          ),
        )
        .animate(onComplete: (controller) => controller.repeat())
        .scale(duration: 1.seconds)
        .fadeOut(duration: 1.seconds);
  }
}
