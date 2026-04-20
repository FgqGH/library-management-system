class ApiResult<T> {
  final int code;
  final String message;
  final T? data;

  ApiResult({required this.code, required this.message, this.data});

  factory ApiResult.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResult(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : json['data'],
    );
  }

  bool get isSuccess => code == 200;
}

class PageData<T> {
  final List<T> records;
  final int total;
  final int page;
  final int limit;

  PageData({required this.records, required this.total, required this.page, required this.limit});

  factory PageData.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PageData(
      records: (json['records'] as List).map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
    );
  }
}
