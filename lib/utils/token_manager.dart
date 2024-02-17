import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TokenManager {
  static const _tokenKey = 'deviceToken';

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // 이미 저장된 토큰이 있는지 확인
    String? token = prefs.getString(_tokenKey);

    if (token == null) {
      // 토큰이 없으면 새로운 UUID를 생성
      var uuid = Uuid();
      token = uuid.v4();
      // 생성된 토큰을 로컬 저장소에 저장
      await prefs.setString(_tokenKey, token);
    }

    return token;
  }
}
