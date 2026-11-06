import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/models/trainer.dart';
import 'models/dashboard_summary.dart';
import 'models/sport_category.dart';

/// Supplies the dashboard with its content.
///
/// The trainer comes from the session stored at login and is real. The
/// categories are the design's placeholder content: the backend has no
/// `/dashboard` endpoint yet, so [_placeholderCategories] stands in. When the
/// endpoint lands, fetch it here with `apiClient` and map the response through
/// [SportCategory.fromJson] — nothing above this class has to change.
class DashboardService {
  const DashboardService();

  Future<DashboardSummary> load() async {
    final prefs = await SharedPreferences.getInstance();

    return DashboardSummary(
      trainer: Trainer.fromStorage(prefs),
      department: 'Sports & Games',
      categories: _placeholderCategories,
      appVersion: '2.1',
      refreshedAt: DateTime.now(),
    );
  }
}

const List<SportCategory> _placeholderCategories = [
  SportCategory(
    name: 'Cricket',
    studentCount: 45,
    startTime: '04:00 PM',
    endTime: '06:00 PM',
    imageAsset: 'assets/images/cricket.png',
    accent: Color(0xFF2E7D32),
    fallbackIcon: Icons.sports_cricket_rounded,
  ),
  SportCategory(
    name: 'Athletics',
    studentCount: 38,
    startTime: '09:30 PM',
    endTime: '05:30 PM',
    imageAsset: 'assets/images/athletics.png',
    accent: Color(0xFFC0533F),
    fallbackIcon: Icons.directions_run_rounded,
  ),
  SportCategory(
    name: 'Swimming',
    studentCount: 32,
    startTime: '04:30 PM',
    endTime: '06:30 PM',
    imageAsset: 'assets/images/swimming.png',
    accent: Color(0xFF1B86C4),
    fallbackIcon: Icons.pool_rounded,
  ),
  SportCategory(
    name: 'Gymnastics',
    studentCount: 28,
    startTime: '04:00 PM',
    endTime: '05:30 PM',
    imageAsset: 'assets/images/gymnastics.png',
    accent: Color(0xFF4B5EA8),
    fallbackIcon: Icons.sports_gymnastics_rounded,
  ),
  SportCategory(
    name: 'Badminton',
    studentCount: 34,
    startTime: '03:30 PM',
    endTime: '05:30 PM',
    imageAsset: 'assets/images/badminton.png',
    accent: Color(0xFF2F8F6B),
    fallbackIcon: Icons.sports_tennis_rounded,
  ),
];
