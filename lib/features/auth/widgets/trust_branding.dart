import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Centred "From / — Andhra Educational Trust —" block shown at the bottom of
/// the login screen.
class TrustBranding extends StatelessWidget {
  const TrustBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'From',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _BrandRule(),
              const SizedBox(width: 10),
              // Scales down rather than overflowing on narrow screens.
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Andhra Educational Trust',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const _BrandRule(),
            ],
          ),
        ),
      ],
    );
  }
}

class _BrandRule extends StatelessWidget {
  const _BrandRule();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 2,
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
