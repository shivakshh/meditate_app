import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MindfulnessBreathingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MindfulnessBreathingPage extends StatefulWidget {
  @override
  _MindfulnessBreathingPageState createState() => _MindfulnessBreathingPageState();
}

class _MindfulnessBreathingPageState extends State<MindfulnessBreathingPage> with SingleTickerProviderStateMixin {
  int counter = 0;
  bool isInhaling = true;
  bool isPlaying = false;
  int totalTimeInSeconds = 0;
  Timer? timer;
  Timer? breathingTimer;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    breathingTimer?.cancel();
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void startBreathing() {
    setState(() {
      isPlaying = true;
    });

    breathingTimer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      setState(() {
        if (isInhaling) {
          counter++;
          if (counter >= 5) {
            isInhaling = false;
          }
        } else {
          counter--;
          if (counter <= 0) {
            isInhaling = true;
          }
        }
      });
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        totalTimeInSeconds++;
      });
    });
  }

  void pauseBreathing() {
    setState(() {
      isPlaying = false;
    });
    breathingTimer?.cancel();
    timer?.cancel();
  }

  String get formattedTime {
    final minutes = (totalTimeInSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (totalTimeInSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mindfulness Breathing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mindfulness Breathing',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              counter.toString(),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              isInhaling ? 'Inhaling' : 'Exhaling',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 48),
              onPressed: isPlaying ? pauseBreathing : startBreathing,
            ),
            SizedBox(height: 20),
            Text(
              'Time: $formattedTime',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  StressLine(),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CosinePainter(scale: 100), // Adjust scale here
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CosinePainter extends CustomPainter {
  final double scale;

  CosinePainter({required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
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

class StressLine extends StatefulWidget {
  @override
  _StressLineState createState() => _StressLineState();
}

class _StressLineState extends State<StressLine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 4,
              height: 200,
              color: Colors.grey,
            ),
            Positioned(
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(270 / 360),
                child: Text(
                  'Stress',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double t = _controller.value;
                double y = 90 * (1 + cos(t * 2 * pi)); // cos(x) graph from top to bottom
                return Positioned(
                  top: y,
                  child: child!,
                );
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        Text('Present', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
