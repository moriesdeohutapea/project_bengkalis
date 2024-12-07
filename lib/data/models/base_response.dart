class BaseResponse<T> {
  final int page;
  final dynamic results;
  final int totalPages;
  final int totalResults;

  BaseResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    final rawResults = json['results'];
    final dynamic parsedResults = _parseResults(rawResults, fromJsonT);

    return BaseResponse(
      page: json['page'] ?? 1,
      results: parsedResults,
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }

  static dynamic _parseResults<T>(dynamic rawResults, T Function(Map<String, dynamic>) fromJsonT) {
    if (rawResults is List) {
      return rawResults.map((e) => fromJsonT(e as Map<String, dynamic>)).toList();
    } else if (rawResults is Map<String, dynamic>) {
      return fromJsonT(rawResults);
    } else {
      return null;
    }
  }
}
