import 'dart:async';

import 'package:bridge_flutter/controllers/voice_recorder.dart';
import 'package:bridge_flutter/ui/screens/select_answer_screen.dart';
import 'package:bridge_flutter/ui/screens/voice_setting_screen.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_icon.dart';
import 'package:bridge_flutter/ui/widgets/progresses/progress_threedots.dart';
import 'package:flutter/material.dart';

enum ListeningState { ready, listening, waiting, finished }

class VoiceRecognitionScreen extends StatefulWidget {
  final int dialogueId;

  const VoiceRecognitionScreen({super.key, required this.dialogueId});

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen> {
  ListeningState _listeningState = ListeningState.ready;
  Timer? _timer;
  String recordedText = '';
  List<String> conversationList = [];
  final VoiceRecorder _voiceRecorder = VoiceRecorder();

  // SelectAnswerScreen으로 이동하는 함수
  void _navigateToSelectAnswerScreen() async {
    final updatedList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SelectAnswerScreen(conversationList: conversationList),
      ),
    );

    if (updatedList != null) {
      setState(() {
        conversationList = List<String>.from(updatedList);
      });
    }

    _listeningState = ListeningState.ready;
  }

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
                    : Expanded(
                        child: _listeningState == ListeningState.ready &&
                                conversationList.isNotEmpty
                            // 대화 목록이 있을 때 마지막 대화를 표시
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (conversationList.length > 1)
                                    // 음성인식 된 내용
                                    Text(
                                      conversationList[
                                          conversationList.length - 2],
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 40,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  if (conversationList.isNotEmpty)
                                    // 선택한 답변
                                    Text(
                                      conversationList.last,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              )
                            // 대화 목록이 없을 때 처음 안내 문구 표시
                            : Text(
                                _listeningState == ListeningState.ready
                                    ? '상대방의 말이 이곳에 표시됩니다.'
                                    : _listeningState ==
                                            ListeningState.listening
                                        ? '목소리를 듣고 있는 중입니다...'
                                        : _listeningState ==
                                                ListeningState.finished
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
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: IconToggleButton(
        toggleColor: Color(0xFF3787FF),
        icon: _listeningState == ListeningState.ready
            ? Icons.hearing
            : Icons.pause_rounded,
        label: _listeningState == ListeningState.ready ? '듣기' : '중지',
        isToggled: _listeningState == ListeningState.ready,
        onPressed: () {
          setState(() {
            if (_listeningState == ListeningState.ready) {
              _listeningState = ListeningState.listening;

              _voiceRecorder.startRecording();

              _timer = Timer(Duration(seconds: 3), () {
                setState(() {
                  _listeningState = ListeningState.waiting;
                });

                _voiceRecorder.stopRecording();

                _timer = Timer(Duration(seconds: 3), () {
                  recordedText = '음성인식된 내용입니다.';

                  setState(() {
                    _listeningState = ListeningState.finished;
                  });
                  conversationList.add(recordedText);
                  setState(() {
                    _listeningState = ListeningState.finished;
                    // 녹음 완료 상태 로직...
                  });
                  _navigateToSelectAnswerScreen();
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
