import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceRecorder extends ChangeNotifier {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<bool> _checkAndRequestPermission() async {
    final hasPermission = await _audioRecorder.hasPermission();
    return hasPermission;
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/myRecording_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> startRecording() async {
    final hasPermission = await _checkAndRequestPermission();
    if (!hasPermission) {
      print("Microphone permission denied");
      return;
    }

    final path = await _getFilePath();

    const config = RecordConfig(encoder: AudioEncoder.aacLc);

    await _audioRecorder.start(config, path: path);
    _isRecording = true;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    final path = await _audioRecorder.stop();
    print("Recording saved to $path");
    _isRecording = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }
}
