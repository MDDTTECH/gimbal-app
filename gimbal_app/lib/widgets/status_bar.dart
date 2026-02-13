import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/glass_morphism.dart';
import '../models/mock_data.dart';

class GimbalStatusBar extends StatelessWidget {
  final GimbalState state;

  const GimbalStatusBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      borderRadius: 16,
      opacity: 0.08,
      child: Row(
        children: [
          // Connection status
          _StatusDot(
            isActive: state.isConnected,
            activeColor: AppColors.success,
          ),
          const SizedBox(width: 8),
          Text(
            state.isConnected ? 'Gremsy T7' : 'Disconnected',
            style: TextStyle(
              color: state.isConnected
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          if (state.isConnected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                state.mode,
                style: const TextStyle(
                  color: AppColors.accentCyan,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const Spacer(),
          // Signal
          if (state.isConnected) ...[
            _SignalIndicator(strength: state.signalStrength),
            const SizedBox(width: 12),
            // Battery
            _BatteryIndicator(percent: state.batteryPercent),
          ],
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool isActive;
  final Color activeColor;

  const _StatusDot({
    required this.isActive,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor : AppColors.textMuted,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
    );
  }
}

class _SignalIndicator extends StatelessWidget {
  final double strength;

  const _SignalIndicator({required this.strength});

  @override
  Widget build(BuildContext context) {
    final bars = (strength * 4).round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          Icons.wifi,
          size: 14,
          color: bars >= 3 ? AppColors.success : AppColors.warning,
        ),
        const SizedBox(width: 4),
        Text(
          '${(strength * 100).round()}%',
          style: TextStyle(
            color: bars >= 3 ? AppColors.success : AppColors.warning,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BatteryIndicator extends StatelessWidget {
  final int percent;

  const _BatteryIndicator({required this.percent});

  @override
  Widget build(BuildContext context) {
    final color = percent > 20 ? AppColors.success : AppColors.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Battery icon
        Container(
          width: 22,
          height: 11,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: color, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(0.5),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 2,
          height: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(1),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$percent%',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
