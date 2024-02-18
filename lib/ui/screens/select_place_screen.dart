import 'package:bridge_flutter/api/api_client.dart';
import 'package:bridge_flutter/api/responses/place_recommendation.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_basic.dart';
import 'package:bridge_flutter/ui/widgets/buttons/button_toggle_text.dart';
import 'package:flutter/material.dart';
import 'package:bridge_flutter/ui/screens/voice_recognition_screen.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class SelectPlaceScreen extends StatefulWidget {
  const SelectPlaceScreen({Key? key}) : super(key: key);

  @override
  State<SelectPlaceScreen> createState() => _SelectPlaceScreenState();
}

class _SelectPlaceScreenState extends State<SelectPlaceScreen> {
  ApiClient apiClient = ApiClient(); // ApiClient 인스턴스 생성
  List<String> recommendations = []; // 장소 추천 목록을 저장할 리스트

  String selectedPlace = ''; // 선택된 장소의 이름을 저장하는 변수

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  void checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle location permission denied forever
      return;
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      fetchPlaceRecommendations();
    }
  }

  void fetchPlaceRecommendations() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // API 호출을 통해 장소 추천 목록을 가져옵니다.
      var result = await apiClient.getPlaceRecommendations(
          position.latitude, position.longitude);
      // categoryGroupName만 추출하고, 중복 제거
      final categories = result
          .map((recommendation) => recommendation.categoryGroupName)
          .toSet() // Set으로 변환하여 중복 제거
          .toList(); // 다시 List로 변환

      setState(() {
        recommendations = categories; // 상태 업데이트
      });
    } catch (e) {
      // 에러 처리
      print("Error fetching place recommendations: $e");
    }
  }

  void _navigateToVoiceRecognitionScreen() async {
    try {
      // 선택된 장소로 API 호출하여 대화 아이디 받아오기
      var dialogueId = await apiClient.createDialogue(selectedPlace);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VoiceRecognitionScreen(dialogueId: dialogueId)),
      );
    } catch (e) {
      // 에러 처리
      print("Error creating dialogue: $e");
    }
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
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: recommendations.map((recommendation) {
                    return TextToggleButton(
                      isSelected: selectedPlace == recommendation,
                      label: recommendation,
                      onPressed: () {
                        setState(() {
                          selectedPlace = recommendation;
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
