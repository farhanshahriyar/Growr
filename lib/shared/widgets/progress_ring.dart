import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'dart:math' as math;

class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProgressRingPainter(
          progress: progress,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerLow
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    // Foreground arc
    final gradient = const SweepGradient(
      colors: [AppColors.primary, AppColors.secondary, AppColors.primary],
      stops: [0.0, 0.5, 1.0],
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    final fgPaint = Paint()
      ..shader = gradient
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.strokeWidth != strokeWidth;
  }
}
