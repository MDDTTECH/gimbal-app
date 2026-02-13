import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../theme/glass_morphism.dart';
import '../widgets/status_bar.dart';
import '../models/mock_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _panSpeed = 0.7;
  double _tiltSpeed = 0.6;
  double _smoothness = 0.8;
  bool _autoCalibrate = true;
  bool _wifiPreferred = true;
  bool _hapticFeedback = true;
  String _connectionType = 'WiFi';

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

            const Text(
              'SETTINGS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
                color: AppColors.textMuted,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Connection section
                    _SectionHeader(title: 'CONNECTION')
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 150.ms),
                    const SizedBox(height: 8),
                    GlassContainer(
                      borderRadius: 16,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _SettingRow(
                            icon: Icons.wifi,
                            label: 'Connection Type',
                            trailing: _ConnectionToggle(
                              value: _connectionType,
                              onChanged: (v) =>
                                  setState(() => _connectionType = v),
                            ),
                          ),
                          _Divider(),
                          _SettingRow(
                            icon: Icons.language,
                            label: 'Gimbal IP',
                            trailing: const Text(
                              '10.10.10.254',
                              style: TextStyle(
                                color: AppColors.accentCyan,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                          _Divider(),
                          _SettingRow(
                            icon: Icons.sync,
                            label: 'Auto-reconnect',
                            trailing: _GlassSwitch(
                              value: _wifiPreferred,
                              onChanged: (v) =>
                                  setState(() => _wifiPreferred = v),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                    const SizedBox(height: 20),

                    // Control section
                    _SectionHeader(title: 'CONTROL')
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 250.ms),
                    const SizedBox(height: 8),
                    GlassContainer(
                      borderRadius: 16,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _SliderSetting(
                            icon: Icons.swap_horiz,
                            label: 'Pan Speed',
                            value: _panSpeed,
                            color: AppColors.accentCyan,
                            onChanged: (v) =>
                                setState(() => _panSpeed = v),
                          ),
                          _Divider(),
                          _SliderSetting(
                            icon: Icons.swap_vert,
                            label: 'Tilt Speed',
                            value: _tiltSpeed,
                            color: AppColors.accentPurple,
                            onChanged: (v) =>
                                setState(() => _tiltSpeed = v),
                          ),
                          _Divider(),
                          _SliderSetting(
                            icon: Icons.waves,
                            label: 'Smoothness',
                            value: _smoothness,
                            color: AppColors.accentBlue,
                            onChanged: (v) =>
                                setState(() => _smoothness = v),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                    const SizedBox(height: 20),

                    // General section
                    _SectionHeader(title: 'GENERAL')
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 350.ms),
                    const SizedBox(height: 8),
                    GlassContainer(
                      borderRadius: 16,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _SettingRow(
                            icon: Icons.tune,
                            label: 'Auto-calibrate',
                            trailing: _GlassSwitch(
                              value: _autoCalibrate,
                              onChanged: (v) =>
                                  setState(() => _autoCalibrate = v),
                            ),
                          ),
                          _Divider(),
                          _SettingRow(
                            icon: Icons.vibration,
                            label: 'Haptic Feedback',
                            trailing: _GlassSwitch(
                              value: _hapticFeedback,
                              onChanged: (v) =>
                                  setState(() => _hapticFeedback = v),
                            ),
                          ),
                          _Divider(),
                          _SettingRow(
                            icon: Icons.info_outline,
                            label: 'Firmware Version',
                            trailing: const Text(
                              'v7.7.2',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                    const SizedBox(height: 20),

                    // About
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'GIMBAL CONTROL',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3,
                              foreground: Paint()
                                ..shader = AppColors.primaryGradient
                                    .createShader(
                                  const Rect.fromLTWH(0, 0, 150, 20),
                                ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'v1.0.0 • Gremsy T7',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 450.ms),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  const _SliderSetting({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              '${(value * 100).round()}%',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            activeTrackColor: color,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.05),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.1),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _GlassSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _GlassSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: value ? AppColors.primaryGradient : null,
          color: value ? null : Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: value
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                if (value)
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.3),
                    blurRadius: 6,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionToggle extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _ConnectionToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['WiFi', 'BLE'].map((type) {
          final isActive = value == type;
          return GestureDetector(
            onTap: () => onChanged(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isActive
                    ? AppColors.accentCyan.withValues(alpha: 0.2)
                    : Colors.transparent,
              ),
              child: Text(
                type,
                style: TextStyle(
                  color: isActive ? AppColors.accentCyan : AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white.withValues(alpha: 0.05),
    );
  }
}
