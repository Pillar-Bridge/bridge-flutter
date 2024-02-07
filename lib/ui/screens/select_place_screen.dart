import 'dart:convert';

import 'package:bridge_flutter/ui/widgets/buttons/button_basic.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_text.dart';
import 'package:flutter/material.dart';
import 'package:bridge_flutter/ui/screens/voice_recognition_screen.dart';
import 'package:http/http.dart' as http;

class SelectPlaceScreen extends StatefulWidget {
  const SelectPlaceScreen({super.key});

  @override
  State<SelectPlaceScreen> createState() => _SelectPlaceScreenState();
}

class _SelectPlaceScreenState extends State<SelectPlaceScreen> {
  // 예시 데이터
  final List<String> labels = [
    '영화관',
    '식당',
    '카페',
    '병원',
    '은행',
    '편의점',
    '약국',
    '주유소',
  ];

  String selectedPlace = ''; // 선택된 장소의 이름을 저장하는 변수

  void _navigateToVoiceRecognitionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VoiceRecognitionScreen()),
    );
  }

  // List<String> labels = []; // 초기 빈 리스트로 시작

  // @override
  // void initState() {
  //   super.initState();
  //   fetchPlaces(); // 위젯이 초기화될 때 데이터를 로드
  // }

  // API에서 장소 데이터를 가져오는 메소드
  // Future<void> fetchPlaces() async {
  //   try {
  //     var url = Uri.parse('http://203.253.71.189:5000/places/recommendations');
  //     var response = await http.post(url,
  //         body: jsonEncode({
  //           "latitude": 37.5665, // 예시 위도
  //           "longitude": 126.9780 // 예시 경도
  //         }),
  //         headers: {"Content-Type": "application/json"});

  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body);
  //       var documents = jsonResponse['data']['documents'];

  //       setState(() {
  //         labels = documents
  //             .map<String>((doc) => doc['category_group_name'])
  //             .toSet()
  //             .toList(); // 중복 제거 후 리스트로 변환
  //       });
  //     } else {
  //       print('Request failed with status: ${response.statusCode}.');
  //     }
  //   } catch (e) {
  //     print('Caught an exception: $e');
  //   }
  // }

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
              Padding(
                  padding: const EdgeInsets.only(left: 24, top: 10),
                  child: Text(
                    selectedPlace.isNotEmpty
                        ? selectedPlace
                        : '영화관', // 선택된 장소가 있으면 표시, 없으면 기본값 표시
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
                    return TextToggleButton(
                      isSelected: selectedPlace == label,
                      label: label,
                      onPressed: () {
                        setState(() {
                          selectedPlace = label;
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
