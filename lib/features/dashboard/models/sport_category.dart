import 'package:flutter/material.dart';

/// One coaching category on the dashboard: the sport, how many students are
/// enrolled and when the session runs.
class SportCategory {
  const SportCategory({
    required this.name,
    required this.studentCount,
    required this.startTime,
    required this.endTime,
    required this.imageAsset,
    required this.accent,
    required this.fallbackIcon,
  });

  final String name;
  final int studentCount;

  /// Kept as display strings: the backend has no schedule endpoint yet, so
  /// there is nothing to parse into a [TimeOfDay] and format back.
  final String startTime;
  final String endTime;

  /// Photograph for the card. [accent] and [fallbackIcon] stand in until the
  /// artwork is dropped into `assets/images/`, so a missing file degrades to
  /// a tinted placeholder instead of a broken image.
  final String imageAsset;
  final Color accent;
  final IconData fallbackIcon;

  String get schedule => '$startTime - $endTime';

  String get studentLabel => '$studentCount Students';

  factory SportCategory.fromJson(Map<String, dynamic> json) {
    return SportCategory(
      name: json['name']?.toString() ?? '',
      studentCount: int.tryParse(json['student_count']?.toString() ?? '') ?? 0,
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      imageAsset: 'assets/images/${json['slug'] ?? 'sport'}.png',
      accent: const Color(0xFF2F7CC9),
      fallbackIcon: Icons.sports_rounded,
    );
  }
}
