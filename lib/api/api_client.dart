import 'dart:convert';
import 'package:bridge_flutter/api/responses/place_recommendation.dart';
import 'package:bridge_flutter/utils/token_manager.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = 'http://54.66.101.3:8080';
  http.Client httpClient;

  ApiClient({http.Client? client}) : httpClient = client ?? http.Client();

  Future<dynamic> _sendRequest(String url,
      {String method = 'POST', Map<String, dynamic>? body}) async {
    String token = await TokenManager.getToken();

    var uri = Uri.parse('$baseUrl$url');
    http.Response response;

    if (method.toUpperCase() == 'POST') {
      response = await httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json', 'UUID': token},
        body: json.encode(body),
      );
    } else {
      throw UnimplementedError('HTTP method $method not implemented.');
    }

    DateTime now = DateTime.now();
    print(
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}");
    print('Request to $uri, token $token');
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to send request to $url: ${response.statusCode}');
    }
  }

  Future<List<PlaceRecommendation>> getPlaceRecommendations(
      double latitude, double longitude) async {
    final jsonResponse = await _sendRequest('/places/recommendations',
        body: {'latitude': latitude, 'longitude': longitude});

    List<PlaceRecommendation> placeRecommendations =
        (jsonResponse['data']['documents'] as List)
            .map((item) => PlaceRecommendation.fromJson(item))
            .toList();

    return placeRecommendations;
  }

  Future<int> createDialogue(String place) async {
    final jsonResponse =
        await _sendRequest('/dialogues', body: {'place': place});

    final dialogueId = jsonResponse['data']['dialogue_id'] as int;
    return dialogueId;
  }
}
