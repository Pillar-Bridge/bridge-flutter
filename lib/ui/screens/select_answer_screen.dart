import 'package:bridge_flutter/ui/widgets/buttons/button_basic_icon.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_current_situation.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_select_sentence.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_text.dart';
import 'package:flutter/material.dart';

class SelectAnswerScreen extends StatefulWidget {
  final List<String> conversationList;
  final List<String> recommendedSentences;
  final String? situation;

  const SelectAnswerScreen(
      {super.key,
      required this.conversationList,
      required this.recommendedSentences,
      this.situation});

  @override
  State<SelectAnswerScreen> createState() => _SelectAnswerScreenState();
}

class _SelectAnswerScreenState extends State<SelectAnswerScreen> {
  List<String> get _sentences => widget.recommendedSentences;

  final TextEditingController _controller = TextEditingController();
  final double _minWidth = 148;
  List<String> _unselectedSentences = [];

  @override
  void initState() {
    super.initState();
    // 초기에 모든 문장을 unselectedSentences에 추가
    _unselectedSentences = List.from(_sentences);
  }

  void _addConversation(String text) {
    setState(() {
      widget.conversationList.add(text);
      // 선택된 문장을 unselectedSentences에서 제거
      _unselectedSentences.remove(text);
      print('conversationList: ${widget.conversationList.join(', ')}');
    });
    _controller.clear();
  }

  // SelectSentenceButton 클릭 이벤트
  void _onSentenceSelected(String sentence) {
    _addConversation(sentence);
    _navigateBack();
  }

// TextField에서 엔터를 누를 때 호출
  void _onSubmitted(String text) {
    if (text.isNotEmpty) {
      _addConversation(text);
      _navigateBack();
    }
  }

// `Navigator.pop`을 사용하여 `VoiceRecognitionScreen`으로 돌아가는 함수
  void _navigateBack() {
    Navigator.pop(context, {
      'selected': widget.conversationList,
      'unselected': _unselectedSentences,
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width - 150;

    final textPainter = TextPainter(
      text: TextSpan(
        text: _controller.text.isEmpty ? '직접입력' : _controller.text,
        style: const TextStyle(fontSize: 20),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);

    double containerWidth = textPainter.width + 40;
    containerWidth = containerWidth < _minWidth ? _minWidth : containerWidth;
    containerWidth = containerWidth > maxWidth ? maxWidth : containerWidth;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24, top: 60),
                  child: Text(
                    'The Other Person\'s Words',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                // 음성인식한 내용이 표시되는 부분
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
                  child: Text(
                    widget.conversationList.isNotEmpty
                        ? widget.conversationList.last
                        : "The other person's words will be displayed here.",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: widget.conversationList.isEmpty
                            ? Colors.grey
                            : Colors.black),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 50,
              right: 27,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  for (var sentence in _sentences)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SelectSentenceButton(
                        label: sentence.replaceAll('[', '').replaceAll(']', ''),
                        onPressed: () {
                          _onSentenceSelected(sentence);
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: containerWidth,
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.only(
                            left: 20, right: 20, top: 12, bottom: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: _controller.text.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.keyboard,
                                    color: Colors.white, size: 30),
                              )
                            : null,
                        hintText: 'Type',
                        hintStyle: const TextStyle(color: Colors.white),
                      ),
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: _onSubmitted,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 24,
              child: SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    // TODO: 추천 답변을 다시 가져오기
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ),
            ),
            Positioned(
                top: 6,
                right: 28,
                child: CurrentSituationButton(
                  situation: widget.situation ?? '',
                ))
          ],
        ),
      ),
    );
  }
}
