import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Section title with a rule running out to the right edge, as used above
/// the remarks grid.
class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(child: Divider(color: AppColors.divider, height: 1.5)),
      ],
    );
  }
}
