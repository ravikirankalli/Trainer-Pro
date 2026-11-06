import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/models/trainer.dart';

/// Navigation drawer behind the app bar's menu button.
class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({
    super.key,
    required this.trainer,
    required this.department,
    required this.onLogout,
  });

  final Trainer trainer;
  final String department;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(trainer: trainer, department: department),
            const SizedBox(height: 8),
            // The destinations below are placeholders until their screens
            // exist; only Logout is wired up.
            _Item(icon: Icons.dashboard_rounded, label: 'Dashboard'),
            _Item(icon: Icons.calendar_month_rounded, label: 'New Events'),
            _Item(icon: Icons.image_rounded, label: 'Gallery'),
            _Item(icon: Icons.person_outline_rounded, label: 'Profile'),
            const Spacer(),
            const Divider(color: AppColors.divider, height: 1),
            _Item(
              icon: Icons.logout_rounded,
              label: 'Logout',
              color: AppColors.primaryRed,
              onTap: () {
                Navigator.of(context).pop();
                onLogout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.trainer, required this.department});

  final Trainer trainer;
  final String department;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryRed,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white24,
            ),
            alignment: Alignment.center,
            child: Text(
              trainer.initials,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            trainer.name.isEmpty ? 'Trainer' : trainer.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            department,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13.5, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    this.color = AppColors.navy,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22, color: color),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}
