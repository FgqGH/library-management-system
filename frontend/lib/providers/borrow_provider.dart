import 'package:flutter/material.dart';
import '../api/dio_client.dart';
import '../api/api_result.dart';
import '../models/borrow_record.dart';

class BorrowProvider extends ChangeNotifier {
  final DioClient _client = DioClient();
  List<BorrowRecord> _records = [];
  bool _loading = false;

  List<BorrowRecord> get records => _records;
  bool get loading => _loading;

  Future<void> fetchMyBorrows() async {
    _loading = true;
    notifyListeners();
    try {
      final resp = await _client.get('/borrows/my');
      final result = ApiResult.fromJson(resp.data, (d) => d);
      if (result.isSuccess && result.data != null) {
        final pageData = PageData<BorrowRecord>.fromJson(result.data as Map<String, dynamic>, BorrowRecord.fromJson);
        _records = pageData.records;
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

  Future<bool> returnBook(int recordId) async {
    final resp = await _client.put('/borrows/$recordId/return');
    final result = ApiResult.fromJson(resp.data, null);
    if (result.isSuccess) await fetchMyBorrows();
    return result.isSuccess;
  }
}
