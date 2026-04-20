import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth_api.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  String? _token;
  String? _role;
  String? _username;

  String? get token => _token;
  String? get role => _role;
  String? get username => _username;
  bool get isReader => _role == 'READER';
  bool get isAdmin => _role == 'ADMIN' || _role == 'SUPER_ADMIN';
  bool get isLoggedIn => _token != null;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _role = prefs.getString('role');
    _username = prefs.getString('username');
    notifyListeners();
  }

  Future<bool> readerLogin(String username, String password) async {
    final result = await _authApi.readerLogin(username, password);
    if (result.isSuccess && result.data != null) {
      _token = result.data!['token'];
      _role = 'READER';
      final reader = result.data!['reader'];
      _username = reader['real_name'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('role', _role!);
      await prefs.setString('username', _username!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> adminLogin(String username, String password) async {
    final result = await _authApi.adminLogin(username, password);
    if (result.isSuccess && result.data != null) {
      _token = result.data!['token'];
      final admin = result.data!['admin'];
      _role = admin['role'];
      _username = admin['real_name'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('role', _role!);
      await prefs.setString('username', _username!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    try { await _authApi.logout(); } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('username');
    _token = null; _role = null; _username = null;
    notifyListeners();
  }
}
