import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import 'dashboard_service.dart';
import 'models/dashboard_summary.dart';
import 'widgets/dashboard_drawer.dart';
import 'widgets/remark_tile.dart';
import 'widgets/section_heading.dart';
import 'widgets/sport_card.dart';
import 'widgets/trainer_header_card.dart';

/// Landing screen after login: trainer profile, the categories they coach and
/// the remarks shortcuts.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.service = const DashboardService()});

  final DashboardService service;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  late Future<DashboardSummary> _summary = widget.service.load();

  Future<void> _refresh() async {
    final reloaded = widget.service.load();
    setState(() => _summary = reloaded);
    await reloaded;
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // main.dart asks for dark status bar icons, which disappear against
        // the red bar.
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          'Trainer Pro',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded, size: 26),
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: FutureBuilder<DashboardSummary>(
        future: _summary,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            );
          }
          if (!snapshot.hasData) {
            return _ErrorState(onRetry: _refresh);
          }
          return _DashboardBody(
            summary: snapshot.data!,
            onRefresh: _refresh,
            onLogout: _logout,
          );
        },
      ),
      drawer: FutureBuilder<DashboardSummary>(
        future: _summary,
        builder: (context, snapshot) {
          final summary = snapshot.data;
          if (summary == null) return const Drawer();
          return DashboardDrawer(
            trainer: summary.trainer,
            department: summary.department,
            onLogout: _logout,
          );
        },
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.summary,
    required this.onRefresh,
    required this.onLogout,
  });

  final DashboardSummary summary;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primaryRed,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          TrainerHeaderCard(
            trainer: summary.trainer,
            department: summary.department,
            onNewEvents: () {},
            onGallery: () {},
          ),
          const SizedBox(height: 14),
          for (final category in summary.categories) ...[
            SportCard(category: category, onTap: () {}),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 10),
          const SectionHeading('Remarks'),
          const SizedBox(height: 14),
          const _RemarksGrid(),
          const SizedBox(height: 22),
          Text(
            'App Version ${summary.appVersion}  |  '
            'Data refreshed at ${summary.refreshedAtLabel}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }
}

class _RemarksGrid extends StatelessWidget {
  const _RemarksGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RemarkTile(
                label: 'Highlights',
                icon: Icons.star_rounded,
                iconColor: AppColors.amber,
                badgeColor: AppColors.amberSoft,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: RemarkTile(
                label: 'Performances',
                icon: Icons.emoji_events_rounded,
                iconColor: AppColors.purple,
                badgeColor: AppColors.purpleSoft,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: RemarkTile(
                label: 'Suggestions',
                icon: Icons.lightbulb_rounded,
                iconColor: AppColors.green,
                badgeColor: AppColors.greenSoft,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: RemarkTile(
                label: 'Remarks',
                icon: Icons.description_rounded,
                iconColor: AppColors.primaryRed,
                badgeColor: AppColors.redSoft,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 34,
            color: AppColors.secondaryRed,
          ),
          const SizedBox(height: 10),
          const Text(
            'Could not load your dashboard.',
            style: TextStyle(fontSize: 15, color: AppColors.charcoal),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
