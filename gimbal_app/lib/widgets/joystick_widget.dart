import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class JoystickWidget extends StatefulWidget {
  final double size;
  final ValueChanged<Offset>? onChanged;
  final String label;

  const JoystickWidget({
    super.key,
    this.size = 180,
    this.onChanged,
    this.label = 'Pan / Tilt',
  });

  @override
  State<JoystickWidget> createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget>
    with SingleTickerProviderStateMixin {
  Offset _position = Offset.zero;
  late AnimationController _returnController;
  late Animation<Offset> _returnAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _returnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _returnAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _returnController,
      curve: Curves.elasticOut,
    ));
    _returnController.addListener(() {
      if (!_isDragging) {
        setState(() {
          _position = _returnAnimation.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _returnController.dispose();
    super.dispose();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final maxRadius = widget.size / 2 - 30;
    setState(() {
      _isDragging = true;
      Offset newPos = _position + details.delta;
      final distance = newPos.distance;
      if (distance > maxRadius) {
        newPos = Offset.fromDirection(newPos.direction, maxRadius);
      }
      _position = newPos;
      widget.onChanged?.call(Offset(
        _position.dx / maxRadius,
        _position.dy / maxRadius,
      ));
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    _isDragging = false;
    _returnAnimation = Tween<Offset>(
      begin: _position,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _returnController,
      curve: Curves.elasticOut,
    ));
    _returnController.forward(from: 0);
    widget.onChanged?.call(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.size / 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: GestureDetector(
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            child: CustomPaint(
              painter: _JoystickPainter(
                position: _position,
                radius: radius,
                isDragging: _isDragging,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _JoystickPainter extends CustomPainter {
  final Offset position;
  final double radius;
  final bool isDragging;

  _JoystickPainter({
    required this.position,
    required this.radius,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = radius - 30;

    // Outer ring
    final outerPaint = Paint()
      ..color = AppColors.glassBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, maxRadius + 20, outerPaint);

    // Guide lines
    final guidePaint = Paint()
      ..color = AppColors.glassWhite
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(center.dx - maxRadius - 10, center.dy),
      Offset(center.dx + maxRadius + 10, center.dy),
      guidePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - maxRadius - 10),
      Offset(center.dx, center.dy + maxRadius + 10),
      guidePaint,
    );

    // Inner circle rings
    for (int i = 1; i <= 3; i++) {
      final ringPaint = Paint()
        ..color = AppColors.glassWhite.withValues(alpha: 0.03 * i)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawCircle(center, maxRadius * i / 3, ringPaint);
    }

    // Joystick knob shadow
    final shadowPaint = Paint()
      ..color = AppColors.accentCyan.withValues(alpha: isDragging ? 0.3 : 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center + position, 24, shadowPaint);

    // Joystick knob
    final knobGradient = RadialGradient(
      colors: [
        isDragging
            ? AppColors.accentCyan.withValues(alpha: 0.9)
            : AppColors.accentCyan.withValues(alpha: 0.6),
        isDragging
            ? AppColors.accentBlue.withValues(alpha: 0.7)
            : AppColors.accentBlue.withValues(alpha: 0.4),
      ],
    );
    final knobPaint = Paint()
      ..shader = knobGradient.createShader(
        Rect.fromCircle(center: center + position, radius: 22),
      );
    canvas.drawCircle(center + position, 22, knobPaint);

    // Inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: isDragging ? 0.4 : 0.2);
    canvas.drawCircle(center + position + const Offset(-4, -4), 6, highlightPaint);

    // Direction indicators
    final dirPaint = Paint()
      ..color = AppColors.textMuted
      ..style = PaintingStyle.fill;

    // Up arrow
    _drawTriangle(canvas, Offset(center.dx, center.dy - maxRadius - 14), 5, 0, dirPaint);
    // Down arrow
    _drawTriangle(canvas, Offset(center.dx, center.dy + maxRadius + 14), 5, pi, dirPaint);
    // Left arrow
    _drawTriangle(canvas, Offset(center.dx - maxRadius - 14, center.dy), 5, pi / 2, dirPaint);
    // Right arrow
    _drawTriangle(canvas, Offset(center.dx + maxRadius + 14, center.dy), 5, -pi / 2, dirPaint);
  }

  void _drawTriangle(Canvas canvas, Offset center, double size, double rotation, Paint paint) {
    final path = Path();
    path.moveTo(
      center.dx + size * cos(-pi / 2 + rotation),
      center.dy + size * sin(-pi / 2 + rotation),
    );
    path.lineTo(
      center.dx + size * cos(pi / 6 + rotation),
      center.dy + size * sin(pi / 6 + rotation),
    );
    path.lineTo(
      center.dx + size * cos(5 * pi / 6 + rotation),
      center.dy + size * sin(5 * pi / 6 + rotation),
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _JoystickPainter oldDelegate) {
    return oldDelegate.position != position || oldDelegate.isDragging != isDragging;
  }
}
