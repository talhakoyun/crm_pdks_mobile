import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/base/base_singleton.dart';
import '../core/init/theme/theme_extensions.dart';
import '../core/init/network/connectivity/network_connectivity.dart';
import '../viewModel/auth_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
<<<<<<< Updated upstream
    with BaseSingleton, SizeSingleton {
=======
    with BaseSingleton, TickerProviderStateMixin {
>>>>>>> Stashed changes
  final viewModel = AuthViewModel();
  late NetworkConnectivity networkConnectivity;
  @override
  initState() {
    super.initState();
    viewModel.init();
    viewModel.splashCheck(context);
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.disp();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        return Scaffold(
<<<<<<< Updated upstream
          backgroundColor: context.colorScheme.primary,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imgCons.splashLogo,
                      width: sizeConfig.widthSize(context, 115),
                      height: sizeConfig.heightSize(context, 145),
                    ),
                    context.emptySizedHeightBoxLow3x,
                    Text(
                      strCons.appName,
                      style: context.primaryTextTheme.headlineLarge!.copyWith(
                        letterSpacing: 5,
                        fontSize: 45,
                      ),
                    ),
                    context.emptySizedHeightBoxLow,
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text.rich(
                        TextSpan(
                          text:
                              "${strCons.splashText1} "
                              "${strCons.splashText2}",
                        ),
                        style: context.primaryTextTheme.bodyMedium!.copyWith(
                          letterSpacing: 0.75,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
=======
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.secondary,
                  context.colorScheme.primary.withValues(alpha: 0.8),
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
                                  width: 145.w,
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
                          context.gapLG,
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
                                              context.colorScheme.onError,
                                              context.colorScheme.tertiary,
                                              context.colorScheme.onError,
                                            ],
                                            stops: const [0.0, 0.5, 1.0],
                                          ).createShader(bounds),
                                      child: Text(
                                        strCons.appName,
                                        style: context.textTheme.displayMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                              color:
                                                  context.colorScheme.onError,
                                              shadows: [
                                                Shadow(
                                                  color: context
                                                      .colorScheme
                                                      .errorContainer
                                                      .withValues(alpha: 0.3),
                                                  offset: const Offset(2, 2),
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                      ),
                                    ),
                                    context.gapSM,
                                    Text(
                                      "${strCons.splashText1} ${strCons.splashText2}",
                                      style: context.textTheme.bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: 1.2,
                                            color: context.colorScheme.onError
                                                .withValues(alpha: 0.9),
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          context.gapXS,
                          AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: PulseLoadingPainter(
                                  _rotationAnimation.value,
                                  context.colorScheme.tertiary,
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
                                style: context.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: context.colorScheme.surface.withValues(
                                    alpha: 0.9,
                                  ),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
>>>>>>> Stashed changes
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Text.rich(
                      TextSpan(
                        text: strCons.companyText,
                        style: context.primaryTextTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: strCons.splashFooter,
                            style: context.primaryTextTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
<<<<<<< Updated upstream
=======

  Widget _buildPulseRings() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: PulseRingsPainter(
              _pulseAnimation.value,
              context.colorScheme.tertiary,
            ),
          ),
        );
      },
    );
  }
}

class PulseRingsPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  PulseRingsPainter(this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final radius = (50 + i * 30) * animationValue;
      final opacity = (1.0 - animationValue) * 0.3;

      paint.color = color.withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PulseLoadingPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  PulseLoadingPainter(this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
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
>>>>>>> Stashed changes
}
