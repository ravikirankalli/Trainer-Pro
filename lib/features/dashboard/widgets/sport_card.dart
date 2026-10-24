import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/sport_category.dart';
import 'dashboard_card.dart';

/// Row for one coaching category: photograph, name, enrolment and schedule.
class SportCard extends StatelessWidget {
  const SportCard({super.key, required this.category, this.onTap});

  final SportCategory category;
  final VoidCallback? onTap;

  static const double _thumbWidth = 96;
  static const double _thumbHeight = 76;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: _thumbWidth,
              height: _thumbHeight,
              child: Image.asset(
                category.imageAsset,
                fit: BoxFit.cover,
                // Decoded at roughly the size it is drawn rather than full
                // resolution, which matters on low-end devices.
                cacheWidth: (_thumbWidth * 3).round(),
                errorBuilder: (_, _, _) => _ThumbPlaceholder(category: category),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 7),
                _DetailRow(
                  icon: Icons.groups_rounded,
                  text: category.studentLabel,
                ),
                const SizedBox(height: 5),
                _DetailRow(
                  icon: Icons.access_time_rounded,
                  text: category.schedule,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 26,
            color: AppColors.iconGrey,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19, color: AppColors.accentBlue),
        const SizedBox(width: 9),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, color: AppColors.charcoal),
          ),
        ),
      ],
    );
  }
}

/// Shown while the category artwork is missing from `assets/images/`.
class _ThumbPlaceholder extends StatelessWidget {
  const _ThumbPlaceholder({required this.category});

  final SportCategory category;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category.accent,
            Color.alphaBlend(Colors.black12, category.accent),
          ],
        ),
      ),
      child: Center(
        child: Icon(category.fallbackIcon, size: 32, color: Colors.white),
      ),
    );
  }
}
