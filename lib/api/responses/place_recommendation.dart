class PlaceRecommendation {
  final String placeName;
  final String categoryGroupName;

  PlaceRecommendation({
    required this.placeName,
    required this.categoryGroupName,
  });

  factory PlaceRecommendation.fromJson(Map<String, dynamic> json) {
    return PlaceRecommendation(
      placeName: json['place_name'],
      categoryGroupName: json['category_group_name'],
    );
  }
}
