// lib/widgets/timer_circle.dart

import 'dart:async';
import 'package:flutter/material.dart';

class TimerController {
  _TimerCircleState? _state;

  void start() {
    _state?._startTimer();
  }

  void pause() {
    _state?.pauseTimer();
  }

  void resume() {
    _state?.resumeTimer();
  }

  void reset() {
    _state?.resetTimer();
  }
}

class TimerCircle extends StatefulWidget {
  final int seconds;
  final Color color;
  final VoidCallback? onTimerComplete;
  final bool autoStart;
  final TimerController? controller;
  final ValueChanged<int>? onTick;

  const TimerCircle({
    super.key,
    required this.seconds,
    this.color = Colors.purple,
    this.onTimerComplete,
    this.autoStart = true,
    this.controller,
    this.onTick,
  });

  @override
  State<TimerCircle> createState() => _TimerCircleState();
}

class _TimerCircleState extends State<TimerCircle>
    with TickerProviderStateMixin {
  late int _remainingSeconds;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    );

    _progressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_animationController);

    widget.controller?._state = this;

    if (widget.autoStart) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _animationController.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          widget.onTick?.call(_remainingSeconds);
        } else {
          _timer?.cancel();
          widget.onTimerComplete?.call();
        }
      });
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _animationController.stop();
  }

  void resumeTimer() {
    if (_remainingSeconds > 0) {
      _startTimer();
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _animationController.reset();
    setState(() {
      _remainingSeconds = widget.seconds;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(0.1),
            ),
          ),

          // Progress circle
          SizedBox(
            width: 180,
            height: 180,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: _progressAnimation.value,
                  strokeWidth: 8,
                  backgroundColor: widget.color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                );
              },
            ),
          ),

          // Inner circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),

          // Time display
          Text(
            _formatTime(_remainingSeconds),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}
