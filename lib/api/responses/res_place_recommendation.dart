class PlaceRecommendation {
  final String placeName;
  final String? categoryGroupName; // Nullable 타입으로 변경

  PlaceRecommendation({
    required this.placeName,
    this.categoryGroupName,
  });

  factory PlaceRecommendation.fromJson(Map<String, dynamic> json) {
    return PlaceRecommendation(
      placeName: json['place_name'],
      categoryGroupName: json['category_group_name'],
    );
  }
}
