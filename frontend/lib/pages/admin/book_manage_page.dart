import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../api/dio_client.dart';
import '../../api/api_result.dart';
import '../../models/book.dart';

class BookManagePage extends StatefulWidget {
  const BookManagePage({super.key});
  @override
  State<BookManagePage> createState() => _BookManagePageState();
}

class _BookManagePageState extends State<BookManagePage> {
  List<Book> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final resp = await DioClient().get('/books', params: {'page': 1, 'limit': 100});
      final result = ApiResult.fromJson(resp.data, (d) => d);
      if (result.isSuccess) {
        final pageData = PageData<Book>.fromJson(result.data as Map<String, dynamic>, Book.fromJson);
        setState(() => _books = pageData.records);
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书管理'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/admin')),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return Card(
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text('${book.author ?? "-"} · 库存: ${book.stock}/${book.total}'),
                    trailing: Chip(
                      label: Text(book.status == 1 ? '上架' : '下架'),
                      backgroundColor: (book.status == 1 ? Colors.green : Colors.grey).withAlpha(30),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
