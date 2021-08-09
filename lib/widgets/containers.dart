import 'package:flutter/material.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

// ignore: non_constant_identifier_names
// Widget HorizontalLine({
//   Color color,
//   EdgeInsets margin,
// }) {
//   return Column(
//     children: [
//       Container(
//         margin: margin ?? EdgeInsets.symmetric(vertical: SizeHelper.margin),
//         height: 1,
//         color: color ?? Colors.white,
//       ),
//     ],
//   );
// }

class MarginVertical extends StatelessWidget {
  final double height;

  const MarginVertical({Key? key, this.height = SizeHelper.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class MarginHorizontal extends StatelessWidget {
  final double width;

  const MarginHorizontal({Key? key, this.width = SizeHelper.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class NoSplashContainer extends StatelessWidget {
  NoSplashContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: child,
    );
  }
}

class StadiumContainer extends StatelessWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double? height;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Widget child;

  const StadiumContainer({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.height,
    this.onTap,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: InkWell(
        child: Container(
          height: height,
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor ?? customColors.secondaryBackground,
            borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
          ),
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}

// class RoundedBorderContainer extends StatelessWidget {
//   final Widget child;
//   final EdgeInsets margin;
//   final Function onTap;
//
//   const RoundedBorderContainer({Key key, this.margin, this.onTap, this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return NoSplashContainer(
//       child: InkWell(
//         child: Container(
//           padding: EdgeInsets.all(12.0),
//           margin: margin ?? EdgeInsets.only(right: 15.0),
//           decoration: BoxDecoration(border: Border.all(color: customColors.border, width: 3), borderRadius: BorderRadius.circular(16)),
//           child: child ?? Container(),
//         ),
//         onTap: () {
//           if (onTap != null) onTap();
//         },
//       ),
//     );
//   }
// }
//
// class BorderContainer extends StatelessWidget {
//   final Widget child;
//   final EdgeInsets padding;
//
//   const BorderContainer({
//     this.child,
//     this.padding = const EdgeInsets.all(15.0),
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: padding,
//       // margin: EdgeInsets.only(15.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: customColors.border, width: 1),
//         borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
//         color: customColors.containerBackground,
//       ),
//       child: child ?? Container(),
//     );
//   }
// }
//
// // ignore: non_constant_identifier_names
// Widget BorderedContainer({
//   Widget child,
//   EdgeInsets padding = const EdgeInsets.all(15.0),
//   EdgeInsets margin = EdgeInsets.zero,
//   Color borderColor,
//   Radius topLeft,
//   Radius topRight,
//   Radius bottomLeft,
//   Radius bottomRight,
//   bool fadeIn = false,
// }) {
//   Widget res = Container(
//     padding: padding,
//     margin: margin,
//     decoration: BoxDecoration(
//       border: Border.all(color: borderColor ?? customColors.border, width: 1),
//       borderRadius: BorderRadius.only(
//         topLeft: topLeft ?? Radius.circular(SizeHelper.borderRadius),
//         topRight: topRight ?? Radius.circular(SizeHelper.borderRadius),
//         bottomLeft: bottomLeft ?? Radius.circular(SizeHelper.borderRadius),
//         bottomRight: bottomRight ?? Radius.circular(SizeHelper.borderRadius),
//       ),
//       color: customColors.containerBackground,
//     ),
//     child: child ?? Container(),
//   );
//
//   return fadeIn ? FadeInSlow(child: res) : res;
// }
//
// // ignore: non_constant_identifier_names
// Widget BlueContainer({
//   Widget child,
//   EdgeInsets padding = const EdgeInsets.all(15.0),
//   EdgeInsets margin = EdgeInsets.zero,
// }) {
//   return Container(
//     padding: padding,
//     margin: margin,
//     decoration: BoxDecoration(
//       border: Border.all(color: customColors.border, width: 1),
//       borderRadius: BorderRadius.circular(16),
//       color: Color(0xFF24ABF8).withOpacity(0.25),
//     ),
//     child: child ?? Container(),
//   );
// }
//
// // ignore: non_constant_identifier_names
// Widget DropDownContainer({Widget child}) {
//   return AnimWidget(
//     child: child ?? Container(),
//     anim: Anims.anim3,
//     delayForward: 100,
//   );
// }
//
// class ExpandableContainer extends StatefulWidget {
//   final Widget header;
//   final Widget body;
//   final bool expand;
//
//   ExpandableContainer({this.header, this.expand = false, this.body});
//
//   @override
//   _ExpandableContainerState createState() => _ExpandableContainerState();
// }
//
// class _ExpandableContainerState extends State<ExpandableContainer> with SingleTickerProviderStateMixin {
//   AnimationController expandController;
//   Animation<double> animation;
//
//   @override
//   void initState() {
//     super.initState();
//     prepareAnimations();
//     _runExpandCheck();
//   }
//
//   ///Setting up the animation
//   void prepareAnimations() {
//     expandController = AnimationController(vsync: this, duration: AppHelper.expandAnimationDuration);
//     animation = CurvedAnimation(
//       parent: expandController,
//       curve: Curves.fastOutSlowIn,
//     );
//   }
//
//   void _runExpandCheck() {
//     if (widget.expand) {
//       expandController.forward();
//     } else {
//       expandController.reverse();
//     }
//   }
//
//   @override
//   void didUpdateWidget(ExpandableContainer oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _runExpandCheck();
//   }
//
//   @override
//   void dispose() {
//     expandController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         widget.header ?? Container(),
//         SizeTransition(axisAlignment: 1.0, sizeFactor: animation, child: widget.body),
//       ],
//     );
//   }
// }
