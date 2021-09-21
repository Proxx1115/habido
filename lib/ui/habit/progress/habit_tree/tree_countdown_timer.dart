import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/buttons.dart';

class TreeCountdownTimer extends StatefulWidget {
  final Duration duration;
  final Color? primaryColor;
  final bool visibleAddButton;
  final VoidCallback? callBack;

  const TreeCountdownTimer({
    Key? key,
    required this.duration,
    this.primaryColor,
    this.visibleAddButton = true,
    this.callBack,
  }) : super(key: key);

  @override
  _TreeCountdownTimerState createState() => _TreeCountdownTimerState();
}

class _TreeCountdownTimerState extends State<TreeCountdownTimer> with TickerProviderStateMixin {
  // Animation
  late AnimationController _animationController;
  late Duration _duration;
  late Color _primaryColor;

  @override
  void initState() {
    super.initState();
    // UI
    _primaryColor = widget.primaryColor ?? customColors.primary;

    // Animation
    _duration = widget.duration;
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
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
            /// Add button
            if (widget.visibleAddButton)
              ButtonStadium(
                asset: Assets.add_circle,
                iconColor: _primaryColor,
                onPressed: _onPressedAdd,
                margin: EdgeInsets.only(right: 15.0),
              ),

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
    return Container(
      height: 265.0,
      width: 265.0,
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
      decoration: BoxDecoration(shape: BoxShape.circle, color: customColors.secondaryBackground),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, Widget? child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// Tree
              _treeWidget(),

              SizedBox(height: 15.0),

              /// Time
              Text(
                _timeString(),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _treeWidget() {
    Duration currentDuration = (_animationController.duration ?? _duration) * _animationController.value;

    if (currentDuration.inSeconds > (_duration.inSeconds * 0.66)) {
      return MoveInAnimation(
        isAxisHorizontal: false,
        child: Container(
          padding: EdgeInsets.only(top: 50.0),
          child: SvgPicture.asset(Assets.tree1),
        ),
      );
    } else if (currentDuration.inSeconds > (_duration.inSeconds * 0.33)) {
      return MoveInAnimation(
        isAxisHorizontal: false,
        child: Container(
          padding: EdgeInsets.only(top: 40.0),
          child: SvgPicture.asset(Assets.tree2),
        ),
      );
    } else {
      return MoveInAnimation(
        isAxisHorizontal: false,
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: SvgPicture.asset(Assets.tree3),
        ),
      );
    }
  }

  String _timeString() {
    Duration currentDuration = (_animationController.duration ?? _duration) * _animationController.value;
    String res = '${currentDuration.inMinutes.floor().toString().padLeft(2, '0')}:' +
        '${(currentDuration.inSeconds % 60).floor().toString().padLeft(2, '0')}';

    return res;
  }

  _onPressedAdd() {
    setState(() {
      // Temp status
      bool wasAnimating = _animationController.isAnimating;

      // Stop animation
      _animationController.stop();

      // Current duration
      Duration currentDuration = (_animationController.duration ?? _duration) * _animationController.value;

      // Additional duration
      var additionalDuration = Duration(seconds: 60);

      // New duration
      Duration newDuration = currentDuration + additionalDuration;
      if (newDuration > _duration) {
        // Calculation
        // 1	                  20 + 1
        // k = 20.5 / 21        19.5 + 1

        // Replace current duration
        _duration += additionalDuration;
        _animationController.duration = _duration;
      } else {
        // Calculation
        // 1	                  20
        // k = 19.5 / 20		    18.5 + 1
      }

      // Set animation value
      _animationController.value = newDuration.inSeconds / _duration.inSeconds;

      // Resume animation
      if (wasAnimating) {
        _animationController.reverse(
          from: _animationController.value == 0.0 ? 1.0 : _animationController.value,
        );
      }
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
      _duration = widget.duration;
      _animationController.duration = _duration;
      _animationController.value = 1.0;
    });
  }
}
