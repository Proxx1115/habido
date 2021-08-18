import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';
import 'containers.dart';

enum CustomButtonStyle {
  Primary,
  Secondary, // Зүүн дээд өнцөг нь шовх
  Mini,
}

// ignore: non_constant_identifier_names
Widget CustomButton({
  CustomButtonStyle? style = CustomButtonStyle.Primary,
  VoidCallback? onPressed,
  BorderRadius? borderRadius,
  EdgeInsets? margin = EdgeInsets.zero,
  Alignment? alignment,
  double? width,
  Color? backgroundColor,
  Color? disabledBackgroundColor,
  String? text,
  String? asset,
  Color? textColor, // text, asset color
  Color? disabledTextColor,
}) {
  // Width, alignment
  switch (style) {
    case CustomButtonStyle.Secondary:
      width = width ?? 155.0;
      alignment = alignment ?? Alignment.centerRight;
      borderRadius = borderRadius ??
          BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
          );
      break;

    case CustomButtonStyle.Mini:
      width = width ?? 135.0;
      alignment = alignment ?? Alignment.center;
      break;

    case CustomButtonStyle.Primary:
    default:
      width = width ?? double.infinity;
      alignment = alignment ?? Alignment.center;
  }

  // Background color
  backgroundColor = backgroundColor ?? customColors.primaryButtonBackground;
  disabledBackgroundColor = disabledBackgroundColor ?? customColors.primaryButtonDisabledBackground;

  // Text, asset color
  textColor = textColor ?? customColors.primaryButtonText;
  disabledTextColor = disabledTextColor ?? customColors.primaryButtonDisabledText;

  // Text or Asset
  Widget _child = Container();
  if (text != null) {
    _child = Text(text);
  } else if (asset != null) {
    _child = SvgPicture.asset(asset, color: onPressed != null ? textColor : disabledTextColor);
  }

  return Align(
    alignment: alignment,
    child: Container(
      margin: margin,
      width: width,
      height: SizeHelper.boxHeight,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: onPressed != null ? backgroundColor : disabledBackgroundColor,
          primary: onPressed != null ? textColor : disabledTextColor,
          textStyle: TextStyle(fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10.0),
            side: BorderSide.none,
          ),
        ),
        child: _child,
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
// Widget CustomButton({
//   required String? text,
//   double? width,
//   double? height,
//   EdgeInsets? margin,
//   MainAxisAlignment? alignment,
//   Image? image,
//   Icon? icon,
//   VoidCallback? onPressed,
//   Color? color,
//   Color? disabledColor,
//   Color? splashColor,
//   Color? highlightColor,
//   Color? textColor,
//   Color? disabledTextColor,
//   double fontSize = 15.0,
//   FontWeight fontWeight = FontWeight.w500,
//   double? borderRadius,
//   double? elevation = SizeHelper.borderRadius,
//   bool isUppercase = false,
//   bool isStroked = false,
// }) {
//   return Container(
//     width: width ?? double.infinity,
//     height: height ?? SizeHelper.boxHeight,
//     margin: margin ?? EdgeInsets.zero,
//     child: TextButton(
//       // elevation: elevation ?? 0.0,
//       // style: ButtonStyle(
//         // backgroundColor: color ?? (onPressed != null ? customColors.primaryButtonBackground : customColors.secondaryButtonBackground),
//       // ),
//
//       // disabledColor: disabledColor ?? customColors.secondaryButtonBackground,
//       // splashColor: Color(0xFF24ABF8).withOpacity(0.1),
//       // highlightColor: Color(0xFF24ABF8).withOpacity(0.1),
//       // splashColor: Colors.red,
//       // highlightColor: Colors.transparent,
//       // padding: EdgeInsets.all(0),
//       onPressed: onPressed,
//       // shape: RoundedRectangleBorder(
//       //   borderRadius: BorderRadius.circular(borderRadius ?? SizeHelper.borderRadius),
//       // ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
//           border: isStroked ? Border.all(color: customColors.primary) : null,
//         ),
//         child: Row(
//           mainAxisAlignment: alignment ?? MainAxisAlignment.center,
//           children: <Widget>[
//             /// Asset Image
//             image ?? Container(),
//             image != null ? SizedBox(width: 5.0) : Container(),
//
//             /// Icon
//             icon ?? Container(),
//             icon != null ? SizedBox(width: 5.0) : Container(),
//
//             /// Text
//             text != null
//                 ? Expanded(
//                     child: CustomText(
//                       isUppercase ? text.toUpperCase() : text,
//                       color: onPressed != null
//                           ? (textColor ?? customColors.primaryButtonText)
//                           : (disabledTextColor ?? customColors.secondaryButtonText),
//                       fontSize: fontSize,
//                       fontWeight: fontWeight,
//                       overflow: TextOverflow.fade,
//                       alignment: Alignment.center,
//                       maxLines: 1,
//                     ),
//                   )
//                 : Container(),
//
//             image != null ? SizedBox(width: 10.0) : Container(),
//             icon != null ? SizedBox(width: 10.0) : Container(),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Icon-той, дөрвөлжин
class ButtonStadium extends StatelessWidget {
  final String asset;
  final VoidCallback onPressed;
  final EdgeInsets margin;
  final double size;
  final double borderRadius;
  final bool visibleBorder;
  final Color? backgroundColor;
  final Color? iconColor;

  const ButtonStadium({
    Key? key,
    required this.asset,
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.size = 40.0,
    this.borderRadius: 10.0,
    this.visibleBorder = false,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: visibleBorder ? Border.all(width: SizeHelper.borderWidth, color: customColors.border) : null,
            color: backgroundColor ?? customColors.secondaryBackground,
          ),
          child: SvgPicture.asset(asset, fit: BoxFit.scaleDown, color: iconColor ?? customColors.iconGrey),
        ),
        onTap: () {
          onPressed();
        },
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  const ButtonText({
    Key? key,
    required this.text,
    required this.onPressed,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.fontSize = SizeHelper.fontSizeNormal,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final FontWeight fontWeight;
  final Color? color;
  final double fontSize;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: CustomText(
          text,
          padding: padding,
          color: color ?? customColors.primaryText,
          fontWeight: fontWeight,
          fontSize: fontSize,
          alignment: alignment,
          maxLines: 10,
        ),
      ),
    );
  }
}

// Текст нь 2 хэсгээс бүрдсэн
class ButtonText2 extends StatelessWidget {
  const ButtonText2({
    Key? key,
    required this.text1,
    required this.text2,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.fontWeight1 = FontWeight.normal,
    this.fontWeight2 = FontWeight.w500,
    this.textColor,
    this.fontSize = 13.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.alignment = Alignment.center,
  }) : super(key: key);

  final String text1;
  final String text2;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final FontWeight fontWeight1;
  final FontWeight fontWeight2;
  final Color? textColor;
  final double fontSize;
  final MainAxisAlignment mainAxisAlignment;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
          padding: padding,
          color: backgroundColor ?? Colors.transparent,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              /// Text1
              CustomText(
                text1,
                color: textColor ?? customColors.primaryText,
                fontWeight: fontWeight1,
                fontSize: fontSize,
                alignment: alignment,
              ),

              MarginHorizontal(width: 5.0),

              /// Text2
              CustomText(
                text2,
                color: textColor ?? customColors.primaryText,
                fontWeight: fontWeight2,
                fontSize: fontSize,
                alignment: alignment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class BtnIconBordered extends StatelessWidget {
//   final String asset;
//   final VoidCallback onPressed;
//   final double size;
//   final double iconSize;
//   final double borderRadius;
//   final EdgeInsets margin;
//
//   const BtnIconBordered({
//     Key? key,
//     required this.asset,
//     required this.onPressed,
//     this.size = SizeHelper.boxHeight,
//     this.iconSize = SizeHelper.iconSize,
//     this.borderRadius: SizeHelper.borderRadius,
//     this.margin = EdgeInsets.zero,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: margin,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
//         child: Container(
//           height: size,
//           width: size,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(borderRadius),
//             border: Border.all(width: SizeHelper.borderWidth, color: customColors.border),
//           ),
//           child: SvgPicture.asset(asset, fit: BoxFit.scaleDown),
//         ),
//         onTap: () {
//           onPressed();
//         },
//       ),
//     );
//   }
// }

// class BtnWhite extends StatelessWidget {
//   final String text;
//   final Function() onPressed;
//
//   const BtnWhite({
//     this.text,
//     this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         if (onPressed != null) onPressed();
//       },
//       splashColor: Colors.transparent,
//       highlightColor: Colors.transparent,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 8),
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.white.withOpacity(0.56),
//           border: Border.all(color: Colors.white),
//         ),
//         child:
//
//             /// Body
//             text != null
//                 ? Txt(
//                     text.toUpperCase(),
//                     fontSize: 16.0,
//                     color: customColors.primary,
//                     fontWeight: FontWeight.bold,
//                     alignment: Alignment.center,
//                   )
//                 : Container(),
//       ),
//     );
//   }
// }

/// onClick event агуулсан текст
// class btnText extends StatelessWidget {
//   btnText({
//     @required this.onPressed,
//     @required this.text,
//     this.textColor,
//     this.fontSize,
//     this.padding,
//     this.width,
//     this.enabledRippleEffect = true,
//     this.fontWeight,
//     this.alignment,
//     this.style,
//   });
//
//   final Function onPressed;
//   final String text;
//   final Color textColor;
//   final double fontSize;
//   final double width;
//   final EdgeInsets padding;
//   final bool enabledRippleEffect;
//   final FontWeight fontWeight;
//   final lblStyle style;
//   final Alignment alignment;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       highlightColor: enabledRippleEffect ? null : Colors.transparent,
//       splashColor: enabledRippleEffect ? null : Colors.transparent,
//       child: Container(
//         width: width ?? double.infinity,
//         alignment: alignment ?? Alignment.center,
//         padding: padding ?? EdgeInsets.all(0.0),
//         child: Txt(
//           text,
//           color: textColor,
//           fontSize: fontSize,
//           fontWeight: fontWeight,
//           alignment: alignment,
//           style: style,
//         ),
//       ),
//     );
//   }
// }

// ignore: camel_case_types
// class btnIcon extends StatelessWidget {
//   const btnIcon({
//     Key key,
//     this.icon,
//     this.color,
//     this.onPressed,
//     this.padding,
//   }) : super(key: key);
//
//   final Icon icon;
//   final Color color;
//   final Function onPressed;
//   final EdgeInsets padding;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(padding: padding ?? EdgeInsets.zero, child: icon),
//     );
//   }
// }

// ignore: camel_case_types
// class BtnRadius extends StatefulWidget {
//   final Function() onPressed;
//   final double size;
//   final double padding;
//   final Color iconColor;
//   final String assetName;
//   final BorderRadius borderRadius;
//
//   const BtnRadius({
//     this.onPressed,
//     this.size = 50,
//     this.padding = 6,
//     this.iconColor,
//     this.assetName,
//     this.borderRadius,
//   });
//
//   @override
//   _BtnRadiusState createState() => _BtnRadiusState();
// }
//
// class _BtnRadiusState extends State<BtnRadius> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.all(Radius.circular(100.0)),
//       onTap: () {
//         if (widget.onPressed != null) widget.onPressed();
//       },
//       child: Container(
//           height: widget.size,
//           width: widget.size,
//           padding: EdgeInsets.all(widget.padding),
//           decoration: BoxDecoration(
//               borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
//               color: Colors.white,
//               border: Border.all(color: customColors.border)),
//           child: Image.asset(
//             widget.assetName,
//             color: widget.iconColor != null ? widget.iconColor : customColors.primary,
//           )),
//     );
//   }
// }

/// Combo box шиг загвартай button
// Widget btnCombo(
//   BuildContext context, {
//   Function onPressed,
//   String label,
//   String text,
//   EdgeInsets margin = EdgeInsets.zero,
//   EdgeInsets padding = EdgeInsets.zero,
//   double width,
// }) {
//   return InkWell(
//     onTap: () {
//       if (onPressed != null) onPressed();
//     },
//     child: Container(
//       margin: margin,
//       padding: padding,
//       width: width ?? double.infinity,
//       child: Column(
//         children: <Widget>[
//           /// Label
//           if (Func.isNotEmpty(label))
//             Container(
//               margin: EdgeInsets.only(bottom: 10.0),
//               child: Txt(label, alignment: Alignment.centerLeft, fontWeight: FontWeight.w500),
//             ),
//
//           /// Combo
//           Container(
//             height: SizeHelper.textBoxHeight,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(SizeHelper.comboRadius),
//               ),
//               border: Border.all(color: customColors.border),
// //                color: widget.bgColor ?? appColor.bgGrey,//todo
// //                color: widget.bgColor ?? appColor.bgGrey,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 /// Text
//                 Expanded(
//                   child: Txt(Func.isNotEmpty(text) ? text : CustomText.choose,
//                       margin: EdgeInsets.only(left: 12.0), color: customColors.lblSecondary, fontWeight: FontWeight.w500),
//                 ),
//
//                 /// Suffix icon
//                 Align(
//                   child: Container(
//                     padding: EdgeInsets.only(right: 5.0),
//                     child: Icon(Icons.arrow_drop_down_outlined, size: SizeHelper.iconSize, color: customColors.iconSecondary),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// ignore: non_constant_identifier_names
// Widget GradientButton({
//   @required String text,
//   @required Function onPressed,
//   Alignment alignment = Alignment.center,
//   EdgeInsets margin = EdgeInsets.zero,
//   Widget icon,
//   double height,
// }) {
//   return InkWell(
//     onTap: () {
//       if (onPressed != null) onPressed();
//     },
//     child: Container(
//       margin: margin,
//       height: height ?? SizeHelper.buttonHeightSmall,
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       width: double.infinity,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(SizeHelper.buttonRadius),
//           gradient: LinearGradient(
//             colors: [customColors.gradientBegin, customColors.gradientEnd],
//             stops: [0, 1],
//             begin: Alignment(-0.26, 0.97),
//             end: Alignment(0.66, -0.97),
//             // angle: 15,
//             // scale: undefined,
//           ),
//           boxShadow: [BoxShadow(color: customColors.shadow, offset: Offset(0, 4), blurRadius: 5, spreadRadius: 0)]),
//       child: Row(
//         children: [
//           /// Text
//           Expanded(
//             child: Txt(
//               text,
//               fontSize: SizeHelper.fontSizeMedium,
//               color: customColors.btnEnabledText,
//               alignment: alignment,
//               textAlign: TextAlign.justify,
//               maxLines: 3,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//
//           /// Icon
//           icon ?? Container(),
//         ],
//       ),
//     ),
//   );
// }

// class TimerBtn extends StatefulWidget {
//   int totalSeconds;
//   final Function onPressedBtnResend;
//   final Function(int) onTimeChanged;
//
//   TimerBtn(this.totalSeconds, {this.onPressedBtnResend, this.onTimeChanged});
//
//   @override
//   _TimerBtnState createState() => _TimerBtnState();
// }
//
// class _TimerBtnState extends State<TimerBtn> {
//   Timer _timer;
//
//   @override
//   Widget build(BuildContext context) {
//     if (_timer == null || (!_timer.isActive && widget.totalSeconds > 0)) _startTimer();
//
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 70),
//             child: Btn(
//               margin: EdgeInsets.fromLTRB(SizeHelper.margin, 10.0, SizeHelper.margin, SizeHelper.marginBottom),
//               text: CustomText.resendCode,
//               onPressed: widget.totalSeconds == 0
//                   ? () {
//                       if (widget.onPressedBtnResend != null) {
//                         widget.onPressedBtnResend();
//                       }
//                     }
//                   : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _startTimer() {
//     _cancelTimer();
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       setState(() {
//         widget.totalSeconds--;
//         if (widget.onTimeChanged != null) widget.onTimeChanged(widget.totalSeconds);
//         if (widget.totalSeconds < 1) {
//           _cancelTimer();
//         }
//       });
//     });
//   }
//
//   _cancelTimer() {
//     if (_timer != null && _timer.isActive) _timer.cancel();
//   }
//
//   @override
//   void dispose() {
//     _cancelTimer();
//     super.dispose();
//   }
// }

// Container-ийн доор text-тэй
// Widget IconBtn({
//   @required String asset,
//   String bottomText,
//   EdgeInsets padding = const EdgeInsets.all(8),
//   EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//   Function onTap,
// }) {
//   return NoSplashContainer(
//     child: Container(
//       margin: margin,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           /// Box
//           InkWell(
//             onTap: () {
//               if (onTap != null) onTap();
//             },
//             child: Container(
//               height: 56,
//               width: 56,
//               padding: padding,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: customColors.border),
//                   color: customColors.containerBackground),
//               child: Image.asset(asset, height: 36, fit: BoxFit.contain),
//             ),
//           ),
//
//           SizedBox(height: 10.0),
//
//           /// Bottom text
//           Txt(Func.toStr(bottomText), fontSize: 12, color: customColors.lbl, alignment: Alignment.center),
//         ],
//       ),
//     ),
//   );
// }

// Container дотроо тексттэй
// Widget IconBtn2({
//   @required String asset,
//   String text,
//   EdgeInsets padding = const EdgeInsets.all(10),
//   Function onTap,
//   double size,
//   bool isSelected = false,
// }) {
//   return NoSplashContainer(
//     child: InkWell(
//       onTap: () {
//         if (onTap != null) onTap();
//       },
//       child: Container(
//         height: size,
//         width: size,
//         padding: padding,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: isSelected ? customColors.primary : customColors.border),
//           color: customColors.containerBackground,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             /// Icon
//             Expanded(
//               flex: 9,
//               child: Image.asset(
//                 asset,
//                 height: size / 2.5,
//                 color: isSelected ? customColors.primary : customColors.iconInactive,
//               ),
//             ),
//
//             SizedBox(height: 10.0),
//
//             /// Text
//             Expanded(
//               flex: 8,
//               child: Txt(
//                 Func.toStr(text),
//                 fontSize: 13,
//                 color: isSelected ? customColors.lbl : customColors.iconInactive,
//                 // color: customColors.lbl,
//                 alignment: Alignment.center,
//                 maxLines: 2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

/// Asset or Icon
// ignore: non_constant_identifier_names
// Widget CircleButton({String assetName, Function onPressed, IconData icon}) {
//   return InkWell(
//     onTap: onPressed,
//     child: Container(
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.1),
//             spreadRadius: 5,
//             blurRadius: 7,
//             offset: Offset(0, 3), // changes position of shadow
//           ),
//         ],
//       ),
//       child: Func.isNotEmpty(assetName)
//           ? Image.asset(
//               assetName ?? '',
//               // color: Colors.white,
//               height: 28,
//               width: 28,
//             )
//           : Icon(
//               icon,
//               color: Colors.white,
//               size: 28,
//             ),
//     ),
//   );
// }
