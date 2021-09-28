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

  // Reset
  bool _callBack = true;

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
        if (status == AnimationStatus.reverse) {
          _callBack = true;
          print('callback: $_callBack');
        } else if (status == AnimationStatus.dismissed) {
          if (_callBack && widget.callBack != null) {
            widget.callBack!();
          }
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
    if ((0 <= inMilliseconds && inMilliseconds <= 4000) ||
        (12000 < inMilliseconds && inMilliseconds <= 16000) ||
        (24000 < inMilliseconds && inMilliseconds <= 28000) ||
        (36000 < inMilliseconds && inMilliseconds <= 40000)) {
      /// Exhale a breath
      int tmp = (inMilliseconds ~/ 4000) * 4000;
      var tmpMilliseconds = Func.toDouble(inMilliseconds - tmp);
      // print(value);
      value = tmpMilliseconds / 4000;

      // 0.2 - 1
      // x - 0.5
      value = minValue + 0.2 * value;
    } else if ((4000 < inMilliseconds && inMilliseconds <= 8000) ||
        (16000 < inMilliseconds && inMilliseconds <= 20000) ||
        (28000 < inMilliseconds && inMilliseconds <= 32000) ||
        (40000 < inMilliseconds && inMilliseconds <= 44000)) {
      /// Hold a breath
      value = maxValue;
    } else if ((8000 < inMilliseconds && inMilliseconds <= 12000) ||
        (20000 < inMilliseconds && inMilliseconds <= 24000) ||
        (32000 < inMilliseconds && inMilliseconds <= 36000) ||
        (44000 < inMilliseconds && inMilliseconds < 48000)) {
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

    var value = inMilliseconds - (inMilliseconds ~/ 4000) * 4000;
    if (0 == value) {
      return '4';
    } else {
      for (int i = 0; i < 4; i++) {
        if (i * 1000 < value && value <= (i + 1) * 1000) return i.toString();
      }
    }

    return '';
  }

  String _statusString() {
    Duration currentDuration = (_animationController.duration ?? _maxDuration) * _animationController.value;
    int inMilliseconds = currentDuration.inMilliseconds;

    var k = 4000;
    if ((0 <= inMilliseconds && inMilliseconds <= k * 1) ||
        (k * 3 < inMilliseconds && inMilliseconds <= k * 4) ||
        (k * 6 < inMilliseconds && inMilliseconds <= k * 7) ||
        (k * 9 < inMilliseconds && inMilliseconds <= k * 10)) {
      return LocaleKeys.breatheExhale;
    } else if ((k * 1 < inMilliseconds && inMilliseconds <= k * 2) ||
        (k * 4 < inMilliseconds && inMilliseconds <= k * 5) ||
        (k * 7 < inMilliseconds && inMilliseconds <= k * 8) ||
        (k * 10 < inMilliseconds && inMilliseconds <= k * 11)) {
      return LocaleKeys.breatheHold;
    } else if ((k * 2 < inMilliseconds && inMilliseconds <= k * 3) ||
        (k * 5 < inMilliseconds && inMilliseconds <= k * 6) ||
        (k * 8 < inMilliseconds && inMilliseconds <= k * 9) ||
        (k * 11 < inMilliseconds && inMilliseconds < k * 12)) {
      return LocaleKeys.breatheTake;
    } else if (inMilliseconds == k * 12) {
      return LocaleKeys.breatheTake;
    }

    return '';
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
      _callBack = false;
      print('callback: $_callBack');

      _animationController.reset();
      _animationController.duration = _maxDuration;
      _animationController.value = 1.0;
    });
  }
}
