import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

import 'timer_painter.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;

  const CountdownTimer({Key? key, required this.duration}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> with TickerProviderStateMixin {
  // Animation
  late AnimationController _animationController;
  late Duration _maxDuration;

  @override
  void initState() {
    super.initState();
    _maxDuration = widget.duration;
    _animationController = AnimationController(vsync: this, duration: _maxDuration, value: 1);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        /// Timer widget
        _stopwatch(),

        SizedBox(height: 30.0),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            /// Add button
            _button(Icons.add, _onPressedAdd),

            /// Play button
            _button(
              _animationController.isAnimating ? Icons.pause : Icons.play_arrow,
              _onPressedPlayPause,
            ),

            /// Refresh button
            _button(Icons.refresh, _onPressedReset),

            /// Delete button
            _button(Icons.delete, _onPressedDelete),
          ],
        )
      ],
    );
  }

  Widget _stopwatch() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        /// Cursor
        Container(
          height: 265.0,
          width: 265.0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: customColors.secondaryBackground),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: TimerPainter(
                  animation: _animationController,
                  borderColor: customColors.secondaryBackground,
                  cursorColor: Color.fromRGBO(169, 208, 119, 1),
                ),
              );
            },
          ),
        ),

        /// Timer
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, Widget? child) {
                return Text(
                  _timeString(),
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            )
          ],
        ),
      ],
    );
  }

  Widget _button(IconData iconData, VoidCallback onPressed) {
    return FloatingActionButton(
      backgroundColor: Color.fromRGBO(254, 247, 246, 1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, Widget? child) {
          return Icon(
            iconData,
            color: Color.fromRGBO(169, 208, 119, 1),
          );
        },
      ),
      onPressed: onPressed,
    );
  }

  String _timeString() {
    Duration currentDuration = (_animationController.duration ?? _maxDuration) * _animationController.value;
    String res = '${currentDuration.inMinutes}:${(currentDuration.inSeconds % 60).floor().toString().padLeft(2, '0')}';

    return res;
  }

  _onPressedAdd() {
    setState(() {
      // Stop animation
      _animationController.stop();

      // Current duration
      Duration currentDuration = (_animationController.duration ?? _maxDuration) * _animationController.value;

      // New duration
      Duration newDuration = currentDuration + Duration(seconds: 60);
      if (newDuration > _maxDuration) {
        // Calculation
        // 1	                  20 + 1
        // k = 20.5 / 21        19.5 + 1

        // Replace current duration
        _maxDuration += Duration(seconds: 60);
        _animationController.duration = _maxDuration;
      } else {
        // Calculation
        // 1	                  20
        // k = 19.5 / 20		    18.5 + 1
      }

      // Set animation value
      _animationController.value = newDuration.inSeconds / _maxDuration.inSeconds;

      // Resume animation
      _animationController.reverse(
        from: _animationController.value == 0.0 ? 1.0 : _animationController.value,
      );
    });
  }

  _onPressedPlayPause() {
    setState(() {
      if (_animationController.isAnimating) {
        _animationController.stop();
      } else {
        _animationController.reverse(from: _animationController.value == 0.0 ? 1.0 : _animationController.value);
      }
    });
  }

  _onPressedReset() {
    setState(() {
      _animationController.reset();
      _animationController.duration = widget.duration;
      _animationController.value = 1.0;
    });
  }

  _onPressedDelete() {
    print('onPressedDelete');
  }
}
