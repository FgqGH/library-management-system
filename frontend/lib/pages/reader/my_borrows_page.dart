import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/borrow_provider.dart';

class MyBorrowsPage extends StatefulWidget {
  const MyBorrowsPage({super.key});
  @override
  State<MyBorrowsPage> createState() => _MyBorrowsPageState();
}

class _MyBorrowsPageState extends State<MyBorrowsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BorrowProvider>().fetchMyBorrows();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BorrowProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的借阅'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/')),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.records.isEmpty
              ? const Center(child: Text('暂无借阅记录'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.records.length,
                  itemBuilder: (context, index) {
                    final record = provider.records[index];
                    final isReturned = record.status == 'RETURNED';
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isReturned ? Colors.green[100] : Colors.orange[100],
                          child: Icon(isReturned ? Icons.check : Icons.book, color: isReturned ? Colors.green : Colors.orange),
                        ),
                        title: Text('图书 #${record.bookId}'),
                        subtitle: Text(
                          '借阅日期：${record.borrowDate?.toString().substring(0, 10) ?? "-"} · '
                          '应还日期：${record.dueDate?.toString().substring(0, 10) ?? "-"}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(record.statusText,
                                style: TextStyle(color: isReturned ? Colors.green : Colors.orange)),
                            if (!isReturned)
                              TextButton(
                                onPressed: () async {
                                  final ok = await provider.returnBook(record.id!);
                                  if (context.mounted && ok) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('归还成功！')));
                                  }
                                },
                                child: const Text('还书'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
