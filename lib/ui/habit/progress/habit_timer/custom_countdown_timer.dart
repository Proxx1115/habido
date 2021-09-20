import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'timer_painter.dart';

class CustomCountdownTimer extends StatefulWidget {
  final Duration duration;
  final Color? primaryColor;
  final bool visibleAddButton;

  const CustomCountdownTimer({
    Key? key,
    required this.duration,
    this.primaryColor,
    this.visibleAddButton = true,
  }) : super(key: key);

  @override
  _CustomCountdownTimerState createState() => _CustomCountdownTimerState();
}

class _CustomCountdownTimerState extends State<CustomCountdownTimer> with TickerProviderStateMixin {
  // Animation
  late AnimationController _animationController;
  late Duration _maxDuration;

  @override
  void initState() {
    super.initState();
    _maxDuration = widget.duration;
    _animationController = AnimationController(
      vsync: this,
      duration: _maxDuration,
      value: 1,
    );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// Add button
            if (widget.visibleAddButton)
              ButtonStadium(
                asset: Assets.add_circle,
                iconColor: widget.primaryColor ?? customColors.primary,
                onPressed: _onPressedAdd,
                margin: EdgeInsets.only(right: 15.0),
              ),

            /// Play button
            ButtonStadium(
              asset: _animationController.isAnimating ? Assets.play : Assets.play,
              iconColor: widget.primaryColor ?? customColors.primary,
              onPressed: _onPressedPlayPause,
            ),

            SizedBox(width: 15.0),

            /// Reset button
            ButtonStadium(
              asset: Assets.reset,
              iconColor: widget.primaryColor ?? customColors.primary,
              onPressed: _onPressedReset,
            ),
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
                  cursorColor: widget.primaryColor ?? customColors.primary,
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
}
