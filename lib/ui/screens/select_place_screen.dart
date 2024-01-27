import 'package:flutter/material.dart';
import 'package:bridge_flutter/ui/screens/voice_recognition_screen.dart';

class SelectPlaceScreen extends StatefulWidget {
  const SelectPlaceScreen({super.key});

  @override
  State<SelectPlaceScreen> createState() => _SelectPlaceScreenState();
}

class _SelectPlaceScreenState extends State<SelectPlaceScreen> {
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
              padding: EdgeInsets.only(left: 24),
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
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 90),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 10, // 예를 들어 10개의 장소 버튼
                itemBuilder: (context, index) {
                  // 여기서 각 장소에 대한 버튼을 구성합니다.
                  return ElevatedButton(
                    onPressed: () {
                      // 버튼 클릭시 행동
                    },
                    child: Text('장소 ${index + 1}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 50),
        child: ElevatedButton(
          onPressed: () {
            // 버튼 클릭시 행동
            _navigateToVoiceRecognitionScreen();
          },
          child: Text('선택한 장소로 시작하기'),
        ),
      ),
    );
  }
}
