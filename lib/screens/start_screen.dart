import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'jee_chat_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (!isFirstLaunch) {
      // If the user has already opened the app before, directly navigate to JEEChatScreen
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const JEEChatScreen()),
        );
      });
    } else {
      // Mark that the app has been opened once
      await prefs.setBool('first_launch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Enlarged AI Image with Animation
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                      'assets/start.jpg',
                      fit: BoxFit.contain,
                      height: 300, // Increased size
                    )
                    .animate()
                    .fade(duration: 1.seconds)
                    .scale(duration: 1.seconds),
              ),
            ),

            // Animated Welcome Text
            Text(
              "Meet Sundae!",
              style: GoogleFonts.poppins(
                fontSize: 34, // Slightly bigger text
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fade(duration: 800.ms).slideY(begin: 0.5, end: 0),

            Text(
              "Your own AI assistant",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
            ).animate().fade(duration: 1.seconds, delay: 300.ms),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Text(
                "Ask your JEE-related questions and receive intelligent answers with Sundae AI.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16),
              ).animate().fade(duration: 1.seconds, delay: 600.ms),
            ),

            const SizedBox(height: 20),

            // Animated "Get Started" Button with Glow Effect
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.deepPurpleAccent,
                    elevation: 10,
                  ),
                  onPressed: () {
                    // Navigate to JEE Chat Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JEEChatScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Get Started",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ).animate().scale(duration: 600.ms, delay: 900.ms),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
