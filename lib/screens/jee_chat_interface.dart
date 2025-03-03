


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import '../services/chatbot_api_service.dart';
import '../services/history_storage.dart';

class JEEChatInterface extends StatefulWidget {
  final String? initialPrompt;

  const JEEChatInterface({super.key, this.initialPrompt});

  @override
  State<JEEChatInterface> createState() => _JEEChatInterfaceState();
}

class _JEEChatInterfaceState extends State<JEEChatInterface> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _chatHistory = []; // Supports text & images
  final ChatbotApiService _chatbotService = ChatbotApiService();
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      _sendMessage(widget.initialPrompt!);
    }
  }

  Future<void> _sendMessage([String? presetMessage, File? image]) async {
    final message = presetMessage ?? _controller.text.trim();
    if (message.isEmpty && image == null || _isLoading) return;

    setState(() {
      _chatHistory.add({"role": "user", "message": message, "image": image});
      _controller.clear();
      _isLoading = true;
    });

    await HistoryStorage().addPrompt(message);

    try {
      final response = await _chatbotService.fetchJEEAnswer(message);
      setState(() {
        _chatHistory.add({"role": "bot", "message": response});
      });
    } catch (e) {
      setState(() {
        _chatHistory.add({
          "role": "bot",
          "message": "⚠️ Failed to fetch response.\nPlease check your internet connection."
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      _sendMessage("Uploaded an image:", image);
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      _sendMessage("Captured an image:", image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JEE Bot Chat", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: _chatHistory.isEmpty
                ? _buildEmptyState()
                : AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      itemCount: _chatHistory.length,
                      itemBuilder: (context, index) {
                        final chat = _chatHistory[index];
                        final isUser = chat['role'] == 'user';
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            horizontalOffset: isUser ? 100.0 : -100.0,
                            child: FadeInAnimation(
                              child: _buildChatBubble(chat),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 72),
          const SizedBox(height: 12),
          Text(
            "Start a conversation with JEE Bot!",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            "Ask any JEE-related questions.",
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> chat) {
    bool isUser = chat['role'] == 'user';
    String? message = chat['message'];
    File? image = chat['image'];

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[850],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message != null)
              Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            if (image != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image, color: Colors.white),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: _captureImage,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Ask JEE Bot...',
                hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
                filled: true,
                fillColor: Colors.grey[900],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _sendMessage(),
            borderRadius: BorderRadius.circular(28),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
