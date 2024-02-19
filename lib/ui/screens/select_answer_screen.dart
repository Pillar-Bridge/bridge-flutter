import 'package:bridge_flutter/ui/widgets/buttons/button_basic_icon.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_select_sentence.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_text.dart';
import 'package:flutter/material.dart';

class SelectAnswerScreen extends StatefulWidget {
  final List<String> conversationList;
  const SelectAnswerScreen({super.key, required this.conversationList});

  @override
  State<SelectAnswerScreen> createState() => _SelectAnswerScreenState();
}

class _SelectAnswerScreenState extends State<SelectAnswerScreen> {
  final TextEditingController _controller = TextEditingController();
  final double _minWidth = 148;
  List<String> _unselectedSentences = [];

  final List<String> _sentences = [
    '차가운 아메리카노 주세요.',
    '언제까지 영업하시나요?',
    '먹고갈 수 있나요?',
    '화장실이 어디에요?',
  ];

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
      print('conversationList: ' + widget.conversationList.join(', '));
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
        style: TextStyle(fontSize: 20),
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
                Padding(
                  padding: EdgeInsets.only(left: 24, top: 18),
                  child: Text(
                    '상대방의 말',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24, top: 10),
                  child: Text(
                    widget.conversationList.isNotEmpty
                        ? widget.conversationList.last
                        : "상대방의 말이 이곳에 표시됩니다.",
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
                      padding: const EdgeInsets.only(top: 20),
                      child: SelectSentenceButton(
                        label: sentence,
                        onPressed: () {
                          _onSentenceSelected(sentence);
                        },
                      ),
                    ),
                  SizedBox(height: 20),
                  Container(
                    width: containerWidth,
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: _controller.text.isEmpty
                            ? Icon(Icons.keyboard, color: Colors.white)
                            : null,
                        hintText: '직접입력',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: _onSubmitted,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 24,
              child: Container(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    // 새로고침 버튼이 클릭되었을 때 실행될 코드를 여기에 작성합니다.
                  },
                  child: Icon(Icons.refresh, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
