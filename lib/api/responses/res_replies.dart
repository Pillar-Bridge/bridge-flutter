class RepliesData {
  final String? situation;
  final List<String> response;

  RepliesData({
    this.situation,
    required this.response,
  });

  factory RepliesData.fromJson(Map<String, dynamic> json) {
    return RepliesData(
      situation: json['situation'],
      response: List<String>.from(json['response']),
    );
  }
}
