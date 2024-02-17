import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SttTestScreen extends StatefulWidget {
  const SttTestScreen({super.key});

  @override
  _SttTestScreenState createState() => _SttTestScreenState();
}

class _SttTestScreenState extends State<SttTestScreen> {
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if (status == "listening") {
            print('SpeechToText is listening');
            setState(() {
              _isListening = true;
            });
          } else if (status == "done") {
            print('SpeechToText is done');
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (error) {
          print('SpeechToText error: $error');
          setState(() {
            _isListening = false;
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        // 한국어 음성 인식을 활성화하기 위해 localeId를 'ko_KR'로 설정
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
          localeId: 'ko_KR', // 한국어 음성 인식을 위한 로케일 ID 지정
          pauseFor: Duration(seconds: 2),
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STT Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _text,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              style: ElevatedButton.styleFrom(
                primary: _isListening ? Colors.red : null,
              ),
              // _isListening의 값에 따라 버튼 텍스트를 동적으로 변경
              child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
            ),
          ],
        ),
      ),
    );
  }
}
