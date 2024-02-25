import 'package:bridge_flutter/ui/widgets/buttons/button_basic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoiceSettingScreen extends StatefulWidget {
  const VoiceSettingScreen({super.key});

  @override
  State<VoiceSettingScreen> createState() => _VoiceSettingScreenState();
}

class _VoiceSettingScreenState extends State<VoiceSettingScreen> {
  String _selectedGender = 'Male';
  String _selectedAge = 'Child';

  // 설정을 로드합니다.
  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedGender = prefs.getString('selectedGender') ?? 'Male';
      _selectedAge = prefs.getString('selectedAge') ?? 'Child';
    });
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', _selectedGender);
    await prefs.setString('age', _selectedAge);
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

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
                  'Voice Tone Setting',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 24, top: 24),
                child: Text(
                  'Gender',
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
                            _selectedGender = 'Male';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedGender == 'Male'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedGender == 'Male' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedGender == 'Male'
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
                                'Male',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedGender == 'Male'
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
                            _selectedGender = 'Female';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedGender == 'Female'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedGender == 'Female' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedGender == 'Female'
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
                                'Female',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedGender == 'Female'
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
                  'Age',
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
                            _selectedAge = 'Child';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedAge == 'Child'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedAge == 'Child' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedAge == 'Child'
                              ? Colors.lightBlue[50]
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(
                            'Child',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 14,
                                color: _selectedAge == 'Child'
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
                            _selectedAge = 'Young Adult';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedAge == 'Young Adult'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedAge == 'Young Adult' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedAge == 'Young Adult'
                              ? Colors.lightBlue[50]
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(
                            'Young Adult',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 14,
                                color: _selectedAge == 'Young Adult'
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
                            _selectedAge = 'Middle-aged';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedAge == 'Middle-aged'
                                  ? const Color(0xFF3787FF)
                                  : Colors.grey,
                              width: _selectedAge == 'Middle-aged' ? 2 : 1,
                            ),
                          ),
                          backgroundColor: _selectedAge == 'Middle-aged'
                              ? Colors.lightBlue[50]
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(
                            'Middle-aged',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 14,
                                color: _selectedAge == 'Middle-aged'
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
            label: 'Select Voice Tone',
            onPressed: () async {
              await _saveSettings(); // 설정 저장
              Navigator.pop(context);
            },
          ),
        ));
  }
}
