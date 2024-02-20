import 'package:bridge_flutter/api/api_client.dart';
import 'package:bridge_flutter/api/responses/res_place_recommendation.dart';
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
    setState(() {
      _isLoading = true; // API 호출 시작 시 로딩 상태로 설정
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // 실제 위치 정보를 사용하여 API 호출
    var result = await apiClient.getPlaceRecommendations(
        position.latitude, position.longitude);
    List<String> categories;
    if (result.isNotEmpty) {
      categories = result
          .map((recommendation) =>
              recommendation.categoryGroupName?.replaceAll("_", " "))
          .where((category) => category != null) // Filter out null values
          .map((category) => category!
              .split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ')) // Capitalize first letter of each word
          .map((category) => category
              .split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ')) // Capitalize first letter of each word
          .map((recommendation) => recommendation.replaceAll(" ", ""))
          .toSet()
          .toList();
    } else {
      categories = ['영화관(예시)', '카페(예시)', '도서관(예시)']; // 예시 데이터
    }
    setState(() {
      recommendations = categories;
      _isLoading = false; // 데이터 로딩 완료
    });
  }

  void _navigateToVoiceRecognitionScreen() async {
    try {
      // 선택된 장소로 API 호출하여 대화 아이디 받아오기
      print("Selected place: $selectedPlace");
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

  void _showPlaceInputDialog() {
    final TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('직접 장소 입력하기'),
          content: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(hintText: "장소를 입력해주세요"),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // 글자 색상을 검정색으로 설정
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // 글자 색상을 검정색으로 설정
              ),
              onPressed: () {
                setState(() {
                  selectedPlace = textEditingController.text.trim();
                });
                Navigator.of(context).pop();
                _navigateToVoiceRecognitionScreen();
              },
              child: const Text('완료'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Center(
                        child: Container(
                          width: 100, // Container의 너비를 100으로 설정
                          height: 25, // Container의 높이 설정
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // 배경색을 grey[200]으로 설정
                            borderRadius:
                                BorderRadius.circular(100), // 모서리 반경을 100으로 설정
                          ),
                          child: Center(
                            // Text를 Container 중앙에 배치
                            child: Text(
                              '🤔지금 당신은',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            selectedPlace.isNotEmpty
                                ? selectedPlace
                                : '어디에 있나요?', // 선택된 장소가 있으면 표시, 없으면 기본값 표시
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 24, right: 24, top: 200),
                      child: SizedBox(
                        height: 50, // 리스트 항목의 높이를 고정
                        child: ListView.builder(
                          itemCount: recommendations.length, // 리스트에 표시할 항목 수
                          scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                          itemBuilder: (context, index) {
                            final recommendation =
                                recommendations[index]; // 현재 항목
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 8), // 항목 간 간격
                              child: TextToggleButton(
                                isSelected: selectedPlace == recommendation,
                                label: recommendation,
                                onPressed: () {
                                  setState(() {
                                    selectedPlace = recommendation;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: Text('⚑ 위치기반 가장 가까운 장소 제안',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ))),
                  ],
                ),
        ),
        bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 24, right: 24, bottom: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: OutlinedButton(
                    onPressed: _showPlaceInputDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text(
                      '➕ 직접 장소 입력하기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w500, // Set the font weight to medium
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10), // 위젯 간 간격 설정 (20px
                BasicButton(
                  label: selectedPlace.isNotEmpty
                      ? '선택한 장소로 시작하기'
                      : '장소를 선택해주세요', // 버튼 라벨 조건부 설정
                  onPressed: selectedPlace.isNotEmpty
                      ? () {
                          _navigateToVoiceRecognitionScreen();
                        }
                      : () {
                          print('선택된 장소가 없습니다.');
                        }, // 선택된 장소가 없으면 버튼 비활성화
                ),
              ],
            )));
  }
}
