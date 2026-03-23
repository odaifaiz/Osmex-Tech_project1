import 'dart:math' as math;
import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;          // outer radius
    final ir = r * 0.60;               // inner radius (hole)
    final barH = r * 0.38;             // horizontal bar height
    final barRight = r;                // bar extends to right edge
    final barLeft = cx;                // bar starts at center

    final paint = Paint()..style = PaintingStyle.fill;

    // ── Helper: draw arc sector (from angle1 to angle2, clockwise)
    //    outerR → innerR wedge
    Path sector(double startDeg, double sweepDeg, {double? outerR, double? innerR}) {
      final s = (startDeg) * math.pi / 180;
      final sw = sweepDeg * math.pi / 180;
      final oR = outerR ?? r;
      final iR = innerR ?? ir;
      final path = Path();
      // outer arc start
      path.moveTo(cx + oR * math.cos(s), cy + oR * math.sin(s));
      path.arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: oR),
        s, sw, false,
      );
      // inner arc back
      path.arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: iR),
        s + sw, -sw, false,
      );
      path.close();
      return path;
    }

    // ── Google G angles (degrees, 0° = right, clockwise)
    // Red:    -120° → 60°  (top-right, over top, to bottom-left area)  sweep=180
    // Yellow: 60°  → 120°  (bottom)                                    sweep=60
    // Green:  120° → 240°  (bottom-left to left)                       sweep=120 — but trimmed, see below
    // Blue:   right side with horizontal bar

    // Accurate breakdown:
    //  Red    −122° to   60°   sweep ≈ 182°
    //  Yellow   60° to  120°   sweep ≈  60°
    //  Green   120° to  240°   sweep ≈ 120°
    //  Blue    240° to  238°+  (right arc + horizontal bar)

    // Red sector
    paint.color = const Color(0xFFEA4335);
    canvas.drawPath(sector(-122, 182), paint);

    // Yellow sector
    paint.color = const Color(0xFFFBBC05);
    canvas.drawPath(sector(60, 60), paint);

    // Green sector
    paint.color = const Color(0xFF34A853);
    canvas.drawPath(sector(120, 120), paint);

    // Blue: right arc + horizontal bar (the distinguishing G feature)
    paint.color = const Color(0xFF4285F4);
    // Right-side arc from 240° back to -122° (going through 0°/right)
    // sweep = 360 - 240 - (360-238) = about 358°→ just the right portion
    // Blue occupies 240° → 238° going clockwise = sweep ≈ -2°? 
    // Correct: Blue is from -122° (top-right gap) continuing right, 
    // and the bar. Let's draw it as a custom path:
    final bluePath = Path();
    final startAngle = 238 * math.pi / 180;
    final endAngle   = 238 * math.pi / 180;  // tiny arc + bar shape

    // Outer arc: from -122° to ~10° (top-right)
    final blueStartRad = -122 * math.pi / 180;
    final blueEndRad   =  10  * math.pi / 180; // stop before 3-o-clock

    // Blue right arc outer
    bluePath.moveTo(cx + r * math.cos(blueStartRad), cy + r * math.sin(blueStartRad));
    // arc clockwise from -122° sweep = 132°  (to +10°)
    bluePath.arcTo(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      blueStartRad, 132 * math.pi / 180, false,
    );
    // Go inward to form the horizontal bar top
    bluePath.lineTo(barLeft, cy - barH / 2);
    // Bar left edge down
    bluePath.lineTo(barLeft, cy + barH / 2);
    // Back out to inner radius at ~10°
    bluePath.arcTo(
      Rect.fromCircle(center: Offset(cx, cy), radius: ir),
      blueEndRad, -132 * math.pi / 180, false,
    );
    bluePath.close();
    canvas.drawPath(bluePath, paint);

    // ── White circle in center (hole)
    paint.color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), ir * 0.98, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}