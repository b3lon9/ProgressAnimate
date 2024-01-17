import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isProgressVisible = true;
  double _progressValueBefore = 0.0;

  // example listener
  void onProgressChanged(int value) {
    _animationController.reset();
    _animation.removeStatusListener(_addAnimationStatusListener);
    _animation = Tween<double>(begin: _progressValueBefore, end: value.toDouble()).animate(_animationController);
    _animation.addStatusListener(_addAnimationStatusListener);

    _animationController.forward();
    _progressValueBefore = value.toDouble();
  }

  void _addAnimationStatusListener(AnimationStatus status) {
    debugPrint('addAnimationStatusListener.. status:$status');
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2)
    );

    _animation = Tween<double>(begin: _progressValueBefore, end: _progressValueBefore).animate(_animationController);
    _animation.addStatusListener(_addAnimationStatusListener);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                child: const Text('This is WebView'),
              ),

              AnimatedOpacity(
                opacity: _isProgressVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Center(
                  child: SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) => CustomPaint(
                        painter: _LoadPainter(percentage: _animation.value.toDouble()),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadPainter extends CustomPainter {
  final double percentage;
  _LoadPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final double dx = size.width / 2;
    final double dy = size.height / 2;
    final double radius = dx;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(dx, dy), radius: radius),
      -math.pi / 2,
      math.pi * 2 / 100 * percentage,
      false,
      _LoadPaint()
    );

    TextSpan sp = TextSpan(
      text: "${percentage.toInt()} / 100",
      style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600, fontSize: 18),
    );

    TextPainter tp = TextPainter(
      text: sp,
      textDirection: TextDirection.ltr,
    );

    tp.layout();
    final txtDx = dx - tp.width / 2;
    final txtDy = dy - tp.height / 2;

    tp.paint(canvas, Offset(txtDx, txtDy));
  }

  @override
  bool shouldRepaint(covariant _LoadPainter oldDelegate) => oldDelegate.percentage != percentage;
}

class _LoadPaint extends Paint {
  _LoadPaint() {
    color = Colors.orangeAccent;
    strokeWidth = 5.0;
    strokeCap = StrokeCap.round;
    style = PaintingStyle.stroke;
  }
}