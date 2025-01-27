import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:weather/app/common/dimens/dimens.dart';

class GaugeWidget extends StatelessWidget {
  final String unit;
  final String title;
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double maxValue;

  const GaugeWidget({
    Key? key,
    required this.progress,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    required this.title,
    required this.maxValue, required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(Get.context!).size.width * 0.45;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFADD8E6).withOpacity(0.2)),
      width: size,
      height: size,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: CustomPaint(
          painter: _HumidityGaugePainter(
            humidity: progress,
            progressColor: progressColor,
            backgroundColor: backgroundColor,
            maxValue: maxValue,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${progress.toStringAsFixed(0)}$unit',
                  style: AppTextStyle.largeSubHeaderStyle
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size * 0.08,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HumidityGaugePainter extends CustomPainter {
  final double humidity;
  final Color progressColor;
  final Color backgroundColor;
  final double maxValue;

  _HumidityGaugePainter(
      {required this.humidity,
      required this.progressColor,
      required this.backgroundColor,
      required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.2;

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor.withOpacity(0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi * 0.7,
      math.pi * 1.6,
      false,
      backgroundPaint,
    );

    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressAngle = (humidity / maxValue) * math.pi * 1.6;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi * 0.7,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_HumidityGaugePainter oldDelegate) {
    return humidity != oldDelegate.humidity ||
        progressColor != oldDelegate.progressColor ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
