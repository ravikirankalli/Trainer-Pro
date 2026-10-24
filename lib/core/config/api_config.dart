import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// Single place to configure where the app talks to the backend.
class ApiConfig {
  ApiConfig._();

  /// Override at build time:
  /// `flutter run --dart-define=API_BASE_URL=https://api.example.com/api`
  static const String _configured = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2/school_pro/public/api',
  );

  /// 10.0.2.2 only resolves inside the Android emulator; every other platform
  /// has to reach the host machine over its own loopback address.
  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform != TargetPlatform.android) {
      return _configured.replaceFirst('10.0.2.2', 'localhost');
    }
    return _configured;
  }

  /// Role this app authenticates as. The backend rejects a user whose role
  /// does not match, which keeps trainers out of the other role-specific apps.
  static const String role = 'trainer';

  static const Duration timeout = Duration(seconds: 20);

  static const String loginPath = '/login';
  static const String refreshTokenPath = '/refresh-token';
  static const String logoutPath = '/logout';
  static const String forgotPasswordPath = '/forgot-password';
}
