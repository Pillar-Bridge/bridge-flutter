import 'dart:async';

import 'package:bridge_flutter/controllers/voice_recorder.dart';
import 'package:bridge_flutter/ui/screens/select_answer_screen.dart';
import 'package:bridge_flutter/ui/screens/voice_setting_screen.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_icon.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_word_replacement.dart';
import 'package:bridge_flutter/ui/widgets/progresses/progress_threedots.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum ListeningState { ready, listening, finished }

class VoiceRecognitionScreen extends StatefulWidget {
  final String dialogueId;

  const VoiceRecognitionScreen({super.key, required this.dialogueId});

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen> {
  ListeningState _listeningState = ListeningState.ready;
  List<String> conversationList = [];

  bool _isAnalyzing = false;

  late stt.SpeechToText _speechToText;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  void _startListening() async {
    if (_listeningState == ListeningState.ready ||
        _listeningState == ListeningState.finished) {
      _text = '';
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if (status == "listening") {
            print('SpeechToText is listening');
            setState(() {
              _listeningState = ListeningState.listening;
            });
          } else if (status == "done") {
            print('SpeechToText is done');
            setState(() {
              _listeningState = ListeningState.finished;
            });
          }
        },
        onError: (error) {
          print('SpeechToText error: $error');
          setState(() {
            _listeningState = ListeningState.finished;
          });
        },
      );

      if (available) {
        setState(() {
          _listeningState = ListeningState.listening;
        });

        // 한국어 음성 인식을 활성화하기 위해 localeId를 'ko_KR'로 설정
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
          localeId: 'ko_KR', // 한국어 음성 인식을 위한 로케일 ID 지정
          pauseFor: Duration(seconds: 2),
        );
      }
    }
  }

  void _stopListening() {
    if (_listeningState == ListeningState.listening) {
      _speechToText.stop();
      setState(() {
        _listeningState = ListeningState.ready;
      });
    }
  }

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

  IconData _getListeningIcon() {
    if (_listeningState == ListeningState.ready) {
      return Icons.hearing;
    } else if (_listeningState == ListeningState.listening) {
      return Icons.pause_rounded;
    } else if (_listeningState == ListeningState.finished) {
      return Icons.check;
    } else {
      return Icons.check;
    }
  }

  String _getListeningLabel() {
    if (_listeningState == ListeningState.ready) {
      return '듣기';
    } else if (_listeningState == ListeningState.listening) {
      return '중지';
    } else if (_listeningState == ListeningState.finished) {
      return '완료';
    } else {
      return '';
    }
  }

  void _toggleListeningState() {
    setState(() {
      if (_listeningState == ListeningState.ready) {
        _startListening();
      } else if (_listeningState == ListeningState.listening) {
        _stopListening();
      } else if (_listeningState == ListeningState.finished) {
        _navigateToSelectAnswerScreen();
      }
    });
  }

  void _retryListening() {
    if (_listeningState == ListeningState.finished) {
      setState(() {
        _startListening();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          gradient: _listeningState == ListeningState.listening
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
                _isAnalyzing
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
                                        ? _text.isNotEmpty
                                            ? _text
                                            : '말씀해주세요...'
                                        : _listeningState ==
                                                ListeningState.finished
                                            ? _text.isNotEmpty
                                                ? _text
                                                : '말씀해주세요...'
                                            : 'Present text speak now',
                                style: TextStyle(
                                  color: _text.isEmpty
                                      ? Colors.grey[300]
                                      : _listeningState == ListeningState.ready
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
      floatingActionButton: IntrinsicWidth(
        child: Row(
          children: [
            if (_listeningState == ListeningState.finished)
              FloatingActionButton(
                onPressed: _retryListening,
                child: Icon(Icons.refresh),
                shape: CircleBorder(),
              )
            else
              SizedBox(),
            const SizedBox(width: 16),
            IconToggleButton(
              toggleColor: Color(0xFF3787FF),
              icon: _getListeningIcon(),
              label: _getListeningLabel(),
              isToggled: _listeningState == ListeningState.listening,
              onPressed: _toggleListeningState,
            )
          ],
        ),
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
    Overlay.of(context).insert(_overlayEntry!);

    Overlay.of(context)?.insert(_overlayEntry!);
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
