import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../../features/auth/models/trainer.dart';

/// HTTP client that attaches the stored access token to every request and
/// transparently refreshes it once when the backend reports it has expired.
class ApiClient extends http.BaseClient {
  ApiClient({http.Client? inner, this.onSessionExpired})
      : _inner = inner ?? http.Client();

  final http.Client _inner;

  /// Called when the refresh token is rejected and the user has to sign in
  /// again. Set by the app so it can return to the login screen.
  final void Function()? onSessionExpired;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final prefs = await SharedPreferences.getInstance();

    request.headers['Accept'] = 'application/json';
    request.headers.putIfAbsent('Content-Type', () => 'application/json');

    final accessToken = prefs.getString(AuthStorageKeys.accessToken);
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    var response = await _inner.send(_copyRequest(request));
    if (response.statusCode != 401) return response;

    if (await _refreshAccessToken(prefs)) {
      final retry = _copyRequest(request);
      final newToken = prefs.getString(AuthStorageKeys.accessToken);
      if (newToken != null) {
        retry.headers['Authorization'] = 'Bearer $newToken';
      }
      return _inner.send(retry);
    }

    await clearSession();
    onSessionExpired?.call();
    return response;
  }

  Future<bool> _refreshAccessToken(SharedPreferences prefs) async {
    final refreshToken = prefs.getString(AuthStorageKeys.refreshToken);
    if (refreshToken == null) return false;

    try {
      final response = await _inner
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.refreshTokenPath}'),
            headers: {
              'Authorization': 'Bearer $refreshToken',
              'Accept': 'application/json',
            },
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 200) return false;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final newAccess = data['access_token'] as String?;
      if (newAccess == null) return false;

      await prefs.setString(AuthStorageKeys.accessToken, newAccess);
      final rotated = data['refresh_token'] as String?;
      if (rotated != null) {
        await prefs.setString(AuthStorageKeys.refreshToken, rotated);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in AuthStorageKeys.all) {
      await prefs.remove(key);
    }
  }

  http.BaseRequest _copyRequest(http.BaseRequest original) {
    if (original is http.Request) {
      return http.Request(original.method, original.url)
        ..headers.addAll(original.headers)
        ..bodyBytes = original.bodyBytes
        ..encoding = original.encoding
        ..followRedirects = original.followRedirects
        ..maxRedirects = original.maxRedirects
        ..persistentConnection = original.persistentConnection;
    }
    if (original is http.MultipartRequest) {
      final copy = http.MultipartRequest(original.method, original.url)
        ..headers.addAll(original.headers)
        ..fields.addAll(original.fields);
      copy.files.addAll(original.files);
      return copy;
    }
    return original;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

/// Shared instance used by the feature services.
final ApiClient apiClient = ApiClient();
