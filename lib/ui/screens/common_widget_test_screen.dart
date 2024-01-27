import 'package:bridge_flutter/ui/widgets/buttons/button_basic_icon.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_icon.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_text.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_icon.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_word_replacement.dart';
import 'package:flutter/material.dart';
import 'package:bridge_flutter/ui/widgets/progresses/progress_threedots.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextToggleButton(
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
                  child: TextToggleButton(
                    label: '선택형 - 선택 함',
                    onPressed: () {
                      // 버튼 클릭 시 수행할 작업
                      print('More buttons clicked!');
                    },
                    isSelected: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconToggleButton(
                icon: Icons.pause_rounded,
                toggleColor: Color(0xFF3787FF),
                isToggled: true,
                label: '토글됨',
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconToggleButton(
                icon: Icons.hearing,
                toggleColor: Color(0xFF3787FF),
                isToggled: false,
                label: '토글 안됨',
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconBasicButton(
                icon: Icons.keyboard,
                label: '아이콘 버튼',
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProgressThreeDots(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WordReplacementButton(
                    label: '단어1',
                    onPressed: () {
                      // 버튼 클릭 시 수행할 작업
                      print('Another button clicked!');
                    },
                    isSelected: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WordReplacementButton(
                    label: '단어2',
                    onPressed: () {
                      // 버튼 클릭 시 수행할 작업
                      print('Another button clicked!');
                    },
                    isSelected: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
