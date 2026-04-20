import 'package:flutter/material.dart';
import '../api/dio_client.dart';
import '../api/api_result.dart';
import '../models/book.dart';

class BookProvider extends ChangeNotifier {
  final DioClient _client = DioClient();
  List<Book> _books = [];
  int _total = 0;
  bool _loading = false;

  List<Book> get books => _books;
  int get total => _total;
  bool get loading => _loading;

  Future<void> fetchBooks({String? keyword, String? category, int page = 1, int limit = 20}) async {
    _loading = true;
    notifyListeners();
    try {
      final params = <String, dynamic>{'page': page, 'limit': limit};
      if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
      if (category != null && category.isNotEmpty) params['category'] = category;
      final resp = await _client.get('/books', params: params);
      final result = ApiResult.fromJson(resp.data, (d) => d);
      if (result.isSuccess && result.data != null) {
        final pageData = PageData<Book>.fromJson(result.data as Map<String, dynamic>, Book.fromJson);
        _books = pageData.records;
        _total = pageData.total;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> borrowBook(int bookId) async {
    final resp = await _client.post('/borrows', data: {'bookId': bookId});
    final result = ApiResult.fromJson(resp.data, null);
    return result.isSuccess;
  }
}
