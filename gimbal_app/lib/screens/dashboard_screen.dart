import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../theme/glass_morphism.dart';
import '../widgets/joystick_widget.dart';
import '../widgets/gimbal_3d_indicator.dart';
import '../widgets/angle_display.dart';
import '../widgets/status_bar.dart';
import '../models/mock_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  GimbalState _gimbalState = MockData.connectedGimbal;
  String _controlMode = 'Follow';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          children: [
            // Status bar
            GimbalStatusBar(state: _gimbalState)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.2),
            const SizedBox(height: 16),

            // Mode selector
            _buildModeSelector()
                .animate()
                .fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 16),

            // 3D Indicator + Angle Gauges
            Row(
              children: [
                Expanded(
                  child: CircularAngleGauge(
                    label: 'PAN',
                    angle: _gimbalState.pan,
                    color: AppColors.accentCyan,
                    size: 80,
                  ),
                ),
                Gimbal3DIndicator(
                  pan: _gimbalState.pan,
                  tilt: _gimbalState.tilt,
                  roll: _gimbalState.roll,
                  size: 130,
                ),
                Expanded(
                  child: CircularAngleGauge(
                    label: 'TILT',
                    angle: _gimbalState.tilt,
                    maxAngle: 90,
                    color: AppColors.accentPurple,
                    size: 80,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .scale(begin: const Offset(0.9, 0.9)),
            const SizedBox(height: 16),

            // Angle sliders
            Row(
              children: [
                Expanded(
                  child: AngleDisplay(
                    label: 'PAN',
                    angle: _gimbalState.pan,
                    color: AppColors.accentCyan,
                    onChanged: (v) =>
                        setState(() => _gimbalState = _gimbalState.copyWith(pan: v)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AngleDisplay(
                    label: 'TILT',
                    angle: _gimbalState.tilt,
                    minAngle: -90,
                    maxAngle: 90,
                    color: AppColors.accentPurple,
                    onChanged: (v) =>
                        setState(() => _gimbalState = _gimbalState.copyWith(tilt: v)),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            const SizedBox(height: 8),
            AngleDisplay(
              label: 'ROLL',
              angle: _gimbalState.roll,
              color: AppColors.accentBlue,
              onChanged: (v) =>
                  setState(() => _gimbalState = _gimbalState.copyWith(roll: v)),
            ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

            const Spacer(),

            // Joystick
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                JoystickWidget(
                  size: 160,
                  label: 'Pan / Tilt',
                  onChanged: (offset) {
                    setState(() {
                      _gimbalState = _gimbalState.copyWith(
                        pan: _gimbalState.pan + offset.dx * 2,
                        tilt: _gimbalState.tilt + offset.dy * 2,
                      );
                    });
                  },
                ),
                Column(
                  children: [
                    GlassIconButton(
                      icon: Icons.home_rounded,
                      onTap: () {
                        setState(() {
                          _gimbalState = _gimbalState.copyWith(
                            pan: 0,
                            tilt: 0,
                            roll: 0,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Home',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GlassIconButton(
                      icon: Icons.lock_outline,
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lock',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 400.ms)
                .slideY(begin: 0.2),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    final modes = ['Follow', 'Lock', 'FPV'];
    return GlassContainer(
      padding: const EdgeInsets.all(4),
      borderRadius: 14,
      opacity: 0.06,
      child: Row(
        children: modes.map((mode) {
          final isActive = mode == _controlMode;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _controlMode = mode;
                _gimbalState = _gimbalState.copyWith(mode: mode);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: isActive ? AppColors.primaryGradient : null,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.accentCyan.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    mode,
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
