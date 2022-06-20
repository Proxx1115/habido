import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class TagItemWidget extends StatelessWidget {
  final String text;
  final EdgeInsets margin;
  TagItemWidget({
    Key? key,
    required this.text,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: customColors.primaryButtonDisabledContent,
      ),
      child: CustomText(
        text,
        fontSize: 8.0,
        fontWeight: FontWeight.w500,
        color: customColors.whiteText,
      ),
    );
  }
}
