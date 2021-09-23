import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowcase extends StatelessWidget {
  final Widget child;
  final GlobalKey showcaseKey;
  final String description;

  const CustomShowcase({
    Key? key,
    required this.child,
    required this.showcaseKey,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcaseKey,
      description: description,
      showcaseBackgroundColor: customColors.primary,
      textColor: customColors.whiteText,
      overlayColor: Colors.white,
      overlayOpacity: 0.95,
      child: child,
    );
  }
}
