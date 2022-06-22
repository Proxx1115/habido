import 'package:flutter/material.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class InfoContainerV2 extends StatelessWidget {
  final String title;
  final Alignment? titleAlignment;
  final Color? textColor;
  final String body;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget? child;

  const InfoContainerV2({
    Key? key,
    required this.title,
    this.titleAlignment,
    required this.body,
    this.margin,
    this.padding,
    this.textColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      margin: margin,
      padding: padding ?? SizeHelper.boxPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          CustomText(
            title,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            maxLines: 2,
            alignment: titleAlignment,
            color: textColor,
          ),

          SizedBox(height: 10),

          /// Body
          CustomText(
            body,
            maxLines: 200,
            fontWeight: FontWeight.w300,
            textAlign: TextAlign.justify,
            fontSize: 15,
          ),

          /// Divider
          if (child != null) HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

          /// Footer
          if (child != null) child!
        ],
      ),
    );
  }
}
