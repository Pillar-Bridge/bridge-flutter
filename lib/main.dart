import 'package:bridge_flutter/ui/screens/select_answer_screen.dart';
import 'package:bridge_flutter/ui/screens/select_place_screen.dart';
import 'package:bridge_flutter/ui/screens/voice_recognition_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bridge',
      initialRoute: '/',
      routes: {
        '/': (context) => const SelectPlaceScreen(),
        '/voice': (context) => const VoiceRecognitionScreen(),
        '/answer': (context) => const SelectAnswerScreen()
      },
    );
  }
}
