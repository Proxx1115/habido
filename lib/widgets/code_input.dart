import 'package:code_input/code_input.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

class CustomCodeInput extends StatelessWidget {
  final int length;
  final Function(String) onChanged;
  final Function(String) onFilled;
  final EdgeInsets margin;

  const CustomCodeInput({
    Key? key,
    this.length = 4,
    required this.onChanged,
    required this.onFilled,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: CodeInput(
        length: length,
        keyboardType: TextInputType.number,
        builder: CodeInputBuilders.containerized(
          totalSize: Size(45.0 + 15.0, SizeHelper.boxHeight),
          emptySize: Size(45.0, SizeHelper.boxHeight),
          filledSize: Size(45.0, SizeHelper.boxHeight),
          emptyDecoration: BoxDecoration(
            color: customColors.secondaryBackground,
            borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
          ),
          filledDecoration: BoxDecoration(
            color: customColors.secondaryBackground,
            borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
          ),
          emptyTextStyle: TextStyle(color: customColors.secondaryText, fontWeight: FontWeight.w500),
          filledTextStyle: TextStyle(color: customColors.primaryText, fontWeight: FontWeight.w500),
        ),
        onChanged: (value) => onChanged(value),
        onFilled: (value) => onFilled(value),
      ),
    );
  }
}
