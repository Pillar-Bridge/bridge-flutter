import 'package:flutter/material.dart';

class ChangeWord extends StatefulWidget {
  final String answer;

  const ChangeWord({Key? key, required this.answer}) : super(key: key);

  @override
  _ChangeWordState createState() => _ChangeWordState();
}

class _ChangeWordState extends State<ChangeWord> {
  late List<String> words;
  Map<String, List<String>> alternatives = {
    "[dish": ["steak", "soup", "fries"],
    "아메리카노": ["라떼", "에스프레소", "카푸치노"],
  };

  @override
  void initState() {
    super.initState();
    words = widget.answer.split(' ');
  }

  void showCustomMenu(
      BuildContext context, List<String> options, Offset position) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    String? selectedValue = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          Rect.fromPoints(
            overlay.globalToLocal(position),
            overlay.globalToLocal(position) + const Offset(1, 1), // 작은 오프셋 추가
          ),
          Offset.zero & overlay.size),
      items: options.map((String value) {
        return PopupMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(value, style: const TextStyle(fontSize: 20)),
            ),
          ),
        );
      }).toList(),
      color: Colors.transparent,
    );

    if (selectedValue != null) {
      setState(() {
        int index = words.indexOf(selectedValue);
        if (index != -1) {
          words[index] = selectedValue;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: words.map((word) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            showCustomMenu(
                context, alternatives[word] ?? [], details.globalPosition);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(word,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
          ),
        );
      }).toList(),
    );
  }
}
