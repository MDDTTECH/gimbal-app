import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/glass_morphism.dart';

class AngleDisplay extends StatelessWidget {
  final String label;
  final double angle;
  final double minAngle;
  final double maxAngle;
  final Color color;
  final ValueChanged<double>? onChanged;

  const AngleDisplay({
    super.key,
    required this.label,
    required this.angle,
    this.minAngle = -180,
    this.maxAngle = 180,
    this.color = AppColors.accentCyan,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = (angle - minAngle) / (maxAngle - minAngle);

    return GlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '${angle.toStringAsFixed(1)}°',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  // Background
                  Container(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                  // Fill
                  FractionallySizedBox(
                    widthFactor: normalized.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.5),
                            color,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Center marker
                  Positioned(
                    left: (0.5 - minAngle / (maxAngle - minAngle)) *
                            MediaQuery.of(context).size.width *
                            0.25 -
                        0.5,
                    child: Container(
                      width: 1,
                      height: 4,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (onChanged != null) ...[
            const SizedBox(height: 4),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: color,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
                thumbColor: color,
                overlayColor: color.withValues(alpha: 0.1),
              ),
              child: Slider(
                value: angle,
                min: minAngle,
                max: maxAngle,
                onChanged: onChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CircularAngleGauge extends StatelessWidget {
  final String label;
  final double angle;
  final double maxAngle;
  final Color color;
  final double size;

  const CircularAngleGauge({
    super.key,
    required this.label,
    required this.angle,
    this.maxAngle = 180,
    this.color = AppColors.accentCyan,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _GaugePainter(
              angle: angle,
              maxAngle: maxAngle,
              color: color,
            ),
            child: Center(
              child: Text(
                '${angle.toStringAsFixed(1)}°',
                style: TextStyle(
                  color: color,
                  fontSize: size * 0.17,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.7),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double angle;
  final double maxAngle;
  final Color color;

  _GaugePainter({
    required this.angle,
    required this.maxAngle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi * 0.75,
      pi * 1.5,
      false,
      bgPaint,
    );

    // Value arc
    final sweepAngle = (angle.abs() / maxAngle) * pi * 0.75;
    final startAngle = angle >= 0 ? -pi / 2 : -pi / 2 - sweepAngle;
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      valuePaint,
    );

    // Glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
