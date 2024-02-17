import 'package:bridge_flutter/api/responses/api_response.dart';
import 'package:bridge_flutter/api/responses/place_recommendation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl = 'http://54.66.101.3:8080';
  http.Client httpClient;

  ApiClient({http.Client? client}) : httpClient = client ?? http.Client();

  Future<List<PlaceRecommendation>> getPlaceRecommendations(
      double latitude, double longitude) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/places/recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'latitude': latitude, 'longitude': longitude}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      // 'data' 필드 내의 'documents' 리스트에 접근하여 PlaceRecommendation 객체 리스트를 생성
      List<PlaceRecommendation> placeRecommendations =
          (jsonResponse['data']['documents'] as List)
              .map((item) => PlaceRecommendation.fromJson(item))
              .toList();

      return placeRecommendations;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
