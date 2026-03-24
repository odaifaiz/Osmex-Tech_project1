import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class AppLogoHeader extends StatelessWidget {
  const AppLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double size = AppDimensions.logoSize;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Glow halo behind the box
        Container(
          width: size + 24,
          height: size + 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.logoRadius + 8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5C8).withOpacity(0.22),
                blurRadius: 32,
                spreadRadius: 6,
              ),
              BoxShadow(
                color: const Color(0xFF00E5C8).withOpacity(0.10),
                blurRadius: 60,
                spreadRadius: 12,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFF0D2233),
                borderRadius: BorderRadius.circular(AppDimensions.logoRadius),
                border: Border.all(
                  color: const Color(0xFF00E5C8).withOpacity(0.85),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5C8).withOpacity(0.35),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _LogoIconPainter(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // ── Tagline
        Text(
          'نصلح مدينتك معاً',
          style: AppTypography.appTagline.copyWith(
            color: const Color(0xFF00E5C8).withOpacity(0.85),
            letterSpacing: 0.5,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}

class _LogoIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final teal = const Color(0xFF00E5C8);

    // ── Paint helpers
    Paint stroke(double opacity, double width) => Paint()
      ..color = teal.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    Paint fill(double opacity) => Paint()
      ..color = teal.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final r = size.width * 0.36; // outer ring radius

    // ── Outer ring
    canvas.drawCircle(Offset(cx, cy), r, stroke(0.55, 1.2));

    // ── Inner ring
    canvas.drawCircle(Offset(cx, cy), r * 0.68, stroke(0.35, 1.0));

    // ── Location pin
    final pinR = r * 0.68;
    final pinPath = Path();
    pinPath.moveTo(cx, cy + pinR);
    // Smooth teardrop
    pinPath.cubicTo(
      cx - pinR * 0.6, cy + pinR * 0.2,
      cx - pinR,       cy - pinR * 0.2,
      cx,              cy - pinR,
    );
    pinPath.cubicTo(
      cx + pinR,       cy - pinR * 0.2,
      cx + pinR * 0.6, cy + pinR * 0.2,
      cx,              cy + pinR,
    );
    // Filled with low opacity
    canvas.drawPath(pinPath, fill(0.12));
    // Stroke
    canvas.drawPath(pinPath, stroke(0.9, 1.5));

    // ── Center dot (filled + glow)
    final glowPaint = Paint()
      ..color = teal.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(cx, cy), r * 0.18, glowPaint);
    canvas.drawCircle(Offset(cx, cy), r * 0.15, fill(0.9));
    canvas.drawCircle(Offset(cx, cy), r * 0.09, fill(1.0));

    // ── Compass tick marks (top, left, right)
    final tickOuter = r + r * 0.12;
    final tickInner = r - r * 0.12;
    final angles = [-math.pi / 2, math.pi, 0.0]; // top, left, right

    for (final angle in angles) {
      final outerX = cx + tickOuter * math.cos(angle);
      final outerY = cy + tickOuter * math.sin(angle);
      final innerX = cx + tickInner * math.cos(angle);
      final innerY = cy + tickInner * math.sin(angle);
      canvas.drawLine(
        Offset(innerX, innerY),
        Offset(outerX, outerY),
        stroke(0.5, 1.0),
      );
      // Dot at tip
      canvas.drawCircle(Offset(outerX, outerY), 1.8, fill(0.7));
    }

    // ── Small decorative arcs (quarter circles at corners)
    final arcPaint = stroke(0.2, 0.8);
    final arcR = r * 1.25;
    for (int i = 0; i < 4; i++) {
      final startAngle = (i * math.pi / 2) - math.pi / 8;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: arcR),
        startAngle,
        math.pi / 4,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}