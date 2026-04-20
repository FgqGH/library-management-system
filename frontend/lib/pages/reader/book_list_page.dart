import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});
  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().fetchBooks();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('图书列表'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: '搜索书名/作者/ISBN',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    provider.fetchBooks();
                  },
                ),
              ),
              onSubmitted: (value) => provider.fetchBooks(keyword: value),
            ),
          ),
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.books.length,
                    itemBuilder: (context, index) {
                      final book = provider.books[index];
                      return Card(
                        child: ListTile(
                          leading: book.coverUrl != null
                              ? Image.network(book.coverUrl!, width: 40, height: 56, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.book))
                              : const Icon(Icons.book, size: 40),
                          title: Text(book.title),
                          subtitle: Text('${book.author ?? '-'} · ${book.publisher ?? '-'} · 库存: ${book.stock}'),
                          trailing: Chip(
                            label: Text(book.stock > 0 ? '可借' : '已借完',
                                style: TextStyle(color: book.stock > 0 ? Colors.green : Colors.red)),
                            backgroundColor: (book.stock > 0 ? Colors.green : Colors.red).withAlpha(30),
                          ),
                          onTap: () => context.go('/books/${book.id}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
