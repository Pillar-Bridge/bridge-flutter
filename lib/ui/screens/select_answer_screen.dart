import 'package:bridge_flutter/ui/widgets/buttons/button_select.dart';
import 'package:flutter/material.dart';

class SelectAnswerScreen extends StatefulWidget {
  const SelectAnswerScreen({super.key});

  @override
  State<SelectAnswerScreen> createState() => _SelectAnswerScreenState();
}

class _SelectAnswerScreenState extends State<SelectAnswerScreen> {
  @override
  Widget build(BuildContext context) {
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
                      '안녕하세요. 주문 도와드리겠습니다.',
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
                  SelectButton(
                    label: '차가운 아메리카노 주세요.',
                    onPressed: () {},
                    isSelected: false,
                  ),
                  SizedBox(height: 20),
                  SelectButton(
                    label: '언제까지 영업하시나요?',
                    onPressed: () {},
                    isSelected: false,
                  ),
                  SizedBox(height: 20),
                  SelectButton(
                    label: '먹고갈 수 있나요?',
                    onPressed: () {},
                    isSelected: false,
                  ),
                  SizedBox(height: 20),
                  SelectButton(
                    label: '화장실이 어디에요?',
                    onPressed: () {},
                    isSelected: false,
                  ),
                  SizedBox(height: 20),
                  SelectButton(
                    label: '직접 입력',
                    onPressed: () {},
                    isSelected: true,
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
