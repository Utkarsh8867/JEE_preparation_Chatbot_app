




import 'package:chatbot_app/screens/PremiumPlanScreen.dart';
import 'package:chatbot_app/screens/jee_voice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/history_storage.dart';
import 'jee_chat_interface.dart';


class JEEChatScreen extends StatefulWidget {
  const JEEChatScreen({super.key});

  @override
  State<JEEChatScreen> createState() => _JEEChatScreenState();
}

class _JEEChatScreenState extends State<JEEChatScreen> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await HistoryStorage().getHistory();
      setState(() {
        _history = history;
      });
    } catch (e) {
      print('Failed to load history: $e');
      setState(() {
        _history = [];
      });
    }
  }

  void _openChatWithPrompt(String? prompt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JEEChatInterface(initialPrompt: prompt),
      ),
    ).then((_) => _loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumPlanSection(),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildFeatureCard("Chat with JEE Bot", Icons.chat, Colors.purple),
                  const SizedBox(width: 16),
                  _buildFeatureCard("Talk with JEE Bot", Icons.mic, Colors.yellow),
                ],
              ),
              const SizedBox(height: 28),
              _buildTopicsSection(),
              const SizedBox(height: 28),
              _buildHistorySection(),
              const SizedBox(height: 16),
              _buildHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumPlanSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.deepPurple, Colors.pink]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PREMIUM PLAN", // Capitalized to make it bolder
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,  // Larger text
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Unlock JEE Bot's\nfull potential with exclusive access\nto premium features.",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,  // Smaller text for contrast
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to PremiumPlanScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PremiumPlanScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text("Upgrade"),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Topics"),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAnimatedTopic("Physics", Icons.science, Colors.yellow, "Physics syllabus for JEE exam"),
            _buildAnimatedTopic("Chemistry", Icons.bubble_chart, Colors.pink, "Chemistry syllabus for JEE exam"),
            _buildAnimatedTopic("Math", Icons.calculate, Colors.blue, "Math syllabus for JEE exam"),
            _buildAnimatedTopic("Business", Icons.business, Colors.purple, "Business syllabus for JEE exam"),
          ],
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle("History"),
        TextButton(
          onPressed: () async {
            await HistoryStorage().clearHistory();
            _loadHistory();
          },
          child: Text(
            "Clear History",
            style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return Expanded(
      child: _history.isEmpty
          ? Center(
              child: Text(
                "No history yet.",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
            )
          : AnimationLimiter(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final prompt = _history[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () => _openChatWithPrompt(prompt),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade900.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              prompt,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color iconColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (title == "Chat with JEE Bot") {
            _openChatWithPrompt(null);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VoiceAssistantScreen()),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)],
          ),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 48),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTopic(String label, IconData icon, Color color, String prompt) {
    return GestureDetector(
      onTap: () => _openChatWithPrompt(prompt),
      child: Column(
        children: [
          Animate(
            effects: [
              ScaleEffect(delay: 100.ms, duration: 400.ms, curve: Curves.elasticOut),
            ],
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[850],
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.6), blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: Icon(icon, color: color, size: 30),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}
