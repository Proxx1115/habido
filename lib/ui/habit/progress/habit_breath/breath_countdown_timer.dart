import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';

class BreathCountdownTimer extends StatefulWidget {
  final Color? primaryColor;
  final VoidCallback? callBack;

  const BreathCountdownTimer({
    Key? key,
    this.primaryColor,
    this.callBack,
  }) : super(key: key);

  @override
  _BreathCountdownTimerState createState() => _BreathCountdownTimerState();
}

class _BreathCountdownTimerState extends State<BreathCountdownTimer> with TickerProviderStateMixin {
  // Animation
  late AnimationController _animationController;
  var _maxDuration = Duration(seconds: 48);
  late Color _primaryColor;

  @override
  void initState() {
    _primaryColor = widget.primaryColor ?? customColors.primary;

    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: _maxDuration,
      value: 1,
    )..addStatusListener((AnimationStatus status) {
        print(status);
        if (status == AnimationStatus.dismissed) {
          if (widget.callBack != null) widget.callBack!();
          _onPressedReset();
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
              asset: _animationController.isAnimating ? Assets.pause : Assets.play,
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
                return Column(
                  children: [
                    /// Step
                    Text(
                      _timeString(),
                      maxLines: 1,
                      style: TextStyle(
                        color: customColors.whiteText,
                        fontSize: 55,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 5),

                    /// Status
                    Text(
                      _statusString(),
                      maxLines: 2,
                      style: TextStyle(
                        color: customColors.whiteText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
    int sec = currentDuration.inSeconds;

    String res = '';
    int tmp = (sec ~/ 4) * 4;
    res = (sec - tmp).toString();
    res = (res == '0') ? '4' : res;

    return res;
  }

  String _statusString() {
    Duration currentDuration = (_animationController.duration ?? _maxDuration) * _animationController.value;

    // todo test
    // Easiest way too ez
    int sec = currentDuration.inSeconds;
    String res = '';
    if ((0 <= sec && sec <= 4) || (12 < sec && sec <= 16) || (24 < sec && sec <= 28) || (36 < sec && sec <= 40)) {
      res = LocaleKeys.breatheTake;
    } else if ((4 < sec && sec <= 8) || (16 < sec && sec <= 20) || (28 < sec && sec <= 32) || (40 < sec && sec <= 44)) {
      res = LocaleKeys.breatheHold;
    } else if ((8 <= sec && sec <= 12) ||
        (20 < sec && sec <= 24) ||
        (32 < sec && sec <= 36) ||
        (44 < sec && sec <= 48)) {
      res = LocaleKeys.breatheExhale;
    }

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
      _animationController.duration = _maxDuration;
      _animationController.value = 1.0;
    });
  }
}
