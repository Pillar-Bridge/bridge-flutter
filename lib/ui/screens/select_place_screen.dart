import 'package:bridge_flutter/ui/widgets/buttons/button_basic.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_select.dart';
import 'package:flutter/material.dart';
import 'package:bridge_flutter/ui/screens/voice_recognition_screen.dart';

class SelectPlaceScreen extends StatefulWidget {
  const SelectPlaceScreen({super.key});

  @override
  State<SelectPlaceScreen> createState() => _SelectPlaceScreenState();
}

class _SelectPlaceScreenState extends State<SelectPlaceScreen> {
  final List<String> labels = [
    '영화관',
    '식당',
    '카페',
    '병원',
    '은행',
    '편의점',
    '약국',
    '주유소',
    '은행',
    '편의점',
    '약국',
    '주유소',
  ];

  int selectedIndex = -1; // 현재 선택된 버튼의 인덱스를 추적하는 상태

  void _navigateToVoiceRecognitionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VoiceRecognitionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 18),
                child: Text(
                  '지금 당신의 위치는',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 24, top: 10),
                  child: Text(
                    '영화관',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 90),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: labels.asMap().entries.map((entry) {
                    int index = entry.key;
                    String label = entry.value;
                    return SelectButton(
                      isSelected: selectedIndex == index,
                      label: label,
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 50),
            child: BasicButton(
                label: '선택한 장소로 시작하기',
                onPressed: () {
                  _navigateToVoiceRecognitionScreen();
                })));
  }
}
