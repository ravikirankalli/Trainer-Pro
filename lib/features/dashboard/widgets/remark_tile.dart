import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'dashboard_card.dart';

/// One tile in the remarks grid: a tinted badge, a label and a chevron.
class RemarkTile extends StatelessWidget {
  const RemarkTile({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.badgeColor,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color badgeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      onTap: onTap,
      padding: const EdgeInsets.all(9),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 34,
              height: 34,
              decoration:
                  BoxDecoration(color: iconColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, size: 19, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          // Two tiles per row leaves little width at phone sizes, so a long
          // label scales down rather than breaking across lines mid-word.
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            size: 21,
            color: AppColors.iconGrey,
          ),
        ],
      ),
    );
  }
}
