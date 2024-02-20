import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenTextWidget extends StatefulWidget {
  final String text;
  const FullScreenTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  _FullScreenTextWidgetState createState() => _FullScreenTextWidgetState();
}

class _FullScreenTextWidgetState extends State<FullScreenTextWidget> {
  @override
  Widget build(BuildContext context) {
    // 여기에 가로 모드로 보여질 위젯의 레이아웃을 구현합니다.
    return Scaffold(
      body: Center(
        child: AutoSizeText(
          widget.text,
          style: const TextStyle(fontSize: 120),
          minFontSize: 20, // 최소 폰트 사이즈
          maxLines: 2, // 최대 줄 수
          overflow: TextOverflow.ellipsis, // 오버플로 처리
        ),
      ),
    );
  }
}
