import 'package:flutter/material.dart';

import '../widgets/buttons.dart';

class CommonWidgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Common Widgets Test Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BasicButton(
                label: '테스트 버튼임',
                onPressed: () {
                  // 버튼 클릭 시 수행할 작업
                  print('Button clicked!');
                },
              ),
            ),
            // 다른 공용 위젯들을 여기에 추가
          ],
        ),
      ),
    );
  }
}
