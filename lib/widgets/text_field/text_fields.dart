import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';

enum CustomTextFieldStyle {
  primary, // White
  secondary, // Grey
}

class CustomTextField extends StatefulWidget {
  final CustomTextFieldStyle style;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readOnly;
  final EdgeInsets margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputFormatter? inputFormatter;
  final String? prefixAsset;
  final String? hintText;
  final double fontSize;
  final Color? textColor;
  final Widget? suffixWidget;
  final String suffixAsset;
  final Color? suffixColor;
  final bool visibleSuffix;
  final bool alwaysVisibleSuffix;
  final VoidCallback? onPressedSuffix;

  CustomTextField({
    Key? key,
    this.style = CustomTextFieldStyle.primary,
    required this.controller,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.borderRadius,
    this.prefixAsset,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.inputFormatter,
    this.fontSize = 15.0,
    this.textColor,
    this.maxLines,
    this.maxLength,
    this.suffixWidget,
    this.suffixAsset = Assets.edit,
    this.suffixColor,
    this.visibleSuffix = true,
    this.alwaysVisibleSuffix = true,
    this.onPressedSuffix,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  late bool _obscureText;
  late String _suffixAsset;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _suffixAsset = _obscureText ? Assets.obscure_hidden : widget.suffixAsset;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines ?? 1,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          border: _border,
          focusedBorder: _border,
          enabledBorder: _border,
          disabledBorder: _border,
          filled: true,
          fillColor: _backgroundColor,
          prefixIcon: _prefixIcon(),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: widget.fontSize, color: customColors.greyText),
          suffixIcon: _suffixIcon(),
          counterText: '',
          contentPadding: SizeHelper.boxPadding,
        ),
        style: TextStyle(color: _textColor, fontSize: widget.fontSize, fontWeight: _fontWeight),
        keyboardType: widget.keyboardType,
        obscureText: _obscureText,
        inputFormatters: widget.inputFormatter != null ? [widget.inputFormatter!] : null,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        maxLength: widget.maxLength,
      ),
    );
  }

  InputBorder get _border => OutlineInputBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(SizeHelper.borderRadius),
        borderSide: (widget.style == CustomTextFieldStyle.primary)
            ? BorderSide.none // BorderSide(color: customColors.border, width: SizeHelper.borderWidth)
            : BorderSide.none,
      );

  Color get _backgroundColor =>
      widget.backgroundColor ??
      ((widget.style == CustomTextFieldStyle.primary)
          ? customColors.primaryTextFieldBackground
          : customColors.secondaryTextFieldBackground);

  Widget? _prefixIcon() {
    return (widget.prefixAsset != null) ? SvgPicture.asset(widget.prefixAsset!, fit: BoxFit.scaleDown) : null;
  }

  Color get _textColor => widget.textColor ?? (_focusNode.hasFocus ? customColors.primary : customColors.primaryText);

  FontWeight get _fontWeight => _focusNode.hasFocus ? FontWeight.w500 : FontWeight.normal;

  Widget? _suffixIcon() {
    if (widget.visibleSuffix && (widget.alwaysVisibleSuffix || _focusNode.hasFocus)) {
      // Show suffix icon
      return NoSplashContainer(
        child: IconButton(
          icon: widget.suffixWidget ??
              SvgPicture.asset(
                _suffixAsset,
                fit: BoxFit.scaleDown,
                color: widget.suffixColor ?? customColors.iconGrey,
              ),
          onPressed: () {
            if (widget.onPressedSuffix != null) {
              widget.onPressedSuffix!();
            } else if (widget.obscureText) {
              setState(() {
                _obscureText = !_obscureText;
                _suffixAsset = _obscureText ? Assets.obscure_hidden : Assets.obscure;
              });
            }
          },
        ),
      );
    } else {
      return null;
    }
  }
}

class ClearIcon extends StatelessWidget {
  const ClearIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: customColors.iconGrey),
      child: SvgPicture.asset(
        Assets.clear,
        fit: BoxFit.scaleDown,
        color: customColors.secondaryTextFieldBackground,
      ),
    );
  }
}
