import '../../auth/models/trainer.dart';
import 'sport_category.dart';

/// Everything the dashboard renders in one pass.
class DashboardSummary {
  const DashboardSummary({
    required this.trainer,
    required this.department,
    required this.categories,
    required this.appVersion,
    required this.refreshedAt,
  });

  final Trainer trainer;
  final String department;
  final List<SportCategory> categories;
  final String appVersion;
  final DateTime refreshedAt;

  /// "10:05 AM" for the footer. Formatted by hand rather than pulling in
  /// `intl` for a single timestamp.
  String get refreshedAtLabel {
    final hour = refreshedAt.hour % 12 == 0 ? 12 : refreshedAt.hour % 12;
    final minute = refreshedAt.minute.toString().padLeft(2, '0');
    final period = refreshedAt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
