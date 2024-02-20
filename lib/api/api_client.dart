import 'dart:convert';
import 'package:bridge_flutter/api/responses/res_%08replies.dart';
import 'package:bridge_flutter/api/responses/res_dialogue.dart';
import 'package:bridge_flutter/api/responses/res_message_dialogue.dart';
import 'package:bridge_flutter/api/responses/res_place_recommendation.dart';
import 'package:bridge_flutter/utils/token_manager.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = 'http://54.66.101.3:8080';
  http.Client httpClient;

  ApiClient({http.Client? client}) : httpClient = client ?? http.Client();

  Future<dynamic> _sendRequest(String url,
      {String method = 'GET', Map<String, dynamic>? body}) async {
    String token = await TokenManager.getToken();

    var uri = Uri.parse('$baseUrl$url');
    http.Response response;

    if (method.toUpperCase() == 'GET') {
      uri = Uri.parse('$uri?${_mapToQueryParameters(body)}');
      response = await httpClient.get(
        uri,
        headers: {'Content-Type': 'application/json', 'UUID': token},
      );
    } else if (method.toUpperCase() == 'POST') {
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

  String _mapToQueryParameters(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) {
      return '';
    }

    return params.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
  }

  Future<List<PlaceRecommendation>> getPlaceRecommendations(
      double latitude, double longitude) async {
    final jsonResponse = await _sendRequest('/places/recommendations',
        method: 'GET', body: {'latitude': latitude, 'longitude': longitude});

    print(jsonResponse['data']);

    List<PlaceRecommendation> placeRecommendations =
        (jsonResponse['data']['documents'] as List)
            .map((item) => PlaceRecommendation.fromJson(item))
            .toList();

    return placeRecommendations;
  }

  Future<String> createDialogue(String place) async {
    final jsonResponse = await _sendRequest('/dialogues',
        body: {'place': place}, method: "POST");

    final dialogueId = jsonResponse['data']['dialogue_id'] as String;
    return dialogueId;
  }

  Future<MessageDialogue> createMessage(
      String dialogueId, String message, String speaker, String lang) async {
    final jsonResponse = await _sendRequest('/dialogues/$dialogueId/messages',
        body: {
          'text': message,
          'lang': lang,
          'speaker': speaker,
        },
        method: 'POST');

    final messageDialogue = MessageDialogue.fromJson(jsonResponse['data']);
    return messageDialogue;
  }

  Future<RepliesData> getRecommendReplies(String dialogueId) async {
    final jsonResponse = await _sendRequest('/recommend-replies',
        method: 'GET', body: {'dialogueId': dialogueId});

    return RepliesData.fromJson(jsonResponse['data']);
  }

  Future<RepliesData> get(String dialogueId) async {
    final jsonResponse = await _sendRequest('/recommend-replies',
        method: 'GET', body: {'dialogueId': dialogueId});

    return RepliesData.fromJson(jsonResponse['data']);
  }

  Future<Dialogue> getDialogue(String dialogueId) async {
    final jsonResponse =
        await _sendRequest('/dialogue/$dialogueId', method: 'GET');

    // Assuming the 'data' field in jsonResponse contains the dialogue details
    return Dialogue.fromJson(jsonResponse['data']);
  }

  Future<Map<String, List<String>>> getModificationOptions(
      String sentence) async {
    final jsonResponse = await _sendRequest('/provide-modification-options',
        method: 'POST', body: {'sentence': sentence});

    Map<String, List<String>> alternatives = {};

    // Check if the response includes the 'alternatives' data
    if (jsonResponse['data'] != null &&
        jsonResponse['data']['alternatives'] != null) {
      List<dynamic> alternativesList = jsonResponse['data']['alternatives'];
      for (var alternative in alternativesList) {
        String word = alternative['word'];
        List<String> options = List<String>.from(alternative['options']);
        alternatives[word] = options;
      }
    }

    return alternatives;
  }
}
