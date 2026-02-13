import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../theme/glass_morphism.dart';
import '../widgets/status_bar.dart';
import '../models/mock_data.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  int _pointsCaptured = 0;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  Timer? _pointTimer;
  late AnimationController _pulseController;

  final _mockAngles = <_RecordedPoint>[];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pointTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _pointsCaptured = 0;
        _elapsed = Duration.zero;
        _mockAngles.clear();
        _pulseController.repeat();
        _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
          setState(() {
            _elapsed += const Duration(milliseconds: 100);
          });
        });
        _pointTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() {
            _pointsCaptured++;
            _mockAngles.add(_RecordedPoint(
              time: _elapsed,
              pan: 20 * sin(_pointsCaptured * 0.05),
              tilt: 10 * cos(_pointsCaptured * 0.03),
            ));
            if (_mockAngles.length > 100) {
              _mockAngles.removeAt(0);
            }
          });
        });
      } else {
        _pulseController.stop();
        _timer?.cancel();
        _pointTimer?.cancel();
      }
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final tenths = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
    return '$minutes:$seconds.$tenths';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          children: [
            GimbalStatusBar(state: MockData.connectedGimbal)
                .animate()
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 20),

            // Title
            Text(
              'MOTION RECORDING',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
                color: AppColors.textMuted,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 24),

            // Timer display
            GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              borderRadius: 20,
              child: Column(
                children: [
                  Text(
                    _formatDuration(_elapsed),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                      color: _isRecording
                          ? AppColors.error
                          : AppColors.textPrimary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _InfoChip(
                        icon: Icons.circle,
                        label: '$_pointsCaptured pts',
                        color: AppColors.accentCyan,
                      ),
                      const SizedBox(width: 16),
                      _InfoChip(
                        icon: Icons.speed,
                        label: '10 Hz',
                        color: AppColors.accentPurple,
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 24),

            // Waveform visualization
            Expanded(
              child: GlassContainer(
                padding: const EdgeInsets.all(12),
                borderRadius: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentCyan,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentCyan.withValues(alpha: 0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Pan',
                          style: TextStyle(
                            color: AppColors.accentCyan,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentPurple,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentPurple.withValues(alpha: 0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Tilt',
                          style: TextStyle(
                            color: AppColors.accentPurple,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: _WaveformPainter(
                          points: _mockAngles,
                          isRecording: _isRecording,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            ),
            const SizedBox(height: 24),

            // Record button
            GestureDetector(
              onTap: _toggleRecording,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final pulse = _isRecording
                      ? 1.0 +
                          sin(_pulseController.value * 2 * pi) * 0.08
                      : 1.0;
                  return Transform.scale(
                    scale: pulse,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isRecording
                              ? AppColors.error
                              : AppColors.textSecondary,
                          width: 3,
                        ),
                        boxShadow: _isRecording
                            ? [
                                BoxShadow(
                                  color: AppColors.error.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: _isRecording ? 28 : 56,
                          height: _isRecording ? 28 : 56,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(
                              _isRecording ? 6 : 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 400.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 8),
            Text(
              _isRecording ? 'Tap to stop' : 'Tap to record',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 10),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RecordedPoint {
  final Duration time;
  final double pan;
  final double tilt;

  _RecordedPoint({required this.time, required this.pan, required this.tilt});
}

class _WaveformPainter extends CustomPainter {
  final List<_RecordedPoint> points;
  final bool isRecording;

  _WaveformPainter({required this.points, required this.isRecording});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      // Draw empty state grid
      final gridPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.03)
        ..strokeWidth = 0.5;
      for (int i = 0; i < 5; i++) {
        final y = size.height * i / 4;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }

      // Center line
      final centerPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        centerPaint,
      );
      return;
    }

    // Grid
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;
    for (int i = 0; i < 5; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw pan line
    _drawWaveform(canvas, size, points.map((p) => p.pan).toList(),
        AppColors.accentCyan, 30);

    // Draw tilt line
    _drawWaveform(canvas, size, points.map((p) => p.tilt).toList(),
        AppColors.accentPurple, 30);
  }

  void _drawWaveform(
      Canvas canvas, Size size, List<double> values, Color color, double maxVal) {
    if (values.isEmpty) return;

    final path = Path();
    final glowPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1).clamp(1, double.infinity);
      final y = size.height / 2 - (values[i] / maxVal) * (size.height / 2 - 10);

      if (i == 0) {
        path.moveTo(x, y);
        glowPath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        glowPath.lineTo(x, y);
      }
    }

    // Glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(glowPath, glowPaint);

    // Line
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return true;
  }
}
