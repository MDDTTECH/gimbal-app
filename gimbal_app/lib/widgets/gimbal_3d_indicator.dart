import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Gimbal3DIndicator extends StatelessWidget {
  final double pan;
  final double tilt;
  final double roll;
  final double size;

  const Gimbal3DIndicator({
    super.key,
    this.pan = 0,
    this.tilt = 0,
    this.roll = 0,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _Gimbal3DPainter(
          pan: pan,
          tilt: tilt,
          roll: roll,
        ),
      ),
    );
  }
}

class _Gimbal3DPainter extends CustomPainter {
  final double pan;
  final double tilt;
  final double roll;

  _Gimbal3DPainter({
    required this.pan,
    required this.tilt,
    required this.roll,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Outer ring
    final outerPaint = Paint()
      ..color = AppColors.glassBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius, outerPaint);

    // Degree marks
    final markPaint = Paint()
      ..color = AppColors.textMuted
      ..strokeWidth = 1;
    for (int i = 0; i < 36; i++) {
      final angle = i * pi / 18;
      final isMain = i % 9 == 0;
      final inner = radius - (isMain ? 10 : 5);
      canvas.drawLine(
        Offset(center.dx + inner * cos(angle), center.dy + inner * sin(angle)),
        Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle)),
        markPaint..strokeWidth = isMain ? 1.5 : 0.5,
      );
    }

    // Pan indicator (horizontal line that rotates)
    final panAngle = pan * pi / 180;
    final panPaint = Paint()
      ..color = AppColors.accentCyan
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(
        center.dx - (radius - 15) * cos(panAngle),
        center.dy - (radius - 15) * sin(panAngle),
      ),
      Offset(
        center.dx + (radius - 15) * cos(panAngle),
        center.dy + (radius - 15) * sin(panAngle),
      ),
      panPaint,
    );

    // Tilt indicator (vertical offset of center dot)
    final tiltOffset = (tilt / 90) * (radius - 20);

    // Camera body (rectangle that tilts)
    final cameraRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + tiltOffset),
        width: 24,
        height: 16,
      ),
      const Radius.circular(3),
    );
    final cameraPaint = Paint()
      ..color = AppColors.accentPurple.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(center.dx, center.dy + tiltOffset);
    canvas.rotate(roll * pi / 180);
    canvas.translate(-center.dx, -(center.dy + tiltOffset));
    canvas.drawRRect(cameraRect, cameraPaint);

    // Lens
    final lensPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + 4, center.dy + tiltOffset),
      4,
      lensPaint,
    );
    canvas.restore();

    // Center dot
    final centerDot = Paint()
      ..color = AppColors.accentCyan
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3, centerDot);

    // Glow
    final glowPaint = Paint()
      ..color = AppColors.accentCyan.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, 3, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _Gimbal3DPainter oldDelegate) {
    return oldDelegate.pan != pan ||
        oldDelegate.tilt != tilt ||
        oldDelegate.roll != roll;
  }
}
