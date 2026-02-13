import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../theme/glass_morphism.dart';
import '../widgets/status_bar.dart';
import '../models/mock_data.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen>
    with SingleTickerProviderStateMixin {
  bool _isArmed = false;
  bool _motionDetected = false;
  double _sensitivity = 0.65;
  Rect? _roiRect;
  Offset? _roiStart;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _toggleArm() {
    setState(() {
      _isArmed = !_isArmed;
      if (_isArmed) {
        _scanController.repeat();
        // Simulate motion detection after a delay
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isArmed) {
            setState(() => _motionDetected = true);
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) setState(() => _motionDetected = false);
            });
          }
        });
      } else {
        _scanController.stop();
        _motionDetected = false;
      }
    });
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
            const Text(
              'MOTION DETECTION',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
                color: AppColors.textMuted,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 16),

            // Camera preview (simulated)
            Expanded(
              flex: 3,
              child: GlassContainer(
                padding: EdgeInsets.zero,
                borderRadius: 16,
                opacity: 0.05,
                border: Border.all(
                  color: _motionDetected
                      ? AppColors.error
                      : _isArmed
                          ? AppColors.success.withValues(alpha: 0.5)
                          : AppColors.glassBorder,
                  width: _motionDetected ? 2 : 1,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Simulated camera feed
                      _SimulatedCameraFeed(isArmed: _isArmed),

                      // ROI selection
                      if (_roiRect != null)
                        Positioned(
                          left: _roiRect!.left,
                          top: _roiRect!.top,
                          width: _roiRect!.width,
                          height: _roiRect!.height,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _motionDetected
                                    ? AppColors.error
                                    : AppColors.accentCyan,
                                width: 2,
                              ),
                              color: (_motionDetected
                                      ? AppColors.error
                                      : AppColors.accentCyan)
                                  .withValues(alpha: 0.1),
                            ),
                            child: _motionDetected
                                ? Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.error.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'MOTION DETECTED',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),

                      // Scan line
                      if (_isArmed)
                        AnimatedBuilder(
                          animation: _scanController,
                          builder: (context, child) {
                            return Positioned(
                              top: _scanController.value *
                                  MediaQuery.of(context).size.height *
                                  0.4,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppColors.accentCyan.withValues(alpha: 0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentCyan
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      // Draw ROI gesture detector
                      GestureDetector(
                        onPanStart: (d) {
                          setState(() {
                            _roiStart = d.localPosition;
                          });
                        },
                        onPanUpdate: (d) {
                          if (_roiStart != null) {
                            setState(() {
                              _roiRect = Rect.fromPoints(
                                _roiStart!,
                                d.localPosition,
                              );
                            });
                          }
                        },
                        onPanEnd: (_) {},
                      ),

                      // Status overlay
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GlassContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          borderRadius: 8,
                          opacity: 0.15,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isArmed
                                      ? AppColors.success
                                      : AppColors.textMuted,
                                  boxShadow: _isArmed
                                      ? [
                                          BoxShadow(
                                            color: AppColors.success
                                                .withValues(alpha: 0.5),
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isArmed ? 'ARMED' : 'STANDBY',
                                style: TextStyle(
                                  color: _isArmed
                                      ? AppColors.success
                                      : AppColors.textMuted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Instructions
                      if (_roiRect == null && !_isArmed)
                        Center(
                          child: GlassContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            borderRadius: 10,
                            opacity: 0.15,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  color: AppColors.textMuted,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Draw region to detect motion',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            ),
            const SizedBox(height: 16),

            // Controls
            GlassContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: 16,
              child: Column(
                children: [
                  // Sensitivity slider
                  Row(
                    children: [
                      const Text(
                        'Sensitivity',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(_sensitivity * 100).round()}%',
                        style: const TextStyle(
                          color: AppColors.accentCyan,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 7),
                      activeTrackColor: AppColors.accentCyan,
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
                      thumbColor: AppColors.accentCyan,
                      overlayColor: AppColors.accentCyan.withValues(alpha: 0.1),
                    ),
                    child: Slider(
                      value: _sensitivity,
                      onChanged: (v) => setState(() => _sensitivity = v),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Trigger sequence selector
                  Row(
                    children: [
                      const Text(
                        'Trigger Sequence',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      GlassContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        borderRadius: 8,
                        opacity: 0.1,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Product Turntable 360',
                              style: TextStyle(
                                color: AppColors.accentCyan,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.accentCyan,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Arm button
                  GlassButton(
                    label: _isArmed ? 'DISARM' : 'ARM DETECTION',
                    icon: _isArmed ? Icons.stop : Icons.radar,
                    gradient: _isArmed
                        ? AppColors.purpleGradient
                        : AppColors.primaryGradient,
                    onTap: _toggleArm,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SimulatedCameraFeed extends StatefulWidget {
  final bool isArmed;

  const _SimulatedCameraFeed({required this.isArmed});

  @override
  State<_SimulatedCameraFeed> createState() => _SimulatedCameraFeedState();
}

class _SimulatedCameraFeedState extends State<_SimulatedCameraFeed>
    with SingleTickerProviderStateMixin {
  late AnimationController _noiseController;

  @override
  void initState() {
    super.initState();
    _noiseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();
  }

  @override
  void dispose() {
    _noiseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _noiseController,
      builder: (context, child) {
        return CustomPaint(
          painter: _CameraFeedPainter(
            seed: (_noiseController.value * 100).toInt(),
            isArmed: widget.isArmed,
          ),
        );
      },
    );
  }
}

class _CameraFeedPainter extends CustomPainter {
  final int seed;
  final bool isArmed;

  _CameraFeedPainter({required this.seed, required this.isArmed});

  @override
  void paint(Canvas canvas, Size size) {
    // Dark background simulating camera feed
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0D1117),
    );

    // Grid overlay
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 0.5;
    for (int i = 0; i < 10; i++) {
      final x = size.width * i / 9;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (int i = 0; i < 7; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Simulated objects
    final rng = Random(42);
    for (int i = 0; i < 5; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final w = 20 + rng.nextDouble() * 40;
      final h = 20 + rng.nextDouble() * 30;
      canvas.drawRect(
        Rect.fromLTWH(x, y, w, h),
        Paint()..color = Colors.white.withValues(alpha: 0.03 + rng.nextDouble() * 0.02),
      );
    }

    // Corner brackets
    final bracketPaint = Paint()
      ..color = isArmed
          ? AppColors.success.withValues(alpha: 0.3)
          : Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const bracketSize = 20.0;
    const margin = 12.0;

    // Top-left
    canvas.drawLine(
      const Offset(margin, margin),
      const Offset(margin + bracketSize, margin),
      bracketPaint,
    );
    canvas.drawLine(
      const Offset(margin, margin),
      const Offset(margin, margin + bracketSize),
      bracketPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin - bracketSize, margin),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin, margin + bracketSize),
      bracketPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin + bracketSize, size.height - margin),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin, size.height - margin - bracketSize),
      bracketPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin - bracketSize, size.height - margin),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin, size.height - margin - bracketSize),
      bracketPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CameraFeedPainter oldDelegate) {
    return oldDelegate.seed != seed || oldDelegate.isArmed != isArmed;
  }
}
