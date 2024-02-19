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
  bool _isLoading = true; // API 호출 중인지 여부를 저장하는 변수
  TextEditingController placeController = TextEditingController();
  final double _minWidth = 148;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  void addNewPlace() {
    final String placeName = placeController.text.trim();
    if (placeName.isNotEmpty && !recommendations.contains(placeName)) {
      setState(() {
        recommendations.add(placeName);
        selectedPlace =
            placeName; // Optionally auto-select the newly added place
      });
      placeController.clear();
    }
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
    setState(() {
      _isLoading = true; // API 호출 시작 시 로딩 상태로 설정
    });
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // 실제 위치 정보를 사용하여 API 호출
      var result = await apiClient.getPlaceRecommendations(
          position.latitude, position.longitude);
      List<String> categories;
      if (result.isNotEmpty) {
        categories = result
            .map((recommendation) => recommendation.categoryGroupName)
            .toSet()
            .toList();
      } else {
        categories = ['영화관(예시)', '카페(예시)', '도서관(예시)']; // 예시 데이터
      }
      setState(() {
        recommendations = categories;
        _isLoading = false; // 데이터 로딩 완료
      });
    } catch (e) {
      // 에러 처리 부분에서 예시 데이터로 대체
      print("Error fetching place recommendations: $e");
      setState(() {
        recommendations = [
          '영화관(예시)',
          '카페(예시)',
          '도서관(예시)'
        ]; // API 호출 실패 시 예시 데이터 사용
        _isLoading = false; // 로딩 상태 해제
      });
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
                    // 직접 설정 버튼
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: placeController,
                              style: TextStyle(fontSize: 16.0),
                              showCursor: false,
                              decoration: InputDecoration(
                                hintText: "직접 설정",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors
                                          .black), // 포커스가 있을 때의 테두리 색상을 검정색으로 설정
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: addNewPlace,
                          ),
                        ],
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
