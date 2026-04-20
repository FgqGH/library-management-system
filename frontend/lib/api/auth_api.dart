import 'dio_client.dart';
import 'api_result.dart';

class AuthApi {
  final DioClient _client = DioClient();

  Future<ApiResult<Map<String, dynamic>>> readerLogin(String username, String password) async {
    final resp = await _client.post('/auth/reader/login', data: {
      'username': username, 'password': password,
    });
    return ApiResult.fromJson(resp.data, (d) => d as Map<String, dynamic>);
  }

  Future<ApiResult<Map<String, dynamic>>> adminLogin(String username, String password) async {
    final resp = await _client.post('/auth/admin/login', data: {
      'username': username, 'password': password,
    });
    return ApiResult.fromJson(resp.data, (d) => d as Map<String, dynamic>);
  }

  Future<ApiResult<void>> logout() async {
    final resp = await _client.post('/auth/logout');
    return ApiResult.fromJson(resp.data, null);
  }
}
