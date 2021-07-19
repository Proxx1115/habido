// import 'package:flutter/material.dart';
// import 'package:habido_app/utils/assets.dart';
// import 'package:habido_app/utils/func.dart';
// import 'package:habido_app/utils/main_helper.dart';
//
// class DialogHelper {
//   static const double titleHeight = 0.0;
//   static const double statusBarHeight = 20.0;
//   static double headerHeight = kToolbarHeight + titleHeight + statusBarHeight;
// }
//
// enum DialogType { information, success, error, warning }
//
// void showCustomDialog(
//   BuildContext context, {
//   required Widget child,
//   DialogType dialogType = DialogType.information,
//   String? titleText,
//   String? bodyText,
//   String? btnPositiveText,
//   String? btnNegativeText,
//   Function? onPressedBtnPositive,
//   Function? onPressedBtnNegative,
//   double? btnPositiveWidth,
//   double? btnNegativeWidth,
//   bool visibleBtnPositive = false,
//   bool visibleBtnNegative = false,
//   EdgeInsets padding = const EdgeInsets.all(30.0),
//   bool dismissible = false,
// }) {
//   // Hide keyboard
//   Func.hideKeyboard(context);
//
//   // Init icon
//   String assetName;
//   switch (dialogType) {
//     case DialogType.success:
//       assetName = Assets.success;
//       break;
//
//     case DialogType.error:
//       assetName = Assets.error;
//       break;
//
//     case DialogType.information:
//     case DialogType.warning:
//     default:
//       assetName = Assets.warning;
//       break;
//   }
//
//   // Init buttons
//   visibleBtnPositive = Func.isNotEmpty(btnPositiveText);
//   visibleBtnNegative = Func.isNotEmpty(btnNegativeText);
//
//   // Init button positive
//   Widget btnPositive = visibleBtnPositive
//       ? Btn(
//           text: btnPositiveText,
//           width: btnPositiveWidth ?? (!visibleBtnNegative ? (MediaQuery.of(context).size.width / 3) : double.infinity),
//           height: SizeHelper.buttonHeightSmall,
//           alignment: Func.isEmpty(btnNegativeText) ? MainAxisAlignment.center : MainAxisAlignment.end,
//           onPressed: () {
//             Navigator.pop(context);
//             if (onPressedBtnPositive != null) onPressedBtnPositive();
//           },
//         )
//       : null;
//
//   // Init button negative
//   Widget btnNegative = visibleBtnNegative
//       ? Btn(
//           text: btnNegativeText,
//           width: btnNegativeWidth ?? (!visibleBtnPositive ? (MediaQuery.of(context).size.width / 3) : double.infinity),
//           height: SizeHelper.buttonHeightSmall,
//           alignment: Func.isEmpty(btnPositiveText) ? MainAxisAlignment.center : MainAxisAlignment.start,
//           onPressed: () {
//             Navigator.pop(context);
//             if (onPressedBtnNegative != null) onPressedBtnNegative();
//           },
//         )
//       : null;
//
//   /// Show dialog
//   showDialog(
//     barrierDismissible: dismissible,
//     context: context,
//     builder: (BuildContext context) {
//       return WillPopScope(
//         onWillPop: () {
//           return Future.value(false);
//         },
//         child:
//
//             /// Custom dialog
//             child ??
//
//                 /// Default dialog
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 25),
//                   child: AlertDialog(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
//                     contentPadding: padding,
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         /// Icon
//                         Image.asset(assetName, height: 50.0, width: 50.0),
//
//                         SizedBox(height: 20.0),
//
//                         /// Title
//                         if (Func.isNotEmpty(titleText))
//                           Txt(
//                             titleText ?? '',
//                             textAlign: TextAlign.center,
//                             maxLines: 10,
//                             alignment: Alignment.center,
//                             color: appColors.lbl,
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             margin: EdgeInsets.only(bottom: 10.0),
//                           ),
//
//                         /// Body
//                         Txt(bodyText ?? '', textAlign: TextAlign.center, maxLines: 10, alignment: Alignment.center, color: appColors.lbl),
//
//                         SizedBox(height: 20.0),
//
//                         /// Buttons
//                         Row(
//                           mainAxisAlignment:
//                               (visibleBtnNegative && visibleBtnPositive) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
//                           children: [
//                             /// Button negative
//                             if (visibleBtnNegative) (visibleBtnPositive ? Expanded(child: btnNegative) : btnNegative),
//
//                             /// Margin
//                             if (btnNegative != null && btnPositive != null) SizedBox(width: SizeHelper.margin),
//
//                             /// Button positive
//                             if (visibleBtnPositive) (visibleBtnNegative ? Expanded(child: btnPositive) : btnPositive),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//       );
//     },
//   );
// }
