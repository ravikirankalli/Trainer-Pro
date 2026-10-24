/// The authenticated trainer, as returned by the `/login` endpoint.
class Trainer {
  const Trainer({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.trainerId,
    this.schoolId,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String? trainerId;
  final String? schoolId;

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      trainerId: json['user_id']?.toString(),
      schoolId: json['school_id']?.toString(),
    );
  }

  Map<String, String> toStorageMap() => {
        AuthStorageKeys.trainerId: id,
        AuthStorageKeys.trainerName: name,
        AuthStorageKeys.trainerEmail: email,
        AuthStorageKeys.trainerRole: role,
        AuthStorageKeys.trainerCode: trainerId ?? '',
        AuthStorageKeys.schoolId: schoolId ?? '',
      };
}

/// Keys used for the locally persisted session.
class AuthStorageKeys {
  AuthStorageKeys._();

  static const String accessToken = 'trainer_access_token';
  static const String refreshToken = 'trainer_refresh_token';
  static const String trainerId = 'trainer_id';
  static const String trainerName = 'trainer_name';
  static const String trainerEmail = 'trainer_email';
  static const String trainerRole = 'trainer_role';
  static const String trainerCode = 'trainer_code';
  static const String schoolId = 'trainer_school_id';

  static const List<String> all = [
    accessToken,
    refreshToken,
    trainerId,
    trainerName,
    trainerEmail,
    trainerRole,
    trainerCode,
    schoolId,
  ];
}
