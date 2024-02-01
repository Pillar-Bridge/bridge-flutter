import 'package:bridge_flutter/ui/screens/select_answer_screen.dart';
import 'package:bridge_flutter/ui/screens/select_place_screen.dart';
import 'package:bridge_flutter/ui/screens/voice_recognition_screen.dart';
import 'package:bridge_flutter/ui/constants/app_theme.dart';
import 'package:bridge_flutter/ui/screens/common_widget_test_screen.dart';
import 'package:bridge_flutter/ui/screens/voice_setting_screen.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_basic.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemeData.basicThemeData,
      title: 'Bridge',
      initialRoute: '/common_widget_test',
      routes: {
        '/': (context) => const SelectPlaceScreen(),
        '/voice': (context) => const VoiceRecognitionScreen(),
        '/voice_setting': (context) => const VoiceSettingScreen(),
        '/answer': (context) => const SelectAnswerScreen(conversationList: []),
        '/common_widget_test': (context) => CommonWidgetScreen(),
      },
    );
  }
}
