import 'package:flutter/material.dart';

class FullScreenTextWidget extends StatelessWidget {
  final String text;
  const FullScreenTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // 화면 중앙에 위치시킵니다.
      child: FittedBox(
        // 자식 위젯의 크기를 부모 위젯의 크기에 맞게 조절합니다.
        fit: BoxFit.cover, // 전체 화면을 꽉 채우도록 조절합니다.
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 20), // 기본 텍스트 크기를 설정합니다. FittedBox가 조절할 것입니다.
        ),
      ),
    );
  }
}
