import 'dart:async';

import 'package:bridge_flutter/ui/screens/select_answer_screen.dart';
import 'package:bridge_flutter/ui/screens/voice_setting_screen.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_icon.dart';
import 'package:bridge_flutter/ui/widgets/progresses/progress_threedots.dart';
import 'package:flutter/material.dart';

enum ListeningState { ready, listening, waiting, finished }

class VoiceRecognitionScreen extends StatefulWidget {
  const VoiceRecognitionScreen({super.key});

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen> {
  ListeningState _listeningState = ListeningState.ready;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          gradient: _listeningState == ListeningState.waiting
              ? const RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.5,
                  colors: [Color.fromRGBO(7, 148, 255, 0.20), Colors.white],
                )
              : null,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VoiceSettingScreen()),
                        );
                      },
                    ),
                  ],
                ),
                _listeningState == ListeningState.waiting
                    ? ProgressThreeDots()
                    : Text(
                        _listeningState == ListeningState.ready
                            ? '상대방의 말이 이곳에 표시됩니다.'
                            : _listeningState == ListeningState.listening
                                ? '목소리를 듣고 있는 중입니다...'
                                : _listeningState == ListeningState.finished
                                    ? '완료'
                                    : '',
                        style: TextStyle(
                          color: _listeningState == ListeningState.ready
                              ? Color(0xFFB4B4B4)
                              : null,
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: IconToggleButton(
        toggleColor: Color(0xFF3787FF),
        icon: _listeningState == ListeningState.ready ? Icons.mic : Icons.stop,
        label: _listeningState == ListeningState.ready ? '듣기' : '중지',
        isToggled: _listeningState != ListeningState.ready,
        onPressed: () {
          setState(() {
            if (_listeningState == ListeningState.ready) {
              _listeningState = ListeningState.listening;

              _timer = Timer(Duration(seconds: 3), () {
                setState(() {
                  _listeningState = ListeningState.waiting;
                });

                _timer = Timer(Duration(seconds: 3), () {
                  setState(() {
                    _listeningState = ListeningState.finished;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectAnswerScreen()),
                  );
                });
              });
            } else if (_listeningState != ListeningState.ready) {
              _timer?.cancel();
              _listeningState = ListeningState.ready;
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
