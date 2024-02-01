import 'package:bridge_flutter/ui/widgets/buttons/button_basic_icon.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_select_sentence.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_text.dart';
import 'package:flutter/material.dart';

class SelectAnswerScreen extends StatefulWidget {
  final List conversationList;
  const SelectAnswerScreen({super.key, required this.conversationList});

  @override
  State<SelectAnswerScreen> createState() => _SelectAnswerScreenState();
}

class _SelectAnswerScreenState extends State<SelectAnswerScreen> {
  final TextEditingController _controller = TextEditingController();
  final double _minWidth = 148;

  List<String> _sentences = [
    '차가운 아메리카노 주세요.',
    '언제까지 영업하시나요?',
    '먹고갈 수 있나요?',
    '화장실이 어디에요?',
  ];

  void _openTextInput() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: '직접 입력',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth =
        MediaQuery.of(context).size.width - 150; // 화면 너비에서 양쪽 패딩을 제외한 값

    // TextPainter를 사용하여 텍스트 너비 계산
    final textPainter = TextPainter(
      text: TextSpan(
        text: _controller.text.isEmpty ? '직접입력' : _controller.text,
        style: TextStyle(fontSize: 20), // TextField와 동일한 스타일 적용
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);

    // 계산된 텍스트 너비 사용, 단 최소 너비와 최대 너비 사이에서 결정
    double containerWidth = textPainter.width + 40; // 아이콘 너비와 padding 고려
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
                      widget.conversationList.last,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            Positioned(
              bottom: 50,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  for (var label in _sentences)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SelectSentenceButton(
                        label: label,
                        onPressed: () {},
                      ),
                    ),
                  SizedBox(height: 20),
                  Container(
                    width: containerWidth,
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      maxLines: null,
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
                        // TextField에서 텍스트가 변경될 때마다 상태 업데이트
                        setState(() {});
                      },
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
