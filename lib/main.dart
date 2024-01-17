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
    _animation.addStatusListener(_addAnimationStatusListener)
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

