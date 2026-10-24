import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Decorative red-and-pink wave that separates the form from the trust
/// branding at the bottom of the login screen.
class BrandWave extends StatelessWidget {
  const BrandWave({super.key, this.height = 72});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _BrandWavePainter()),
    );
  }
}

class _BrandWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Layer 1 - broad light pink band sweeping toward the centre-right.
    final pale = Path()
      ..moveTo(0, h * 0.34)
      ..cubicTo(w * 0.28, h * 0.02, w * 0.55, h * 0.96, w, h * 0.42)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(pale, Paint()..color = AppColors.palePink);

    // Layer 3 - pale blush band beneath the red wave.
    final blush = Path()
      ..moveTo(0, h * 0.58)
      ..cubicTo(w * 0.30, h * 0.24, w * 0.58, h * 1.08, w, h * 0.62)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(blush, Paint()..color = AppColors.blushPink);

    // Layer 2 - main deep red wave.
    final red = Path()
      ..moveTo(0, h * 0.70)
      ..cubicTo(w * 0.32, h * 0.34, w * 0.60, h * 1.16, w, h * 0.78)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(red, Paint()..color = AppColors.primaryRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
