import 'dart:async';

import 'package:bridge_flutter/controllers/voice_recorder.dart';
import 'package:bridge_flutter/ui/screens/select_answer_screen.dart';
import 'package:bridge_flutter/ui/screens/voice_setting_screen.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_icon.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_word_replacement.dart';
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
                                    ChangeWord(answer: conversationList.last),
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

class ChangeWord extends StatefulWidget {
  final String answer;

  const ChangeWord({Key? key, required this.answer}) : super(key: key);

  @override
  _ChangeWordState createState() => _ChangeWordState();
}

class _ChangeWordState extends State<ChangeWord> {
  late List<String> words;
  Map<String, List<String>> alternatives = {
    "차가운": ["뜨거운", "얼음이 든", "미지근한"],
    "아메리카노": ["라떼", "에스프레소", "카푸치노"],
  };
  OverlayEntry? _overlayEntry;
  String? _currentOverlayWord;

  @override
  void initState() {
    super.initState();
    words = widget.answer.split(' ');
  }

  void _showOverlay(
      BuildContext context, List<String> options, GlobalKey key, String word) {
    if (_currentOverlayWord == word) {
      _closeOverlayMenu();
      return;
    }

    _currentOverlayWord = word; // Update the current word

    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    // Create and show the overlay
    _overlayEntry =
        _createOverlayEntry(context, options, position, renderBox.size, word);
    Overlay.of(context)!.insert(_overlayEntry!);

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _closeOverlayMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _currentOverlayWord = null; // Clear the current word tracking
  }

  OverlayEntry _createOverlayEntry(BuildContext context, List<String> options,
      Offset position, Size size, String currentWord) {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...options.map((String option) {
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                child: WordReplacementButton(
                  label: option,
                  isSelected: false, // 필요에 따라 조건을 설정하여 isSelected 값을 변경
                  onPressed: () {
                    setState(() {
                      _replaceWord(currentWord, option);
                    });
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
              );
            }).toList(),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: WordReplacementButton(
                label: "직접 추가",
                isSelected: false,
                onPressed: () {
                  // Handle the action for adding word here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _replaceWord(String currentWord, String newWord) {
    int index = words.indexOf(currentWord);
    if (index != -1) {
      words[index] = newWord; // 선택한 단어로 교체
      if (alternatives[currentWord] != null) {
        alternatives[newWord] = alternatives[currentWord]!;
        alternatives[newWord]!.remove(newWord);
        alternatives[newWord]!.add(currentWord);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap your widget build logic as before, adding GestureDetector to call _showOverlay
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap:
          _closeOverlayMenu, // This will close the overlay if anywhere else on the screen is tapped
      child: Wrap(
        children: words.map((word) {
          final GlobalKey key = GlobalKey();
          return GestureDetector(
            key: key,
            onTap: () {
              _showOverlay(context, alternatives[word] ?? [], key, word);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(word,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
