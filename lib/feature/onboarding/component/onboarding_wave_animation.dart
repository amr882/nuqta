import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nuqta/core/theme/app_colors.dart';

class OnboardingWaveAnimation extends StatefulWidget {
  final int waveCount;
  final Duration duration;
  final double maxRadius;
  final double strokeWidth;
  final Color? color;
  final double centerDotRadius;

  const OnboardingWaveAnimation({
    super.key,
    this.waveCount = 3,
    this.duration = const Duration(milliseconds: 2500),
    this.maxRadius = 140,
    this.strokeWidth = 1.5,
    this.color,
    this.centerDotRadius = 6,
  });

  @override
  State<OnboardingWaveAnimation> createState() =>
      _OnboardingWaveAnimationState();
}

class _OnboardingWaveAnimationState extends State<OnboardingWaveAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.maxRadius * 2, widget.maxRadius * 2),
            painter: _WavePainter(
              progress: _controller.value,
              waveCount: widget.waveCount,
              maxRadius: widget.maxRadius,
              strokeWidth: widget.strokeWidth,
              color: widget.color ?? AppColors.primary,
              centerDotRadius: widget.centerDotRadius,
            ),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final int waveCount;
  final double maxRadius;
  final double strokeWidth;
  final Color color;
  final double centerDotRadius;

  late final Paint _wavePaint;
  late final Paint _outerRingPaint;
  late final Paint _deepRingPaint;
  late final Paint _whitePaint;

  _WavePainter({
    required this.progress,
    required this.waveCount,
    required this.maxRadius,
    required this.strokeWidth,
    required this.color,
    required this.centerDotRadius,
  }) : _wavePaint = Paint()..style = PaintingStyle.stroke,
       _outerRingPaint = Paint()
         ..color = AppColors.primaryLight
         ..style = PaintingStyle.fill,
       _deepRingPaint = Paint()
         ..color = AppColors.primaryDark
         ..style = PaintingStyle.fill,
       _whitePaint = Paint()
         ..color = Colors.white
         ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < waveCount; i++) {
      final double waveProgress = (progress + i / waveCount) % 1.0;

      final double minWaveRadius = centerDotRadius + 8;
      final double radius =
          minWaveRadius + waveProgress * (maxRadius - minWaveRadius);

      final double opacity = (1.0 - waveProgress).clamp(0.0, 1.0);

      final double smoothOpacity = math.sin(opacity * math.pi / 2) * 0.55;

      _wavePaint
        ..color = color.withValues(alpha: smoothOpacity)
        ..strokeWidth = strokeWidth * (1.0 - waveProgress * 0.5);

      canvas.drawCircle(center, radius, _wavePaint);
    }
    canvas.drawCircle(center, centerDotRadius + 5, _outerRingPaint);

    canvas.drawCircle(center, centerDotRadius + 2, _deepRingPaint);
    canvas.drawCircle(center, centerDotRadius, _whitePaint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
