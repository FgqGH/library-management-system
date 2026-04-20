import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../api/dio_client.dart';
import '../../api/api_result.dart';

class ReaderManagePage extends StatefulWidget {
  const ReaderManagePage({super.key});
  @override
  State<ReaderManagePage> createState() => _ReaderManagePageState();
}

class _ReaderManagePageState extends State<ReaderManagePage> {
  List<Map<String, dynamic>> _readers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final resp = await DioClient().get('/readers', params: {'page': 1, 'limit': 100});
      final result = ApiResult.fromJson(resp.data, (d) => d);
      if (result.isSuccess) {
        final pageData = PageData<Map<String, dynamic>>.fromJson(
            result.data as Map<String, dynamic>, (e) => Map<String, dynamic>.from(e));
        setState(() => _readers = pageData.records);
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('读者管理'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/admin')),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _readers.length,
              itemBuilder: (context, index) {
                final r = _readers[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(r['real_name']?.toString().isNotEmpty == true
                        ? r['real_name'][0] : '?')),
                    title: Text(r['real_name'] ?? ''),
                    subtitle: Text('${r['phone'] ?? "-"} · ${r['email'] ?? "-"}'),
                    trailing: Chip(
                      label: Text(r['status'] == 1 ? '正常' : '禁用'),
                      backgroundColor: (r['status'] == 1 ? Colors.green : Colors.red).withAlpha(30),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
