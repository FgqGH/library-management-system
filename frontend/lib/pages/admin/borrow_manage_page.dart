import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../api/dio_client.dart';
import '../../api/api_result.dart';
import '../../models/borrow_record.dart';

class BorrowManagePage extends StatefulWidget {
  const BorrowManagePage({super.key});
  @override
  State<BorrowManagePage> createState() => _BorrowManagePageState();
}

class _BorrowManagePageState extends State<BorrowManagePage> {
  List<BorrowRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final resp = await DioClient().get('/borrows', params: {'page': 1, 'limit': 100});
      final result = ApiResult.fromJson(resp.data, (d) => d);
      if (result.isSuccess) {
        final pageData = PageData<BorrowRecord>.fromJson(
            result.data as Map<String, dynamic>, BorrowRecord.fromJson);
        setState(() => _records = pageData.records);
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'RETURNED': return Colors.green;
      case 'BORROWED': return Colors.blue;
      case 'OVERDUE': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('借阅管理'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/admin')),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final r = _records[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _statusColor(r.status).withAlpha(26),
                      child: Icon(Icons.book, color: _statusColor(r.status)),
                    ),
                    title: Text('图书 #${r.bookId}'),
                    subtitle: Text('读者ID: ${r.readerId} · 借阅: ${r.borrowDate?.toString().substring(0, 10) ?? "-"}'),
                    trailing: Chip(label: Text(r.statusText, style: TextStyle(color: _statusColor(r.status)))),
                  ),
                );
              },
            ),
    );
  }
}
