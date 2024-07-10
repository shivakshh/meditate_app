/*
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Shifted Graphs: cos(x) and -cos(x)')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust padding as needed
            child: Container(
              width: 400, // Set width constraint
              height: 400, // Set height constraint
              child: CustomPaint(
                painter: CosinePainter(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CosinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = 100; // Adjust scale for zooming
    final shift = pi / 2; // Shift amount

    // Draw cos(x)
    Path cosPath = Path();
    for (double x = -2 * pi; x <= 2 * pi; x += 0.01) {
      final xOffset = centerX + (x + shift) * scale;
      final yOffset = centerY - cos(x) * scale;
      if (x == -2 * pi) {
        cosPath.moveTo(xOffset, yOffset);
      } else {
        cosPath.lineTo(xOffset, yOffset);
      }
    }
    canvas.drawPath(cosPath, paint);

    // Draw -cos(x)
    paint.color = Colors.red;
    Path negCosPath = Path();
    for (double x = -2 * pi; x <= 2 * pi; x += 0.01) {
      final xOffset = centerX + (x + shift) * scale;
      final yOffset = centerY + cos(x) * scale;
      if (x == -2 * pi) {
        negCosPath.moveTo(xOffset, yOffset);
      } else {
        negCosPath.lineTo(xOffset, yOffset);
      }
    }
    canvas.drawPath(negCosPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

*/