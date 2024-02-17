class ApiResponse<T> {
  final bool isSuccess;
  final String message;
  final T data;

  ApiResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: fromJsonT(json['data']),
    );
  }
}
