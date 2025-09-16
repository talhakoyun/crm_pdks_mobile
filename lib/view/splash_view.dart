import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../core/base/base_singleton.dart';
import '../core/base/size_singleton.dart';
import '../core/extension/context_extension.dart';
import '../core/init/network/connectivity/network_connectivity.dart';
import '../viewModel/auth_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with BaseSingleton, SizeSingleton, TickerProviderStateMixin {
  final viewModel = AuthViewModel();
  late NetworkConnectivity networkConnectivity;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    viewModel.init();
    viewModel.splashCheck(context);
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _pulseController.repeat(reverse: true);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _rotationController.repeat();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _rotationController.dispose();
    super.dispose();
    viewModel.disp();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1E3A8A),
                  const Color(0xFF3B82F6),
                  const Color(0xFF1E40AF),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: Stack(
              children: [
                _buildPulseRings(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: sizeConfig.widthSize(context, 145),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image.asset(
                                      imgCons.logo,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          context.emptySizedHeightBoxLow3x,
                          AnimatedBuilder(
                            animation: _fadeAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _fadeAnimation.value,
                                child: Column(
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          LinearGradient(
                                            colors: [
                                              Colors.white,
                                              const Color(
                                                0xFFF97316,
                                              ), // Turuncu vurgu
                                              Colors.white,
                                            ],
                                            stops: const [0.0, 0.5, 1.0],
                                          ).createShader(bounds),
                                      child: Text(
                                        strCons.appName,
                                        style: TextStyle(
                                          fontSize: 38,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.3,
                                              ),
                                              offset: const Offset(2, 2),
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${strCons.splashText1} ${strCons.splashText2}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.2,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          context.emptySizedHeightBoxLow,
                          AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: PulseLoadingPainter(
                                  _rotationAnimation.value,
                                ),
                                size: const Size(50, 50),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value * 0.8,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "${strCons.companyText} ${strCons.splashFooter}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulseRings() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(painter: PulseRingsPainter(_pulseAnimation.value)),
        );
      },
    );
  }
}

class PulseRingsPainter extends CustomPainter {
  final double animationValue;

  PulseRingsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final radius = (50 + i * 30) * animationValue;
      final opacity = (1.0 - animationValue) * 0.3;

      paint.color = const Color(
        0xFFF97316,
      ).withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PulseLoadingPainter extends CustomPainter {
  final double animationValue;

  PulseLoadingPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFFF97316)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45.0 + animationValue * 360) * math.pi / 180;
      final x = center.dx + 15 * math.cos(angle);
      final y = center.dy + 15 * math.sin(angle);

      final dotSize = 3.0 + 2.0 * math.sin(animationValue * 2 * math.pi + i);
      canvas.drawCircle(Offset(x, y), dotSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
