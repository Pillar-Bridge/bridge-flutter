import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Overlay Example'),
          ),
          body: Column(
            children: <Widget>[
              MyOverlayWidget(),
              Text('Overlay 위젯을 클릭하여 뷰 추가하기'),
            ],
          )),
    );
  }
}

class MyOverlayWidget extends StatefulWidget {
  @override
  _MyOverlayWidgetState createState() => _MyOverlayWidgetState();
}

class _MyOverlayWidgetState extends State<MyOverlayWidget> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5.0, // 5.0는 뷰와 추가된 위젯 사이의 간격
        width: size.width,
        child: Material(
          elevation: 0.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(title: Text('첫 번째 항목')),
              ListTile(title: Text('두 번째 항목')),
              ListTile(title: Text('세 번째 항목')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOverlay(context),
      child: Container(
        color: Colors.blue,
        height: 100.0,
        child: Center(
          child: Text('클릭하여 뷰 추가하기', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
