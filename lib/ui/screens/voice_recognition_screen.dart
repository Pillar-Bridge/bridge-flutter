import 'dart:async';
import 'dart:io';

import 'package:bridge_flutter/api/api_client.dart';
import 'package:bridge_flutter/api/responses/res_dialogue.dart';
import 'package:bridge_flutter/controllers/voice_recorder.dart';
import 'package:bridge_flutter/ui/screens/full_text_screen.dart';
import 'package:bridge_flutter/ui/screens/select_answer_screen.dart';
import 'package:bridge_flutter/ui/screens/voice_setting_screen.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_current_situation.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_select_sentence.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_suggestion_sentence.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_icon.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_word_replacement.dart';
import 'package:bridge_flutter/ui/widgets/progresses/progress_threedots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum ConversationState { TURN_PARTNER, TURN_USER }

enum ListeningState { ready, listening, finished }

class VoiceRecognitionScreen extends StatefulWidget {
  final String dialogueId;

  const VoiceRecognitionScreen({super.key, required this.dialogueId});

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen> {
  String get dialogueId => widget.dialogueId;
  String get situation =>
      (_dialogue?.place ?? "") +
      (_dialogue?.situation != null && _dialogue!.situation.isNotEmpty
          ? ", ${_dialogue?.situation}"
          : "");
  ApiClient apiClient = ApiClient(); // ApiClient 인스턴스 생성
  ListeningState _listeningState = ListeningState.ready;
  ConversationState _conversationState = ConversationState.TURN_PARTNER;
  List<String> conversationList = [];
  List<String> _unselectedSentences = [];
  String? _tempMessageSentYet;
  late AudioPlayer _audioPlayer;

  Dialogue? _dialogue;
  void updateDialogue() {
    apiClient.getDialogue(dialogueId).then((dialogue) {
      setState(() {
        _dialogue = dialogue;
      });
    });
  }

  bool _isAnalyzing = false;

  late stt.SpeechToText _speechToText;
  String _text = '';
  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _audioPlayer = AudioPlayer();
  }

  // 직접 입력한 문장을 처리하는 함수
  void _handleDirectInput() {
    String inputText = _editingController.text.trim(); // 입력된 텍스트 가져오기

    if (inputText.isNotEmpty) {
      setState(() {
        // 기존의 선택했던 맨 마지막 대화 문장을 제거
        if (conversationList.isNotEmpty) {
          conversationList.removeLast();
        }
        // 입력된 문장을 대화 목록에 추가
        conversationList.add(inputText);
        _tempMessageSentYet = inputText;
        // 입력 필드 초기화
        _editingController.clear();
      });
      print('conversationList: ${conversationList.join(', ')}');
    }
  }

  Future<void> playAudio(File audioFile) async {
    await _audioPlayer.setFilePath(audioFile.path);
    _audioPlayer.play();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // 답변 제안 목록 중 문장을 선택했을 때 호출되는 함수
  void _selectUnselectedSentence(String selectedSentence) {
    setState(() {
      if (conversationList.isNotEmpty) {
        conversationList.removeLast();
      }
      conversationList.add(selectedSentence);
      _tempMessageSentYet = selectedSentence;
      _unselectedSentences.remove(selectedSentence);
    });
    print('conversationList: ${conversationList.join(', ')}');
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
          localeId: 'en_US', // 한국어 음성 인식을 위한 로케일 ID 지정
          pauseFor: const Duration(seconds: 2),
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
  void _navigateToSelectAnswerScreen(List<String> recommendedSentences) async {
    setState(() {
      _conversationState = ConversationState.TURN_USER;
    });
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectAnswerScreen(
          conversationList: conversationList,
          recommendedSentences: recommendedSentences,
          situation: situation,
        ),
      ),
    );

    if (result != null && result is Map) {
      setState(() {
        conversationList = List<String>.from(result['selected'] ?? []);
        _tempMessageSentYet = conversationList.last;
        _unselectedSentences = List<String>.from(result['unselected'] ?? []);
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
      return 'Listen';
    } else if (_listeningState == ListeningState.listening) {
      return 'Stop';
    } else if (_listeningState == ListeningState.finished) {
      return 'Done';
    } else {
      return '';
    }
  }

  void _setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  String getVoiceSettings(String gender, String age, String lang) {
    String type = 'en-US-Wavenet-A';

    // 여기서는 예시로 'en-US'와 'ko-KR'에 대한 설정만 제공합니다.
    // 추가 언어를 지원하려면 이 로직을 확장하세요.
    if (lang == 'en-US') {
      if (gender == 'Male') {
        switch (age) {
          case 'Child':
            type = 'en-US-Wavenet-A';
            break;
          case 'Youth':
            type = 'en-US-Standard-A';
            break;
          case 'Adult':
            type = 'en-US-Casual-K';
            break;
        }
      } else {
        // Female
        switch (age) {
          case 'Child':
            type = 'en-US-Wavenet-H';
            break;
          case 'Youth':
            type = 'en-US-Neural2-H';
            break;
          case 'Adult':
            type = 'en-US-Standard-E';
            break;
        }
      }
    } else if (lang == 'ko-KR') {
      if (gender == 'Male') {
        switch (age) {
          case 'Child':
            type = 'ko-KR-Wavenet-D';
            break;
          case 'Youth':
            type = 'ko-KR-Wavenet-C';
            break;
          case 'Adult':
            type = 'ko-KR-Standard-C';
            break;
        }
      } else {
        // Female
        switch (age) {
          case 'Child':
            type = 'ko-KR-Wavenet-A';
            break;
          case 'Youth':
            type = 'ko-KR-Standard-D';
            break;
          case 'Adult':
            type = 'ko-KR-Standard-B';
            break;
        }
      }
    }
    return type;
  }

  void _toggleListeningState() async {
    _conversationState = ConversationState.TURN_PARTNER;
    if (_tempMessageSentYet != null) {
      await apiClient.createMessage(
          dialogueId, _tempMessageSentYet!, 'user', 'en');
    }
    setState(() {
      if (_listeningState == ListeningState.ready) {
        _startListening();
      } else if (_listeningState == ListeningState.listening) {
        _stopListening();
      } else if (_listeningState == ListeningState.finished) {
        submitPartnerMessage();
      }
    });
    print('Listening state: $_listeningState');
  }

  void submitPartnerMessage() async {
    if (_text.isNotEmpty) {
      setState(() {
        conversationList.add(_text);
        _isAnalyzing = true;
      });

      await apiClient.createMessage(dialogueId, _text, 'partner', 'en');

      updateDialogue();

      final conversations = await apiClient.getRecommendReplies(dialogueId);

      _navigateToSelectAnswerScreen(conversations.response);

      setState(() {
        _isAnalyzing = false;
      });
    }
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
        child: SizedBox(
          width: double.infinity,
          child: SafeArea(
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    _isAnalyzing
                        ? ProgressThreeDots()
                        : Expanded(
                            child: _listeningState == ListeningState.ready &&
                                    conversationList.isNotEmpty
                                // 대화 목록이 있을 때 마지막 대화를 표시
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        ChangeWord(
                                            answer: conversationList.last),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              final SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String gender =
                                                  prefs.getString('gender') ??
                                                      'Male';
                                              String age =
                                                  prefs.getString('age') ??
                                                      'Child';

                                              ApiClient()
                                                  .convertTextToSpeech(
                                                      conversationList.last,
                                                      "en-US",
                                                      getVoiceSettings(
                                                          gender, age, 'en-US'))
                                                  .then((value) =>
                                                      {playAudio(value)});
                                            },
                                            icon: const Icon(Icons.headset,
                                                color: Colors.grey),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              _setLandscapeMode();
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullScreenTextWidget(
                                                          text: conversationList
                                                              .last),
                                                ),
                                              );
                                              _resetOrientation();
                                            },
                                            icon: const Icon(Icons.tablet,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 40),
                                        child: Text(
                                            '⚑  ${_unselectedSentences.length} additional answer suggestions',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[500])),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: SizedBox(
                                          height: 60, // 버튼의 높이에 맞춰 조절
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                _unselectedSentences.length,
                                            itemBuilder: (context, index) {
                                              String labelWithoutBrackets =
                                                  _unselectedSentences[index]
                                                      .replaceAll('[', '')
                                                      .replaceAll(']', '');
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    right: 8), // 버튼 사이의 간격 조절
                                                child: SuggestionSentenceButton(
                                                  label: labelWithoutBrackets,
                                                  onPressed: () {
                                                    _selectUnselectedSentence(
                                                        _unselectedSentences[
                                                            index]);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          // 직접 추가한 답변을 입력하는 텍스트 필드
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFFF5F5F5)),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                reverse: true,
                                                child: TextField(
                                                  controller:
                                                      _editingController,
                                                  maxLines: null,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "Type to add",
                                                    border: InputBorder.none,
                                                  ),
                                                  showCursor: false,
                                                  style: const TextStyle(
                                                    color: Color(0xff595959),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // 직접 추가한 답변을 저장하는 버튼
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, bottom: 20),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFFF5F5F5)),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(Icons.check),
                                                onPressed: _handleDirectInput,
                                                color: Colors.blue,
                                                iconSize: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                // 대화 목록이 없을 때 처음 안내 문구 표시
                                : Text(
                                    _listeningState == ListeningState.ready
                                        ? '''The other person's words will be displayed here.'''
                                        : _listeningState ==
                                                ListeningState.listening
                                            ? _text.isNotEmpty
                                                ? _text
                                                : 'Please speak...'
                                            : _listeningState ==
                                                    ListeningState.finished
                                                ? _text.isNotEmpty
                                                    ? _text
                                                    : 'Please speak...'
                                                : 'Start speaking now',
                                    style: TextStyle(
                                      color: _text.isEmpty
                                          ? Colors.grey[300]
                                          : _listeningState ==
                                                  ListeningState.ready
                                              ? const Color(0xFFB4B4B4)
                                              : null,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                  ],
                ),
              ),
              Positioned(
                  top: 6,
                  right: 28,
                  child: Visibility(
                    visible: _conversationState == ConversationState.TURN_USER,
                    child: CurrentSituationButton(
                      situation: situation,
                    ),
                  ))
            ]),
          ),
        ),
      ),
      floatingActionButton: IntrinsicWidth(
        child: Row(
          children: [
            if (_listeningState == ListeningState.finished)
              SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    // 새로고침 버튼이 클릭되었을 때 실행될 코드를 여기에 작성합니다.
                    _retryListening();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              )
            else
              const SizedBox(),
            const SizedBox(width: 16),
            IconToggleButton(
              toggleColor: const Color(0xFF3787FF),
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
    "[dish": ["soup", "fries", "salad"],
    "more minutes": ["5 minutes", "10 minutes", "15 minutes"],
    "언제까지": ["늦게까지", "아침에도", "밤에도"],
    "화장실이": ["가까운 역이", "픽업대가", "나가는 길"]
  };
  TextEditingController? _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  String? _currentOverlayWord;

  // props가 변경될 때 호출되는 함수
  @override
  void didUpdateWidget(ChangeWord oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.answer != oldWidget.answer) {
      // 새로운 answer prop이 전달되면 words 상태를 업데이트합니다.
      setState(() {
        words =
            widget.answer.replaceAll('[', '').replaceAll(']', '').split(' ');
      });

      print(widget.answer);
      ApiClient().getModificationOptions(widget.answer).then((value) => {
            setState(() {
              print(value);
              alternatives = value;
            })
          });
    }
  }

  @override
  void dispose() {
    _editingController?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    words = widget.answer.replaceAll('[', '').replaceAll(']', '').split(' ');
    _editingController = TextEditingController();

    print(widget.answer);
    ApiClient().getModificationOptions(widget.answer).then((value) => {
          setState(() {
            print(value);
            alternatives = value;
          })
        });
  }

  void _printAlternatives() {
    print(alternatives);
  }

  void _showOverlay(
      BuildContext context, List<String> options, GlobalKey key, String word) {
    // 현재 클릭된 단어가 이미 활성화된 오버레이와 같은 경우, 오버레이를 닫음
    if (_currentOverlayWord == word) {
      _closeOverlayMenu();
      return;
    }

    _editingController!.clear();

    _currentOverlayWord = word;

    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    // 이전에 표시된 오버레이가 있으면 제거
    _overlayEntry?.remove();

    // 새로운 오버레이를 생성하고 표시
    _overlayEntry =
        _createOverlayEntry(context, options, position, renderBox.size, word);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeOverlayMenu() {
    _overlayEntry?.remove();
    _editingController!.clear();
    _overlayEntry = null;
    _currentOverlayWord = null;
  }

  void _replaceWord(String currentWord, String newWord) {
    int index =
        words.lastIndexWhere((element) => element.contains(currentWord));
    words[index] = newWord; // 선택한 단어로 교체
    print(alternatives);
    print(words.join(" "));
    // TODO : API 호출을 통해 새로운 문장(words)에 대한 새로운 대체 단어들 불러오기 로직 수행
  }

  OverlayEntry _createOverlayEntry(BuildContext context, List<String> options,
      Offset position, Size size, String currentWord) {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + size.height,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...options.map((String option) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: WordReplacementButton(
                    label: option,
                    isSelected: false,
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
              Row(
                children: [
                  Container(
                    width: 120,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _editingController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: "Type to add",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          setState(() {
                            // 직접 추가한 단어로 교체
                            _replaceWord(currentWord, _editingController!.text);
                          });
                          // 텍스트 필드 초기화
                          _editingController!.clear();
                          _printAlternatives();

                          _overlayEntry?.remove();
                          _overlayEntry = null;
                        },
                        color: Colors.blue,
                        iconSize: 24,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _closeOverlayMenu,
      child: Wrap(
        children: words.map((word) {
          final GlobalKey key = GlobalKey();

          // 대체 가능한 단어인지 확인
          bool isReplaceable =
              alternatives.keys.where((key) => word.contains(key)).isNotEmpty;

          return GestureDetector(
            key: key,
            onTap: () {
              if (isReplaceable) {
                String? matchingKey;

                try {
                  // 특정 단어에 포함된 첫 번째 키를 시도하여 찾습니다.
                  matchingKey =
                      alternatives.keys.firstWhere((key) => word.contains(key));
                } catch (e) {
                  // 일치하는 요소가 없으면 예외가 발생합니다.
                  // 여기서는 matchingKey가 이미 null로 초기화되어 있으므로 추가 조치를 취하지 않아도 됩니다.
                }

// 일치하는 키가 있을 경우 해당 키의 값을 사용합니다.
                final List<String> values =
                    matchingKey != null ? alternatives[matchingKey]! : [];

// _showOverlay 함수를 호출하며 찾아낸 값(또는 빈 리스트)을 전달합니다.
                _showOverlay(context, values, key, word);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                word,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight:
                      isReplaceable ? FontWeight.w600 : FontWeight.normal,
                  // 대체 가능한 단어일 경우 파란색과 밑줄을 추가
                  color: isReplaceable ? Colors.blue : Colors.black,
                  decoration: isReplaceable
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: Colors.blue,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
