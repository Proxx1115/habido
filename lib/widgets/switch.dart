import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final EdgeInsets? margin;

  final String? leadingAsset;
  final Color? leadingAssetColor;

  final Color? activeColor; //: Colors.transparent,
  final Color? inactiveThumbColor; //: Colors.transparent,
  final Color? activeTrackColor; //: Colors.grey,
  final Color? inactiveTrackColor; //: Colors.grey,

  final String? activeText;
  final String? inactiveText;
  final String? activeAsset;
  final String? inactiveAsset;

  const CustomSwitch({
    Key? key,
    this.value = false,
    required this.onChanged,
    this.enabled = true,
    this.margin,
    this.leadingAsset,
    this.leadingAssetColor,
    this.activeColor,
    this.inactiveThumbColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
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
    return Container(
      margin: widget.margin,
      height: SizeHelper.boxHeight,
      child: (widget.leadingAsset != null || text != null)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Icon
                if (widget.leadingAsset != null)
                  Container(
                    child: SvgPicture.asset(
                      widget.leadingAsset!,
                      color: widget.leadingAssetColor ?? customColors.iconGrey,
                    ),
                  ),

                /// Text
                if (text != null)
                  Expanded(
                    child: CustomText(
                      text,
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                /// Switch
                _switch(),
              ],
            )
          : _switch(),
    );
  }

  Widget _switch() {
    return Switch(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: _value,
      activeColor: widget.activeColor ?? customColors.primary,
      inactiveThumbColor: widget.inactiveThumbColor,
      activeTrackColor: widget.activeTrackColor,
      inactiveTrackColor: widget.inactiveTrackColor,
      activeThumbImage: widget.activeAsset != null ? AssetImage(widget.activeAsset!) : null,
      inactiveThumbImage: widget.inactiveAsset != null ? AssetImage(widget.inactiveAsset!) : null,
      onChanged: widget.enabled
          ? (newValue) {
              setState(() {
                _value = newValue;
                _toggleText();
              });

              widget.onChanged(newValue);

              print('Switch value: $newValue');
            }
          : null,
    );
  }

  _toggleText() {
    if (_value && widget.activeText != null) {
      text = widget.activeText;
    } else if (!_value && widget.inactiveText != null) {
      text = widget.inactiveText;
    } else if (widget.activeText != null && widget.inactiveText == null) {
      text = widget.activeText;
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
