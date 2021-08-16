import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/widgets/text.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? leadingAsset;
  final String? activeText;
  final String? inactiveText;
  final String? activeAsset;
  final String? inactiveAsset;

  const CustomSwitch({
    Key? key,
    this.value = false,
    required this.onChanged,
    this.leadingAsset,
    this.activeText,
    this.inactiveText,
    this.activeAsset,
    this.inactiveAsset,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _value = false;
  String? text;

  @override
  void initState() {
    // Value
    _value = widget.value;

    // Text
    _toggleText();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.leadingAsset != null || widget.activeText != null) {
      return Row(
        children: [
          /// Icon
          if (widget.leadingAsset != null)
            Container(
              margin: EdgeInsets.only(left: 18.0),
              child: SvgPicture.asset(widget.leadingAsset!),
            ),

          /// Text
          if (text != null)
            Expanded(
              child: CustomText(text, margin: EdgeInsets.symmetric(horizontal: 18.0)),
            ),

          /// Switch
          _switch(),
        ],
      );
    } else {
      return _switch();
    }
  }

  Widget _switch() {
    return Theme(
      data: Theme.of(context).copyWith(
        // primaryColor: Colors.transparent,
        // unselectedWidgetColor: widget.unselectedWidgetColor ?? customColors.primary,
        // splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
      ),
      child: Switch(
        value: _value,
        onChanged: (newValue) {
          setState(() {
            _value = newValue;
            _toggleText();
          });

          widget.onChanged(newValue);

          print('Switch value: $newValue');
        },
      ),
    );
  }

  _toggleText() {
    if (_value && widget.activeText != null) {
      text = widget.activeText;
    } else if (!_value && widget.inactiveText != null) {
      text = widget.inactiveText;
    }
  }
}

// Widget CustomSwitch(
//   BuildContext context, {
//   bool value = false,
// }) {
//   return Switch(
//     value: value,
//     onChanged: (newValue) {
//       //
//     },
//   );
// }

// class CustomSwitch extends StatefulWidget {
//   const CustomSwitch({Key? key}) : super(key: key);
//
//   @override
//   _CustomSwitchState createState() => _CustomSwitchState();
// }
//
// class _CustomSwitchState extends State<CustomSwitch> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
