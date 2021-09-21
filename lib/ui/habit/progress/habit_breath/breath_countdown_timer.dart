import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';

class BreathCountdownTimer extends StatefulWidget {
  final Duration duration;
  final Color? primaryColor;
  final VoidCallback? callBack;

  const BreathCountdownTimer({
    Key? key,
    required this.duration,
    this.primaryColor,
    this.callBack,
  }) : super(key: key);

  @override
  _BreathCountdownTimerState createState() => _BreathCountdownTimerState();
}

class _BreathCountdownTimerState extends State<BreathCountdownTimer> with TickerProviderStateMixin {
  // Animation
  late AnimationController _animationController;
  late Duration _maxDuration;
  late Color _primaryColor;

  @override
  void initState() {
    _primaryColor = widget.primaryColor ?? customColors.primary;

    super.initState();

    _maxDuration = widget.duration;
    _animationController = AnimationController(
      vsync: this,
      duration: _maxDuration,
      value: 1,
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (widget.callBack != null) widget.callBack!();
          print('completed');
        }
      });
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
            /// Play button
            ButtonStadium(
              asset: _animationController.isAnimating ? Assets.play : Assets.play,
              iconColor: _primaryColor,
              onPressed: _onPressedPlayPause,
            ),

            SizedBox(width: 15.0),

            /// Reset button
            ButtonStadium(
              asset: Assets.reset,
              iconColor: _primaryColor,
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
        /// Background
        SvgPicture.asset(Assets.breath, color: _primaryColor, height: 265, width: 265),

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
