import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final Color primaryColor;
  final bool isRecording;
  final double playbackProgress; // 0.0 a 1.0

  WaveformPainter({
    required this.waveformData,
    required this.primaryColor,
    required this.isRecording,
    required this.playbackProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final paint =
        Paint()
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;

    final barWidth = size.width / waveformData.length;
    final centerY = size.height / 2;

    for (int i = 0; i < waveformData.length; i++) {
      final x = i * barWidth + barWidth / 2;
      final amplitude = waveformData[i];

      // Altura de la barra basada en la amplitud (mínimo 4.0 para visibilidad)
      final barHeight = (amplitude * size.height * 0.8).clamp(4.0, size.height);

      // Dibujar barra vertical centrada
      final startY = centerY - barHeight / 2;
      final endY = centerY + barHeight / 2;

      if (isRecording) {
        // Durante la grabación: todas las barras grises con efecto de gradiente
        if (i > waveformData.length - 10) {
          final opacity = (i - (waveformData.length - 10)) / 10;
          paint.color = Colors.grey.withValues(alpha: 0.3 + (opacity * 0.7));
        } else {
          paint.color = Colors.grey;
        }
      } else {
        final barProgress = i / waveformData.length;
        if (barProgress <= playbackProgress) {
          paint.color = primaryColor;
        } else {
          paint.color = Colors.grey.withValues(alpha: 0.5);
        }
      }

      canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.waveformData != waveformData ||
        oldDelegate.isRecording != isRecording ||
        oldDelegate.playbackProgress != playbackProgress;
  }
}