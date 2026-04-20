import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../api/dio_client.dart';
import '../../api/api_result.dart';
import '../../models/book.dart';
import '../../providers/borrow_provider.dart';

class BookDetailPage extends StatefulWidget {
  final String id;
  const BookDetailPage({super.key, required this.id});
  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  Book? _book;
  bool _loading = true;
  bool _borrowing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    try {
      final resp = await DioClient().get('/books/${widget.id}');
      final result = ApiResult.fromJson(resp.data, Book.fromJson);
      if (result.isSuccess && result.data != null) {
        setState(() { _book = result.data; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _borrow() async {
    setState(() => _borrowing = true);
    final ok = await context.read<BorrowProvider>().borrowBook(int.parse(widget.id));
    if (!mounted) return;
    setState(() => _borrowing = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('借阅成功！')));
      _loadBook();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('借阅失败，库存可能不足')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书详情'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/books')),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('加载失败: $_error'))
              : _book == null
                  ? const Center(child: Text('图书不存在'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_book!.coverUrl != null)
                                Image.network(_book!.coverUrl!, width: 120, height: 180, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(width: 120, height: 180,
                                        color: Colors.grey[200], child: const Icon(Icons.book, size: 48))),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_book!.title, style: Theme.of(context).textTheme.headlineSmall),
                                    const SizedBox(height: 8),
                                    Text('作者：${_book!.author ?? "-"}'),
                                    Text('出版社：${_book!.publisher ?? "-"}'),
                                    Text('分类：${_book!.category ?? "-"}'),
                                    Text('ISBN：${_book!.isbn}'),
                                    const SizedBox(height: 8),
                                    Text('库存：${_book!.stock} / ${_book!.total}',
                                        style: TextStyle(color: _book!.stock > 0 ? Colors.green : Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_book!.description != null) ...[
                            const SizedBox(height: 24),
                            Text('简介', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(_book!.description!),
                          ],
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _book!.stock > 0 && !_borrowing ? _borrow : null,
                              icon: _borrowing
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Icon(Icons.book),
                              label: Text(_book!.stock > 0 ? '立即借阅' : '暂无库存'),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
