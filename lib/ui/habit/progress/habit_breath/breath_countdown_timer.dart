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
    int s = currentDuration.inMilliseconds;

    double minValue = 0.8;
    double maxValue = 1;
    late double value;

    if (0 == s) {
      value = minValue;
    } else if ((0 <= s && s < k) ||
        (k * 3 <= s && s < k * 4) ||
        (k * 6 <= s && s < k * 7) ||
        (k * 9 <= s && s < k * 10)) {
      // Exhale a breath
      int tmp = (s ~/ k) * k;
      var tmpMilliseconds = Func.toDouble(s - tmp);
      value = tmpMilliseconds / k;
      value = minValue + 0.2 * value;
    } else if ((k <= s && s < k * 2) ||
        (k * 4 <= s && s < k * 5) ||
        (k * 7 <= s && s < k * 8) ||
        (k * 10 <= s && s < k * 11)) {
      // Hold a breath
      value = maxValue;
    } else if ((k * 2 <= s && s < k * 3) ||
        (k * 5 <= s && s < k * 6) ||
        (k * 8 <= s && s < k * 9) ||
        (k * 11 <= s && s < k * 12)) {
      // Take a breath
      int tmp = (s ~/ k) * k;
      var tmpMilliseconds = Func.toDouble(s - tmp);
      value = tmpMilliseconds / k;
      value = 1 - value;
      value = minValue + 0.2 * value;
    } else if (s == k * 12) {
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
    int s = currentDuration.inMilliseconds;

    int tmp = (s ~/ k) * k;
    var value = s - tmp;
    if (0 == value) {
      return '4';
    } else {
      for (int i = 0; i < 4; i++) {
        if (i * 1000 < value && value <= (i + 1) * 1000) return (i + 1).toString();
      }
    }

    return '';
  }

  String _statusString() {
    String res = '';
    Duration currentDuration = (_animationController.duration ?? _maxDuration) * _animationController.value;
    int s = currentDuration.inMilliseconds;

    if ((0 <= s && s <= k) || (k * 3 < s && s <= k * 4) || (k * 6 < s && s <= k * 7) || (k * 9 < s && s <= k * 10)) {
      res = LocaleKeys.breatheExhale;
    } else if ((k < s && s <= k * 2) ||
        (k * 4 < s && s <= k * 5) ||
        (k * 7 < s && s <= k * 8) ||
        (k * 10 < s && s <= k * 11)) {
      res = LocaleKeys.breatheHold;
    } else if ((k * 2 < s && s <= k * 3) ||
        (k * 5 < s && s <= k * 6) ||
        (k * 8 < s && s <= k * 9) ||
        (k * 11 < s && s < k * 12)) {
      res = LocaleKeys.breatheTake;
    } else if (s == k * 12) {
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
      _callBack = false;
      print('callback: $_callBack');

      _animationController.reset();
      _animationController.duration = _maxDuration;
      _animationController.value = 1.0;
    });
  }
}
