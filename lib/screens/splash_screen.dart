import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _loadingController;
  late AnimationController _particleController;

  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();

    // Generate particles
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 1,
        speed: _random.nextDouble() * 0.3 + 0.1,
        delay: _random.nextDouble() * 2,
      ));
    }

    // Start animations
    Future.delayed(const Duration(milliseconds: 200), () {
      _logoController.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _loadingController.forward();
    });

    // Navigate after loading completes
    Future.delayed(const Duration(milliseconds: 3500), () {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _loadingController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [Color(0xFF1E1E1E), AppColors.background],
          ),
        ),
        child: Stack(
          children: [
            // Particle layer
            CustomPaint(
              size: Size.infinite,
              painter: _ParticlePainter(
                particles: _particles,
                animation: _particleController,
              ),
            ),
            // Background ambient glow
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    colors: [
                      AppColors.primary.withAlpha(15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo with glow
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _logoController,
                      curve: Curves.easeOut,
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _logoController,
                        curve: Curves.easeOut,
                      )),
                      child: _buildLogo(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Brand text
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _logoController,
                      curve: const Interval(0.3, 1.0),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _logoController,
                        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                      )),
                      child: Column(
                        children: [
                          const Text(
                            'Zenith',
                            style: TextStyle(
                              fontSize: 32,
                              height: 1.25,
                              letterSpacing: -0.02,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'THE PROFESSIONAL STANDARD',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.15,
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Loading bar
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _logoController,
                      curve: const Interval(0.5, 1.0),
                    ),
                    child: _buildLoadingBar(),
                  ),
                ],
              ),
            ),
            // Version footer
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _logoController,
                  curve: const Interval(0.7, 1.0),
                ),
                child: const Text(
                  'v2.4.0  \u00a9 2024 Zenith Financial Systems',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.outline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(38),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _LogoPainter(),
        child: const Center(
          child: Icon(
            Icons.show_chart_rounded,
            size: 48,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBar() {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors.outlineVariant,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 200 * _loadingController.value,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primary.withAlpha(38),
          AppColors.primary.withAlpha(0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Animation<double> animation;

  _ParticlePainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary.withAlpha(77);

    for (final p in particles) {
      final progress = (animation.value * 5 + p.delay) % 1.0;
      final yOffset = progress * size.height * 0.3;
      final opacity = progress < 0.5
          ? (progress * 2)
          : (1 - progress) * 2;

      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height - yOffset),
        p.size,
        paint..color = AppColors.primary.withAlpha((opacity * 77).toInt()),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
