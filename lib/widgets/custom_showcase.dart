import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowcase extends StatelessWidget {
  final Widget child;
  final GlobalKey showcaseKey;
  final String description;
  final ShapeBorder? shapeBorder;
  final EdgeInsets overlayPadding;
  final double overlayOpacity;
  final Color? overlayColor;

  const CustomShowcase({
    Key? key,
    required this.child,
    required this.showcaseKey,
    required this.description,
    this.shapeBorder,
    this.overlayPadding = EdgeInsets.zero,
    this.overlayOpacity = 0.95,
    this.overlayColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcaseKey,
      description: description,
      showcaseBackgroundColor: customColors.primary,
      textColor: customColors.whiteText,
      overlayColor: overlayColor ?? customColors.whiteBackground,
      overlayOpacity: overlayOpacity,
      shapeBorder: shapeBorder,
      contentPadding: EdgeInsets.all(10.0),
      overlayPadding: overlayPadding,
      child: child,
    );
  }
}
