import 'package:bridge_flutter/api/api_client.dart';
import 'package:bridge_flutter/api/responses/place_recommendation.dart';
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
  ApiClient apiClient = ApiClient(); // ApiClient 인스턴스 생성
  List<String> recommendations = []; // 장소 추천 목록을 저장할 리스트

  String selectedPlace = ''; // 선택된 장소의 이름을 저장하는 변수
  bool _isLoading = true; // API 호출 중인지 여부를 저장하는 변수

  @override
  void initState() {
    super.initState();
    fetchPlaceRecommendations(); // API 호출
  }

  void fetchPlaceRecommendations() async {
    setState(() {
      _isLoading = true; // API 호출 중임을 표시
    });
    try {
      // API 호출을 통해 장소 추천 목록을 가져옵니다.
      var result = await apiClient.getPlaceRecommendations(37.5665, 126.9780);

      List<String> categories;
      if (result.isNotEmpty) {
        // API 결과가 있는 경우, categoryGroupName만 추출하고 중복 제거
        categories = result
            .map((recommendation) => recommendation.categoryGroupName)
            .toSet() // Set으로 변환하여 중복 제거
            .toList(); // 다시 List로 변환
      } else {
        // API 결과가 없는 경우, 예시 데이터 사용
        categories = ['영화관(예시)', '카페(예시)', '도서관(예시)']; // 예시 카테고리
      }

      setState(() {
        recommendations = categories; // 상태 업데이트
        _isLoading = false; // API 호출 완료
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
          child: _isLoading
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('장소 추천 목록을 불러오는 중입니다...'),
                    ),
                  ],
                ))
              : Column(
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
                              : '어디인가요?', // 선택된 장소가 있으면 표시, 없으면 기본값 표시
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 24, right: 24, top: 90),
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
              label: selectedPlace.isNotEmpty
                  ? '선택한 장소로 시작하기'
                  : '장소를 선택해주세요', // 버튼 라벨 조건부 설정
              onPressed: selectedPlace.isNotEmpty
                  ? () {
                      _navigateToVoiceRecognitionScreen();
                    }
                  : () {}, // 선택된 장소가 없으면 버튼 비활성화
            )));
  }
}
