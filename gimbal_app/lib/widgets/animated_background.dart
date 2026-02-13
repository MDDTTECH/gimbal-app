import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AppColors.bgGradient,
          ),
          child: Stack(
            children: [
              // Floating orb 1
              Positioned(
                top: MediaQuery.of(context).size.height * 0.1 +
                    sin(_controller.value * 2 * pi) * 30,
                right: -60 + cos(_controller.value * 2 * pi) * 20,
                child: _GlowOrb(
                  color: AppColors.accentCyan,
                  size: 200,
                  opacity: 0.08,
                ),
              ),
              // Floating orb 2
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.15 +
                    cos(_controller.value * 2 * pi) * 25,
                left: -40 + sin(_controller.value * 2 * pi + 1) * 15,
                child: _GlowOrb(
                  color: AppColors.accentPurple,
                  size: 180,
                  opacity: 0.06,
                ),
              ),
              // Floating orb 3
              Positioned(
                top: MediaQuery.of(context).size.height * 0.5 +
                    sin(_controller.value * 2 * pi + 2) * 20,
                right: MediaQuery.of(context).size.width * 0.3 +
                    cos(_controller.value * 2 * pi + 2) * 30,
                child: _GlowOrb(
                  color: AppColors.accentBlue,
                  size: 120,
                  opacity: 0.05,
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _GlowOrb({
    required this.color,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
