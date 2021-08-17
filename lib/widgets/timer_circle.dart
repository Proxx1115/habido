import 'package:flutter/material.dart';

class TimerCircle extends StatefulWidget {
  final Duration duration;
  final VoidCallback onFinished;

  const TimerCircle({
    Key? key,
    required this.duration,
    required this.onFinished,
  }) : super(key: key);

  @override
  _TimerCircleState createState() => _TimerCircleState();
}

class _TimerCircleState extends State<TimerCircle> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  _onFinished() {
    widget.onFinished();
  }
}

class ParentWidget extends StatefulWidget {
  const ParentWidget({Key? key}) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  @override
  Widget build(BuildContext context) {
    return TimerCircle(
      duration: Duration(minutes: 30),
      onFinished: () {
        print('');
      },
    );
  }
}
