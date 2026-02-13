import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanController;
  bool _isConnecting = false;
  bool _isConnected = false;
  String _statusText = 'Searching for Gremsy T7...';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _simulateConnection();
  }

  Future<void> _simulateConnection() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _isConnecting = true;
      _statusText = 'Gremsy T7 found — Connecting...';
    });

    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    setState(() {
      _isConnected = true;
      _statusText = 'Connected via WiFi (10.10.10.254)';
    });

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.bgGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Animated gimbal icon
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Scanning rings
                    ...List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _scanController,
                        builder: (context, child) {
                          final delay = index * 0.33;
                          final value =
                              (_scanController.value + delay) % 1.0;
                          return Opacity(
                            opacity: (1 - value) * 0.4,
                            child: Container(
                              width: 80 + value * 120,
                              height: 80 + value * 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _isConnected
                                      ? AppColors.success
                                      : AppColors.accentCyan,
                                  width: 1.5 * (1 - value),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    // Center icon
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale =
                            1.0 + sin(_pulseController.value * 2 * pi) * 0.05;
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  (_isConnected
                                          ? AppColors.success
                                          : AppColors.accentCyan)
                                      .withValues(alpha: 0.3),
                                  (_isConnected
                                          ? AppColors.success
                                          : AppColors.accentCyan)
                                      .withValues(alpha: 0.05),
                                ],
                              ),
                              border: Border.all(
                                color: (_isConnected
                                        ? AppColors.success
                                        : AppColors.accentCyan)
                                    .withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _isConnected
                                  ? Icons.check_rounded
                                  : _isConnecting
                                      ? Icons.wifi
                                      : Icons.radar_rounded,
                              color: _isConnected
                                  ? AppColors.success
                                  : AppColors.accentCyan,
                              size: 36,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // App name
              Text(
                'GIMBAL',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 12,
                  foreground: Paint()
                    ..shader = AppColors.primaryGradient.createShader(
                      const Rect.fromLTWH(0, 0, 200, 40),
                    ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.3, curve: Curves.easeOut),
              const SizedBox(height: 4),
              Text(
                'CONTROL',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 8,
                  color: AppColors.textMuted,
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 200.ms)
                  .slideY(begin: 0.3, curve: Curves.easeOut),
              const Spacer(flex: 2),
              // Status text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  _statusText,
                  key: ValueKey(_statusText),
                  style: TextStyle(
                    color: _isConnected
                        ? AppColors.success
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isConnected)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accentCyan.withValues(alpha: 0.5),
                  ),
                ),
              if (_isConnected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 24,
                ).animate().scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      curve: Curves.elasticOut,
                      duration: 600.ms,
                    ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
