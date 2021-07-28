import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import '../txt.dart';
import 'text_input_formatter.dart';

// ignore: non_constant_identifier_names
Widget Txtbox({
  required BuildContext context,
  required TextEditingController controller,
  FocusNode? focusNode,
  String? hintText,
  String? prefixText,
  IconData? iconData,
  bool obscureText = false,
  EdgeInsets margin = EdgeInsets.zero,
  EdgeInsets padding = const EdgeInsets.only(left: 15.0),
  int? maxLength,
  TextInputType? textInputType,
  String? labelText,
  Color? labelColor,
  FontWeight? labelFontWeight,
  Color? textColor,
  Widget? suffixIcon,
  Color? backgroundColor,
  double borderRadius = 8.0,
  Widget? prefixIcon,
  bool enabled = true,
  bool isValidated = true,
}) {
  return new Container(
    margin: margin,
    child: Column(
      children: <Widget>[
        /// Label
        labelText != null
            ? Row(
                children: <Widget>[
                  /// Label
                  Txt(labelText,
                      fontWeight: labelFontWeight ?? FontWeight.w500, fontSize: 12.0, color: labelColor ?? customColors.txtBlack),

                  /// Label validation
                  Txt(isValidated ? '' : CustomText.obscureChar, color: CustomColors.red),
                ],
              )
            : Container(),
        labelText != null ? SizedBox(height: 7.0) : Container(),

        Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            /// Background
            Container(
              padding: padding,
              height: 50.0,
              decoration: new BoxDecoration(
                color: backgroundColor ?? customColors.backgroundGrey,
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              ),
              child: Center(
                /// Text field
                child: TextFormField(
                  decoration: InputDecoration(
//                    contentPadding: const EdgeInsets.only(top:0.0,right: 5.0, bottom: 0.0, left: 0.0),
                    border: InputBorder.none,
                    counterText: "",

                    /// Prefix
                    prefixIcon: prefixIcon ??
                        (prefixText != null
                            ? SizedBox(
                                height: 0.0,
                                child: Center(
                                  widthFactor: 0.0,
                                  child: Text(
                                    prefixText + '   ',
                                    style: TextStyle(fontSize: 16.0, color: customColors.txtBlack),
                                  ),
                                ),
                              )
                            : null),

//                    suffixIcon: suffixIcon,
                    hintText: hintText ?? '',
                    hintStyle: TextStyle(color: customColors.txtGrey),
                  ),
                  keyboardType: textInputType,
                  maxLength: maxLength,
                  autofocus: false,
                  obscureText: obscureText,
                  controller: controller,
                  focusNode: focusNode,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(fontSize: 16.0, color: textColor ?? customColors.txtBlack),
                  enabled: enabled,
                ),
              ),
            ),
            suffixIcon != null ? suffixIcon : Container(),
          ],
        ),
      ],
    ),
  );
}

// Widget txtMulti({
//   @required BuildContext context,
//   @required TextEditingController controller,
//   String hintText,
//   String prefixText,
//   IconData iconData,
//   bool obscureText = false,
//   EdgeInsets margin,
//   @required int maxLength,
//   TextInputType textInputType,
//   String labelText,
//   Color labelColor,
//   FontWeight labelFontWeight,
//   Color textColor,
//   IconButton suffixIcon,
//   Color bgColor,
//   int maxLines,
// }) {
//   return new Container(
//     margin: margin ?? EdgeInsets.all(0.0),
//     child: Column(
//       children: <Widget>[
//
//         /// Label
//         labelText != null
//             ? lbl(labelText,
//             fontWeight: labelFontWeight ?? FontWeight.w500,
//             fontSize: 12.0,
//             color: labelColor ?? customColors.lblWhite)
//             : Container(),
//         labelText != null ? SizedBox(height: 10.0) : Container(),
//
//         /// Background
//         Stack(
//           alignment: Alignment.centerRight,
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.only(left: 15.0),
//               height: AppHelper.textBoxHeight,
//               decoration: new BoxDecoration(
//                 color: bgColor ?? customColors.athensGray,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(8.0),
//                 ),
//               ),
//               child: Center(
//
//                 /// Text field
//                 child: TextFormField(
//                   decoration: InputDecoration(
// //                    contentPadding: const EdgeInsets.only(top:0.0,right: 5.0, bottom: 0.0, left: 0.0),
//                     border: InputBorder.none,
//                     counterText: "",
//
//                     /// Prefix
//                     prefixIcon: prefixText != null
//                         ? SizedBox(
//                       height: 0.0,
//                       child: Center(
//                         widthFactor: 0.0,
//                         child: Text(prefixText + '   ',
//                             style: TextStyle(
//                                 fontSize: 16.0,
//                                 color: customColors.lblDark)),
//                       ),
//                     )
//                         : null,
//
// //                    suffixIcon: suffixIcon,
//                   ),
//                   keyboardType: TextInputType.multiline,
//                   expands: true,
//                   maxLength: maxLength,
//                   autofocus: false,
//                   maxLines: maxLines,
// //                  obscureText: obscureText,
//                   controller: controller,
//                   textAlign: TextAlign.start,
//                   textAlignVertical: TextAlignVertical.center,
//                   style: TextStyle(
//                       fontSize: 16.0, color: textColor ?? customColors.lblDark),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// class TxtClean extends StatelessWidget {
//   const TxtClean({
//     Key key,
//     this.controller,
//     this.border,
//     this.focusedBorder = InputBorder.none,
//     this.enabledBorder = InputBorder.none,
//     this.errorBorder = InputBorder.none,
//     this.disabledBorder = InputBorder.none,
//     this.fontWeight = FontWeight.normal,
//   }) : super(key: key);
//
//   final TextEditingController controller;
//   final ShapeBorder border;
//   final ShapeBorder focusedBorder;
//   final ShapeBorder enabledBorder;
//   final ShapeBorder errorBorder;
//   final ShapeBorder disabledBorder;
//   final FontWeight fontWeight;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       style: TextStyle(fontWeight: fontWeight),
//       controller: controller,
//       textAlign: TextAlign.end,
//       decoration: InputDecoration(
//         border: border ?? InputBorder.none,
//         focusedBorder: focusedBorder,
//         enabledBorder: enabledBorder,
//         errorBorder: errorBorder,
//         disabledBorder: disabledBorder,
//         contentPadding: EdgeInsets.zero,
// //        enabledBorder: UnderlineInputBorder(
// //          borderSide: BorderSide(color: customColors.athensGray),
// //        ),
// //        focusedBorder: UnderlineInputBorder(
// //          borderSide: BorderSide(color: customColors.blue),
// //        ),
//       ),
//     );
//   }
// }

// class TxtAmt extends StatelessWidget {
//   TxtAmt({
//     this.labelText,
//     this.controller,
//     this.focusNode,
//     this.maxLength,
//     this.enabled = true,
//     this.textInputType,
//   });
//
//   final String labelText;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final int maxLength;
//   final bool enabled;
//   final TextInputType textInputType;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 5.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           Func.isNotEmpty(labelText)
//               ? Container(
//             width: 100,
//             child: lbl(
//               labelText,
//               maxLines: 2,
//               alignment: Alignment.bottomLeft,
//               padding: EdgeInsets.symmetric(vertical: 5.0),
//             ),
//           )
//               : Container(),
//           TextFormField(
// //            key: control.key,
// //              textAlignVertical: TextAlignVertical.bottom,
//             textAlign: TextAlign.end,
//             controller: controller,
//             focusNode: focusNode,
// //            style: lblStyle(
// //                style: LBL.SUBHEAD,
// //                color: control.textStyle?.color,
// //                fontSize: control.textStyle?.fontSize ?? fontSizeNormal,
// //                fontWeight: control.textStyle?.fontWeight ?? FontWeight.w700),
//             maxLength: maxLength,
//             enabled: enabled,
//             inputFormatters: [
//               MoneyMaskTextInputFormatter(
//                 precision: 0,
//                 min: 0,
//                 max: 99999999999,
//                 initialValue: 0,
//                 maxLength: 14,
//               )
//             ],
//             textCapitalization: TextCapitalization.none,
//             keyboardType: textInputType ?? TextInputType.text,
// //            decoration: InputDecoration(
// //              hintText: control.hint,
// //              hintStyle: lblStyle(style: LBL.GREY),
// //              enabledBorder: UnderlineInputBorder(
// //                borderSide: BorderSide(color: customColors.iconSpecialColor()),
// //              ),
// //              focusedBorder: UnderlineInputBorder(
// //                borderSide: BorderSide(color: customColors.iconSpecialColor()),
// //              ),
// //            ),
//             buildCounter: (BuildContext context,
//                 {int currentLength, int maxLength, bool isFocused}) =>
//             null,
// //            validator: control.validator,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// Widget txtAmt({
//   @required BuildContext context,
//   @required TextEditingController controller,
//   FocusNode focusNode,
//   String hintText,
//   String prefixText,
//   IconData iconData,
//   bool obscureText = false,
//   EdgeInsets margin,
//   EdgeInsets padding,
//   @required int maxLength,
//   TextInputType textInputType,
//   String labelText,
//   Color labelColor,
//   FontWeight labelFontWeight,
//   Color textColor,
//   Widget suffixIcon,
//   Color bgColor,
//   double borderRadius = 8.0,
//   Widget prefixIcon,
//   bool enabled = true,
//   bool isValidated = true,
// }) {
//   return new Container(
//     margin: margin ?? EdgeInsets.all(0.0),
//     child: Column(
//       children: <Widget>[
//
//         /// Label
//         labelText != null
//             ? Row(
//           children: <Widget>[
//
//             /// Label
//             lbl(labelText,
//                 fontWeight: labelFontWeight ?? FontWeight.w500,
//                 fontSize: 12.0,
//                 color: labelColor ?? customColors.lblDark),
//
//             /// Label validation
//             lbl(isValidated ? '' : AppHelper.symbolValid,
//                 color: customColors.lblRed),
//           ],
//         )
//             : Container(),
//         labelText != null ? SizedBox(height: 7.0) : Container(),
//
//         Stack(
//           alignment: Alignment.centerRight,
//           children: <Widget>[
//
//             /// Background
//             Container(
//               padding: padding ?? EdgeInsets.only(left: 15.0),
//               height: 50.0,
//               decoration: new BoxDecoration(
//                 color: bgColor ?? customColors.athensGray,
//                 borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
//               ),
//               child: Center(
//
//                 /// Text field
//                 child: TextFormField(
//                   decoration: InputDecoration(
// //                    contentPadding: const EdgeInsets.only(top:0.0,right: 5.0, bottom: 0.0, left: 0.0),
//                     border: InputBorder.none,
//                     counterText: "",
//
//                     /// Prefix
//                     prefixIcon: prefixIcon ??
//                         (prefixText != null
//                             ? SizedBox(
//                           height: 0.0,
//                           child: Center(
//                             widthFactor: 0.0,
//                             child: Text(
//                               prefixText + '   ',
//                               style: TextStyle(
//                                   fontSize: 16.0,
//                                   color: customColors.lblDark),
//                             ),
//                           ),
//                         )
//                             : null),
//
// //                    suffixIcon: suffixIcon,
//                     hintText: hintText ?? '',
//                     hintStyle: TextStyle(color: customColors.lblGrey),
//                   ),
//                   keyboardType: textInputType,
//                   maxLength: maxLength,
//                   autofocus: false,
//                   obscureText: obscureText,
//                   controller: controller,
//                   focusNode: focusNode,
//                   textAlign: TextAlign.start,
//                   textAlignVertical: TextAlignVertical.center,
//                   style: TextStyle(
//                       fontSize: 16.0, color: textColor ?? customColors.lblDark),
//                   enabled: enabled,
//                   inputFormatters: [
//                     MoneyMaskTextInputFormatter(
//                       precision: 0,
//                       min: 0,
//                       max: 99999999999,
//                       initialValue: 0,
//                       maxLength: 14,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             suffixIcon != null ? suffixIcon : Container(),
//           ],
//         ),
//       ],
//     ),
//   );
// }
