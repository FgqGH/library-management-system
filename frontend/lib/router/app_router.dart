import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/auth/reader_login_page.dart';
import '../pages/auth/admin_login_page.dart';
import '../pages/reader/reader_home_page.dart';
import '../pages/reader/book_list_page.dart';
import '../pages/reader/book_detail_page.dart';
import '../pages/reader/my_borrows_page.dart';
import '../pages/admin/admin_home_page.dart';
import '../pages/admin/book_manage_page.dart';
import '../pages/admin/reader_manage_page.dart';
import '../pages/admin/borrow_manage_page.dart';

final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role');
    final isAuth = ['/login', '/admin/login'].contains(state.uri.toString());
    if (token == null && !isAuth) return '/login';
    if (token != null && isAuth) {
      return role == 'READER' ? '/' : '/admin';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, _) => const ReaderLoginPage()),
    GoRoute(path: '/admin/login', builder: (context, _) => const AdminLoginPage()),
    GoRoute(path: '/', builder: (context, _) => const ReaderHomePage()),
    GoRoute(path: '/books', builder: (context, _) => const BookListPage()),
    GoRoute(path: '/books/:id', builder: (context, state) => BookDetailPage(id: state.pathParameters['id']!)),
    GoRoute(path: '/my-borrows', builder: (context, _) => const MyBorrowsPage()),
    GoRoute(path: '/admin', builder: (context, _) => const AdminHomePage()),
    GoRoute(path: '/admin/books', builder: (context, _) => const BookManagePage()),
    GoRoute(path: '/admin/readers', builder: (context, _) => const ReaderManagePage()),
    GoRoute(path: '/admin/borrows', builder: (context, _) => const BorrowManagePage()),
  ],
);
