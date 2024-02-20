import 'package:bridge_flutter/ui/widgets/buttons/button_basic.dart';
import 'package:flutter/material.dart';

class VoiceSettingScreen extends StatefulWidget {
  const VoiceSettingScreen({super.key});

  @override
  State<VoiceSettingScreen> createState() => _VoiceSettingScreenState();
}

class _VoiceSettingScreenState extends State<VoiceSettingScreen> {
  String _selectedGender = '남성';
  String _selectedAge = '어린 아이';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Remove the existing back button
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text(
                  '보이스톤 설정',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 24, top: 24),
                child: Text(
                  '성별',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 16),

              // sex selection buttons

              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedGender = '남성';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedGender == '남성'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedGender == '남성' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedGender == '남성'
                              ? Colors.lightBlue[50]
                              : Colors.white,
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 26),
                              child: Text(
                                '🙋🏻‍♂️',
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 26),
                              child: Text(
                                '남성',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedGender == '남성'
                                      ? const Color(0xFF3787FF)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedGender = '여성';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedGender == '여성'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedGender == '여성' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedGender == '여성'
                              ? Colors.lightBlue[50]
                              : Colors.white,
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 26),
                              child: Text(
                                '🙋🏻‍♀️',
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 26),
                              child: Text(
                                '여성',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedGender == '여성'
                                        ? const Color(0xFF3787FF)
                                        : Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.only(left: 24, top: 24, bottom: 14),
                child: Text(
                  '연령',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),

              // age selection buttons

              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAge = '어린 아이';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedAge == '어린 아이'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedAge == '어린 아이' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedAge == '어린 아이'
                              ? Colors.lightBlue[50]
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(
                            '어린 아이',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 14,
                                color: _selectedAge == '어린 아이'
                                    ? const Color(0xFF3787FF)
                                    : Colors.grey), // Set text color to grey
                          ), // Set text color to grey
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAge = '활기찬 성인';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedAge == '활기찬 성인'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedAge == '활기찬 성인' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedAge == '활기찬 성인'
                              ? Colors.lightBlue[50]
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(
                            '활기찬 성인',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 14,
                                color: _selectedAge == '활기찬 성인'
                                    ? const Color(0xFF3787FF)
                                    : Colors.grey), // Set text color to grey
                          ), // Set text color to grey
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAge = '지적인 중년';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedAge == '지적인 중년'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedAge == '지적인 중년' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedAge == '지적인 중년'
                              ? Colors.lightBlue[50]
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(
                            '지적인 중년',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 14,
                                color: _selectedAge == '지적인 중년'
                                    ? const Color(0xFF3787FF)
                                    : Colors.grey), // Set text color to grey
                          ), // Set text color to grey
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 24, right: 24, bottom: 50),
            child: BasicButton(
                label: '선택한 장소로 시작하기',
                onPressed: () {
                  Navigator.pop(context);
                })));
  }
}
