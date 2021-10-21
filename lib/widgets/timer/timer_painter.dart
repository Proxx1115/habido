import 'package:flutter/material.dart';

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color borderColor;
  final Color cursorColor;

  final double _pi = 3.14;

  TimerPainter({
    required this.animation,
    required this.borderColor,
    required this.cursorColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = 15.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), (size.width + 0.3) / 2.0, paint);
    paint.color = cursorColor;
    double progress = (1.0 - animation.value) * 2 * _pi;
    canvas.drawArc(Offset.zero & size, _pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value || cursorColor != old.cursorColor || borderColor != old.borderColor;
  }
}
