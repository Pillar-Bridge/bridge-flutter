import 'package:bridge_flutter/ui/widgets/buttons/button_select.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons/button_basic.dart';

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
                label: '기본 버튼',
                onPressed: () {
                  // 버튼 클릭 시 수행할 작업
                  print('Button clicked!');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectButton(
                label: '선택형 - 선택 안함',
                onPressed: () {
                  // 버튼 클릭 시 수행할 작업
                  print('Another button clicked!');
                },
                isSelected: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectButton(
                label: '선택형 - 선택 함',
                onPressed: () {
                  // 버튼 클릭 시 수행할 작업
                  print('More buttons clicked!');
                },
                isSelected: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BasicButton(
                label: '추가 버튼 1',
                onPressed: () {
                  // 버튼 클릭 시 수행할 작업
                  print('Additional button 1 clicked!');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BasicButton(
                label: '추가 버튼 2',
                onPressed: () {
                  // 버튼 클릭 시 수행할 작업
                  print('Additional button 2 clicked!');
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
