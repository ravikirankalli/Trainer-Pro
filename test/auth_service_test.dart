import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainer_pro/features/auth/auth_service.dart';
import 'package:trainer_pro/features/auth/models/trainer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('login stores the session and returns the trainer on success',
      () async {
    late Map<String, dynamic> sentBody;

    final service = AuthService(
      client: MockClient((request) async {
        sentBody = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            'user': {
              'id': 7,
              'name': 'Trainer A',
              'email': 'trainer.a@example.com',
              'role': 'trainer',
              'user_id': 'TR-1001',
              'school_id': 3,
            },
            'access_token': 'access-token-value',
            'refresh_token': 'refresh-token-value',
          }),
          200,
        );
      }),
    );

    final result = await service.login(
      trainerId: 'TR-1001',
      password: 'secret-password',
    );

    expect(result.success, isTrue);
    expect(result.trainer?.name, 'Trainer A');
    expect(sentBody['identifier'], 'TR-1001');
    expect(sentBody['role'], 'trainer');

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString(AuthStorageKeys.accessToken),
      'access-token-value',
    );
    expect(prefs.getString(AuthStorageKeys.trainerCode), 'TR-1001');
  });

  test('login surfaces the server message on invalid credentials', () async {
    final service = AuthService(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'message': 'Invalid credentials'}),
          401,
        ),
      ),
    );

    final result = await service.login(trainerId: 'TR-1001', password: 'wrong');

    expect(result.success, isFalse);
    expect(result.message, 'Invalid credentials');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(AuthStorageKeys.accessToken), isNull);
  });

  test('login falls back to a friendly message when the server fails',
      () async {
    final service = AuthService(
      client: MockClient((_) async => http.Response('', 500)),
    );

    final result = await service.login(trainerId: 'TR-1001', password: 'x');

    expect(result.success, isFalse);
    expect(result.message, contains('server is unavailable'));
  });

  test('isLoggedIn reflects the stored refresh token', () async {
    expect(await AuthService.isLoggedIn(), isFalse);

    SharedPreferences.setMockInitialValues({
      AuthStorageKeys.refreshToken: 'refresh-token-value',
    });

    expect(await AuthService.isLoggedIn(), isTrue);
  });
}
