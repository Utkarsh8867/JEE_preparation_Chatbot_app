

import 'package:flutter/material.dart';
import 'screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JEEChatbotApp());
}

class JEEChatbotApp extends StatelessWidget {
  const JEEChatbotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: StartScreen());
  }
}
