import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

/// Дээд талаараа дугуйрсан ирмэгтэй bottom sheet dialog харуулах
class DialogHelper {
  static const double titleHeight = 0.0;
  static const double statusBarHeight = 20.0;
  static double headerHeight = kToolbarHeight + titleHeight + statusBarHeight;

  static void showBottomSheetDialog({
    required BuildContext context,
    required double height,
    required Widget child,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          // height: (height ?? MediaQuery.of(context).size / 2),
          decoration: new BoxDecoration(
            color: customColors.backgroundWhite,
            borderRadius: new BorderRadius.only(topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0)),
          ),
          child: child,
        );
      },
    );
  }
}

enum DialogType { info, success, error, warning }

// void showCustomDialog(
//   BuildContext context, {
//   Widget? child,
//   DialogType dialogType = DialogType.info,
//   String? titleText,
//   String? bodyText,
//   String? btnPositiveText,
//   String? btnNegativeText,
//   VoidCallback? onPressedBtn1,
//   VoidCallback? onPressedBtn2,
//   double? btn1Width,
//   double? btn2Width,
//   bool visibleBtnPositive = false,
//   bool visibleBtnNegative = false,
//   EdgeInsets padding = const EdgeInsets.all(30.0),
//   bool dismissible = false,
// }) {
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
//     case DialogType.info:
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
//           width: btn2Width ?? (!visibleBtnNegative ? (MediaQuery.of(context).size.width / 3) : double.infinity),
//           boxHeight: SizeHelper.buttonHeightSmall,
//           alignment: Func.isEmpty(btnNegativeText) ? MainAxisAlignment.center : MainAxisAlignment.end,
//           onPressed: () {
//             Navigator.pop(context);
//             if (onPressedBtn2 != null) onPressedBtn2();
//           },
//         )
//       : null;
//
//   // Init button negative
//   Widget btnNegative = visibleBtnNegative
//       ? Btn(
//           text: btnNegativeText,
//           width: btn1Width ?? (!visibleBtnPositive ? (MediaQuery.of(context).size.width / 3) : double.infinity),
//           boxHeight: SizeHelper.buttonHeightSmall,
//           alignment: Func.isEmpty(btnPositiveText) ? MainAxisAlignment.center : MainAxisAlignment.start,
//           onPressed: () {
//             Navigator.pop(context);
//             if (onPressedBtn1 != null) onPressedBtn1();
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
//                             color: appColors.txt,
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             margin: EdgeInsets.only(bottom: 10.0),
//                           ),
//
//                         /// Body
//                         Txt(bodyText ?? '', textAlign: TextAlign.center, maxLines: 10, alignment: Alignment.center, color: appColors.txt),
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

// /// Default dialog
// class MainDialog extends StatefulWidget {
//   final Widget child;
//   final EdgeInsets margin;
//   final EdgeInsets padding;
//
//   MainDialog({@required this.child, this.margin, this.padding});
//
//   @override
//   State<StatefulWidget> createState() => MainDialogState();
// }
//
// class MainDialogState extends State<MainDialog> with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//
//     return AnimatedContainer(
//       padding: mediaQuery.padding,
//       duration: const Duration(milliseconds: 300),
//       child: Center(
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             margin: widget.margin,
//             padding: widget.padding,
//             decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
//             child: widget.child ?? Container(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// RESPONSIVE DIALOG
// class ResponsiveDialog extends StatelessWidget {
//   final Widget child;
//
//   ResponsiveDialog({Key key, this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     return new AlertDialog(
//       content: AnimatedContainer(
// //        margin: EdgeInsets.all(20.0),
// //        padding: EdgeInsets.all(20.0),
// //      height: 450,
//         width: mediaQuery.size.width,
//         padding: mediaQuery.padding,
//         duration: const Duration(milliseconds: 300),
//         child: child,
//       ),
//     );
//   }
// }
//
// class ResponsiveDialog2 extends StatelessWidget {
//   final Widget child;
//
//   ResponsiveDialog2({Key key, this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     return new Center(
//       child: Material(
//         color: Colors.transparent,
//         child: AnimatedContainer(
// //        margin: EdgeInsets.all(20.0),
// //        padding: EdgeInsets.all(20.0),
// //      height: 450,
// //      width: mediaQuery.size.width,
//           padding: mediaQuery.padding,
//           duration: const Duration(milliseconds: 300),
//           child: child,
//         ),
//       ),
//     );
//   }
// }
//
// /// Scale animated dialog
// class ScaleDialog extends StatefulWidget {
//   final Widget child;
//   final EdgeInsets margin;
//   final EdgeInsets padding;
//
//   ScaleDialog({@required this.child, this.margin, this.padding});
//
//   @override
//   State<StatefulWidget> createState() => ScaleDialogState();
// }
//
// class ScaleDialogState extends State<ScaleDialog> with SingleTickerProviderStateMixin {
//   AnimationController controller;
//   Animation<double> scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
//     scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
//
//     controller.addListener(() {
//       setState(() {});
//     });
//
//     controller.forward();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Material(
//         color: Colors.transparent,
//         child: ScaleTransition(
//           scale: scaleAnimation,
//           child: Container(
//             margin: widget.margin,
//             padding: widget.padding,
//             decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
//             child: widget.child ?? Container(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// Scale animated dialog
// class FadeDialog extends StatefulWidget {
//   final Widget child;
//   final EdgeInsets margin;
//   final EdgeInsets padding;
//
//   FadeDialog({@required this.child, this.margin, this.padding});
//
//   @override
//   State<StatefulWidget> createState() => FadeDialogState();
// }
//
// class FadeDialogState extends State<FadeDialog> with SingleTickerProviderStateMixin {
//   AnimationController controller;
//   Animation<double> fadeInAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//     fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
//
//     controller.addListener(() {
//       setState(() {});
//     });
//
//     controller.forward();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Material(
//         color: Colors.transparent,
//         child: FadeTransition(
//           opacity: fadeInAnimation,
//           child: Container(
//             margin: widget.margin,
//             padding: widget.padding,
//             decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
//             child: widget.child ?? Container(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DialogInsetDefeat extends StatelessWidget {
//   final BuildContext context;
//   final Widget child;
//   final deInset = EdgeInsets.symmetric(horizontal: -40, vertical: -24);
//   final EdgeInsets edgeInsets;
//
//   DialogInsetDefeat({@required this.context, @required this.child, this.edgeInsets});
//
//   @override
//   Widget build(BuildContext context) {
//     var netEdgeInsets = deInset + (edgeInsets ?? EdgeInsets.zero);
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(viewInsets: netEdgeInsets),
//       child: child,
//     );
//   }
// }
//
// /// Displays a Material dialog using the above DialogInsetDefeat class.
// /// Meant to be a drop-in replacement for showDialog().
// ///
// /// See also:
// ///
// ///  * [Dialog], on which [SimpleDialog] and [AlertDialog] are based.
// ///  * [showDialog], which allows for customization of the dialog popup.
// ///  * <https://material.io/design/components/dialogs.html>
// Future<T> showDialogWithInsets<T>({
//   @required BuildContext context,
//   bool barrierDismissible = true,
//   @required WidgetBuilder builder,
//   EdgeInsets edgeInsets,
// }) {
//   return showDialog(
//     context: context,
//     builder: (_) => DialogInsetDefeat(
//       context: context,
//       edgeInsets: edgeInsets,
//       child: Builder(builder: builder),
//     ),
//     barrierDismissible: barrierDismissible = true,
//   );
// }
//
// /// Main dialog
// void showMainDialog({
//   @required BuildContext context,
//   Widget child,
//   EdgeInsets paddingChild,
//   String title,
//   String body,
//   String btnText,
//   Function onPressedBtn,
//   Widget img,
//   Widget buttons,
//   bool barrierDismissible = false,
//   double bodyHeight = 160.0,
// }) {
//   FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard
//
//   showDialog(
//     context: context,
//     barrierDismissible: barrierDismissible,
//     builder: (BuildContext context) {
//       // return object of type Dialog
//       return child != null
//           ? AlertDialog(
//               content: child,
//               contentPadding: paddingChild ?? EdgeInsets.all(0.0),
//             )
//           : AlertDialog(
//               /// TITLE
//               title: Container(
//                 child: Column(
//                   children: <Widget>[
//                     SizedBox(height: 20.0),
//                     img ??
//                         Image.asset(
//                           Assets.success,
//                           height: 74.0,
//                           colorBlendMode: BlendMode.modulate,
//                         ),
//                     SizedBox(height: 40.0),
//                     new Text(
//                       AppText.success,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: appColors.primary, fontWeight: FontWeight.w500, fontSize: 16.0),
//                     ),
//                   ],
//                 ),
//               ),
//
//               /// BODY
//               content: Container(
//                 height: bodyHeight,
//                 child: Column(
//                   children: <Widget>[
//                     /// Хөндлөн зураас
//                     if (body != null)
//                       Container(
//                         height: 0.5,
//                         color: Color(0XFFE4E7EC),
//                         margin: EdgeInsets.only(
//                           top: 10.0,
//                           right: 30.0,
//                           bottom: 10.0,
//                           left: 30.0,
//                         ),
//                       ),
//
//                     SizedBox(height: 20.0),
//
//                     if (body != null)
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 20.0),
//                         child: new Text(
//                           body,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Color(0XFF8D98AB)),
//                         ),
//                       ),
//
//                     if (body != null)
//                       SizedBox(
//                         height: 20.0,
//                       ),
//
//                     buttons ??
//                         Btn(
//                           text: btnText ?? 'OK',
//                           context: context,
//                           margin: EdgeInsets.symmetric(horizontal: 20.0 + 10.0),
//                           color: appColors.btn,
//                           disabledColor: appColors.btn2,
//                           textColor: Colors.white,
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w500,
//                           onPressed: () {
//                             onPressedBtn();
//                           },
//                         ),
//                   ],
//                 ),
//               ),
//             );
//     },
//   );
// }
//
// ///Fullscreen success Dialog
// showFullScreenSuccessDialog(
//   BuildContext context, {
//   Widget child,
//   EdgeInsets paddingChild,
//   String btnText,
//   Function onPressedBtn,
//   Widget img,
//   Widget buttons,
//   bool barrierDismissible = false,
//   double bodyHeight = 160.0,
// }) {
//   showDialog(
//     context: context,
//     barrierDismissible: barrierDismissible,
//     builder: (BuildContext context) {
//       // return object of type Dialog
//       return child != null
//           ? AlertDialog(
//               content: child,
//               contentPadding: paddingChild ?? EdgeInsets.all(0.0),
//             )
//           : AlertDialog(
//               /// TITLE
//               title: Container(
//                 child: Column(
//                   children: <Widget>[
//                     SizedBox(height: 20.0),
//                     img ??
//                         Image.asset(
//                           Assets.success,
//                           height: 74.0,
//                           colorBlendMode: BlendMode.modulate,
//                         ),
//                     SizedBox(height: 40.0),
//                     Text(
//                       AppText.success,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: appColors.primary, fontWeight: FontWeight.w500, fontSize: 16.0),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//     },
//   );
// }
//
// void showDynamicDialog(
//   BuildContext context, {
//   @required Widget child,
//   EdgeInsets padding = const EdgeInsets.all(30.0),
//   bool dismissible = true,
// }) {
//   // Hide keyboard
//   AppHelper.hideKeyboard(context);
//
//   showDialog(
//     barrierDismissible: dismissible,
//     context: context,
//     builder: (BuildContext context) {
//       return WillPopScope(
//           onWillPop: () {
//             return Future.value(false);
//           },
//           child: AlertDialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
//               contentPadding: padding,
//               content: child ?? Container()));
//     },
//   );
// }
