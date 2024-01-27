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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24),
              child: Text(
                '상대방의 말',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(left: 24, top: 10),
                child: Text(
                  '안녕하세요. 주문 도와드리겠습니다.',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 50),
        child: ElevatedButton(
          onPressed: () {
            // 버튼 클릭시 행동
          },
          child: Text('선택한 장소로 시작하기'),
        ),
      ),
    );
    ;
  }
}
