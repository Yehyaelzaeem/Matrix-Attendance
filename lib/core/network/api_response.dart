class ApiResponse<T> {
  const ApiResponse({
    required this.message,
    required this.status,
    this.data,
  });

  final String message;
  final bool status;
  final T? data;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse<T>(
      message: json['message'] as String? ?? '',
      status: json['status'] as bool? ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
