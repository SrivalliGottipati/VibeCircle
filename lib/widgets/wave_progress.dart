import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WaveProgress extends StatelessWidget {
  final int step; // 1 or 2
  const WaveProgress({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _WaveSegment(active: step >= 1)),
        const SizedBox(width: 8),
        Expanded(child: _WaveSegment(active: step >= 2)),
      ],
    );
  }
}

class _WaveSegment extends StatelessWidget {
  final bool active;
  const _WaveSegment({required this.active});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WavePainter(
        color: active ? AppColors.primaryAccent : AppColors.text4,
      ),
      child: const SizedBox(height: 14),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    double waveHeight = 4;
    double waveLength = 14;

    path.moveTo(0, size.height / 2);

    for (double x = 0; x <= size.width; x += waveLength) {
      path.relativeQuadraticBezierTo(
          waveLength / 4, -waveHeight, waveLength / 2, 0);
      path.relativeQuadraticBezierTo(
          waveLength / 4, waveHeight, waveLength / 2, 0);
    }

    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => false;
}
