import 'package:bridge_flutter/ui/screens/select_answer_screen.dart';
import 'package:flutter/material.dart';

enum ListeningState { ready, listening, waiting, finished }

class VoiceRecognitionScreen extends StatefulWidget {
  const VoiceRecognitionScreen({super.key});

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen> {
  ListeningState _listeningState = ListeningState.ready;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          gradient: _listeningState == ListeningState.waiting
              ? const RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.5,
                  colors: [Color.fromRGBO(7, 148, 255, 0.20), Colors.white],
                )
              : null,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        // TODO: Implement button action
                      },
                    ),
                  ],
                ),
                Text(
                  _listeningState == ListeningState.ready
                      ? '상대방의 말이 이곳에 표시됩니다.'
                      : _listeningState == ListeningState.listening
                          ? '목소리를 듣고 있는 중입니다...'
                          : _listeningState == ListeningState.waiting
                              ? '...'
                              : _listeningState == ListeningState.finished
                                  ? '완료'
                                  : '',
                  style: TextStyle(
                    color: _listeningState == ListeningState.ready
                        ? Color(0xFFB4B4B4)
                        : null,
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(28),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 20, bottom: 20),
        child: InkWell(
          onTap: () {
            setState(() {
              if (_listeningState == ListeningState.ready) {
                _listeningState = ListeningState.listening;

                Future.delayed(Duration(seconds: 3), () {
                  setState(() {
                    _listeningState = ListeningState.waiting;
                  });

                  Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      _listeningState = ListeningState.finished;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectAnswerScreen()),
                    );
                  });
                });
              } else if (_listeningState == ListeningState.listening) {
                _listeningState = ListeningState.ready;
              }
            });
          },
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: Row(
              key: ValueKey<bool>(_listeningState == ListeningState.listening),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    _listeningState == ListeningState.ready
                        ? Icons.mic
                        : Icons.stop,
                    color: Colors.white),
                SizedBox(width: 10),
                Text(_listeningState == ListeningState.ready ? '듣기' : '중지',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
