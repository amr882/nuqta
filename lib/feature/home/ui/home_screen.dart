// ignore_for_file: unused_element_parameter

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:nuqta/core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            child: Align(
              alignment: Alignment.center,
              child: _RadarPulse(),
            ),
          ),
          Center(
            child: Text(
              'nuqta',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingData {
  final double scale;
  final double opacity;

  const _RingData({
    required this.scale,
    required this.opacity,
  });
}

class _RadarPulse extends StatefulWidget {
  final Color color;
  final double dotSize;
  final double ringSize;
  final Duration duration;
  final int ringCount;
  final Duration stagger;
  final String semanticLabel;

  const _RadarPulse({
    super.key,
    this.color = AppColors.primary,
    this.dotSize = 22,
    this.ringSize = 110,
    this.duration = const Duration(milliseconds: 2800),
    this.ringCount = 3,
    this.stagger = const Duration(milliseconds: 1000),
    this.semanticLabel = 'You are here',
  });

  @override
  State<_RadarPulse> createState() => _RadarPulseState();
}

class _RadarPulseState extends State<_RadarPulse>
    with SingleTickerProviderStateMixin {
  static const Curve _curve = Cubic(0.2, 0.8, 0.2, 1.0);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      if (_controller.isAnimating) {
        _controller.stop();
      }
    } else {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void didUpdateWidget(covariant _RadarPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRing({
    required double scale,
    required double opacity,
  }) {
    if (opacity <= 0.0) {
      return const SizedBox.shrink();
    }

    final double effectiveFillAlpha = (0.22 * opacity).clamp(0.0, 1.0);
    final double effectiveBorderAlpha = (0.55 * opacity).clamp(0.0, 1.0);

    return OverflowBox(
      minWidth: 0,
      minHeight: 0,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.ringSize,
          height: widget.ringSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: effectiveFillAlpha),
            border: Border.all(
              color: widget.color.withValues(alpha: effectiveBorderAlpha),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterDot() {
    return Container(
      width: widget.dotSize,
      height: widget.dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations = MediaQuery.of(context).disableAnimations;

    final Widget content = disableAnimations
        ? Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _buildRing(
                scale: 1.4,
                opacity: 0.35,
              ),
              _buildCenterDot(),
            ],
          )
        : AnimatedBuilder(
            animation: _controller,
            child: _buildCenterDot(),
            builder: (context, child) {
              final double durationMs =
                  widget.duration.inMilliseconds.toDouble();
              final double controllerVal = _controller.value;

              final List<_RingData> rings =
                  List.generate(widget.ringCount, (i) {
                final double delayFraction = durationMs > 0
                    ? (widget.stagger.inMilliseconds * i) / durationMs
                    : 0.0;
                double t = (controllerVal - delayFraction) % 1.0;
                if (t < 0) {
                  t += 1.0;
                }
                final double e = _curve.transform(t);
                final double scale = lerpDouble(0.8, 2.5, e)!;
                final double opacity = lerpDouble(0.8, 0.0, e)!;
                return _RingData(scale: scale, opacity: opacity);
              });

              rings.sort((a, b) => b.scale.compareTo(a.scale));

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  for (final ring in rings)
                    _buildRing(
                      scale: ring.scale,
                      opacity: ring.opacity,
                    ),
                  ?child,
                ],
              );
            },
          );

    return Semantics(
      label: widget.semanticLabel,
      image: true,
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: SizedBox(
            width: widget.dotSize,
            height: widget.dotSize,
            child: IgnorePointer(
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
