import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
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
  // UI
  late Color _primaryColor;

  // Animation
  late AnimationController _animationController;
  var _maxDuration = Duration(seconds: 48);
  double _breathingMaxSize = 265.0;
  final k = 4000;

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
        Container(
          height: 265.0,
          child: _timerWidget(),
        ),

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

  Widget _timerWidget() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, Widget? child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            /// Breathing widget
            _breathingWidget(),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ],
        );
      },
    );
  }

  Widget _breathingWidget() {
    Duration currentDuration = (_animationController.duration ?? _maxDuration) * _animationController.value;

    double minValue = 0.8;
    double maxValue = 1;
    late double value;

    // Easiest way too ez
    // int inMilliseconds = currentDuration.inSeconds;
    int inMilliseconds = currentDuration.inMilliseconds;
    if (0 == inMilliseconds) {
      value = minValue;
    } else if ((0 <= inMilliseconds && inMilliseconds < 4000) ||
        (12000 <= inMilliseconds && inMilliseconds < 16000) ||
        (24000 <= inMilliseconds && inMilliseconds < 28000) ||
        (36000 <= inMilliseconds && inMilliseconds < 40000)) {
      /// Exhale a breath
      int tmp = (inMilliseconds ~/ 4000) * 4000;
      var tmpMilliseconds = Func.toDouble(inMilliseconds - tmp);
      // print(value);
      value = tmpMilliseconds / 4000;

      // 0.2 - 1
      // x - 0.5
      value = minValue + 0.2 * value;
    } else if ((4000 <= inMilliseconds && inMilliseconds < 8000) ||
        (16000 <= inMilliseconds && inMilliseconds < 20000) ||
        (28000 <= inMilliseconds && inMilliseconds < 32000) ||
        (40000 <= inMilliseconds && inMilliseconds < 44000)) {
      /// Hold a breath
      value = maxValue;
    } else if ((8000 <= inMilliseconds && inMilliseconds < 12000) ||
        (20000 <= inMilliseconds && inMilliseconds < 24000) ||
        (32000 <= inMilliseconds && inMilliseconds < 36000) ||
        (44000 <= inMilliseconds && inMilliseconds < 48000)) {
      /// Take a breath
      int tmp = (inMilliseconds ~/ 4000) * 4000;
      var tmpMilliseconds = Func.toDouble(inMilliseconds - tmp);
      // print(value);
      value = tmpMilliseconds / 4000;
      value = 1 - value;

      value = minValue + 0.2 * value;
      // print(value);
    } else if (inMilliseconds == 48000) {
      value = minValue;
    }

    if (value == 1) {
      print('here');
    }

    return SvgPicture.asset(
      Assets.breath,
      color: _primaryColor,
      height: _breathingMaxSize * value,
      width: _breathingMaxSize * value,
    );
  }

  String _timeString() {
    Duration currentDuration = (_animationController.duration ?? _maxDuration) * _animationController.value;
    int inMilliseconds = currentDuration.inMilliseconds;

    String res = '';
    int tmp = (inMilliseconds ~/ 4000) * 4000;
    var value = inMilliseconds - tmp;
    // print(value);

    if (0 == value) {
      res = '4';
    } else if (0 <= value && value <= 1000) {
      res = '1';
    } else if (1000 < value && value <= 2000) {
      res = '2';
    } else if (2000 < value && value <= 3000) {
      res = '3';
    } else if (3000 < value && value <= 4000) {
      res = '4';
    }

    return res;
  }

  String _statusString() {
    Duration currentDuration = (_animationController.duration ?? _maxDuration) * _animationController.value;

    // Easiest way too ez
    int inMilliseconds = currentDuration.inMilliseconds;
    String res = '';

    if ((0 <= inMilliseconds && inMilliseconds <= 4000) ||
        (12000 < inMilliseconds && inMilliseconds <= 16000) ||
        (24000 < inMilliseconds && inMilliseconds <= 28000) ||
        (36000 < inMilliseconds && inMilliseconds <= 40000)) {
      res = LocaleKeys.breatheExhale;
    } else if ((4000 < inMilliseconds && inMilliseconds <= 8000) ||
        (16000 < inMilliseconds && inMilliseconds <= 20000) ||
        (28000 < inMilliseconds && inMilliseconds <= 32000) ||
        (40000 < inMilliseconds && inMilliseconds <= 44000)) {
      res = LocaleKeys.breatheHold;
    } else if ((8000 < inMilliseconds && inMilliseconds <= 12000) ||
        (20000 < inMilliseconds && inMilliseconds <= 24000) ||
        (32000 < inMilliseconds && inMilliseconds <= 36000) ||
        (44000 < inMilliseconds && inMilliseconds < 48000)) {
      res = LocaleKeys.breatheTake;
    } else if (inMilliseconds == 48000) {
      res = LocaleKeys.breatheTake;
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
