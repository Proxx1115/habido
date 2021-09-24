import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

void showCustomDialog(BuildContext context, {required Widget child, bool isDismissible = false}) {
  Func.hideKeyboard(context);

  showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return child;
    },
  );
}

class CustomDialogBody extends StatelessWidget {
  final Color? color;
  final String? asset;
  final String? text;
  final Widget? child;
  final String? buttonText;
  final String? button2Text;
  final VoidCallback? onPressedButton;
  final VoidCallback? onPressedButton2;

  const CustomDialogBody({
    Key? key,
    this.color,
    this.asset,
    this.text,
    this.buttonText,
    this.button2Text,
    this.onPressedButton,
    this.onPressedButton2,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      decoration: new BoxDecoration(
        color: customColors.whiteBackground,
        borderRadius: new BorderRadius.only(topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(45.0),
            child: Column(
              children: [
                /// Icon
                if (asset != null) _icon(),

                /// Text
                if (text != null) _text(),

                /// Custom child
                if (child != null) child!,

                /// Buttons
                _buttons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon() {
    return Container(
      height: 55.0,
      width: 55.0,
      margin: EdgeInsets.only(bottom: 35.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: color ?? customColors.primary,
      ),
      child: SvgPicture.asset(asset!),
    );
  }

  Widget _text() {
    return CustomText(
      text,
      margin: EdgeInsets.only(bottom: 35.0),
      alignment: Alignment.center,
      maxLines: 2,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buttons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Button1
        if (buttonText != null)
          CustomButton(
            text: buttonText,
            onPressed: () {
              Navigator.pop(context);
              if (onPressedButton != null) onPressedButton!();
            },
            backgroundColor: color,
          ),

        // Margin
        if (buttonText != null && button2Text != null) SizedBox(height: 15.0),

        /// Button2
        if (button2Text != null)
          CustomButton(
            text: button2Text,
            contentColor: customColors.secondaryButtonContent,
            backgroundColor: customColors.secondaryButtonBackground,
            onPressed: () {
              Navigator.pop(context);
              if (onPressedButton2 != null) onPressedButton2!();
            },
          ),
      ],
    );
  }
}

// class DialogManager {
// static const double titleHeight = 0.0;
// static const double statusBarHeight = 20.0;
// static double headerHeight = kToolbarHeight + titleHeight + statusBarHeight;

// static void showCustomDialog({
//   required BuildContext context,
//   required String text,
//   // required double height,
//   // required Widget child,
// }) {
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent,
//     isScrollControlled: true,
//     builder: (BuildContext context) {
//       return Container(
//         // height: (height ?? MediaQuery.of(context).size / 2),
//         decoration: new BoxDecoration(
//           color: customColors.secondaryBackground,
//           borderRadius: new BorderRadius.only(topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0)),
//         ),
//         child: Container(),
//       );
//     },
//   );
// }

// static void showBottomSheetDialog({
//   required BuildContext context,
//   required double height,
//   required Widget child,
// }) {
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent,
//     isScrollControlled: true,
//     builder: (BuildContext context) {
//       return Container(
//         // height: (height ?? MediaQuery.of(context).size / 2),
//         decoration: new BoxDecoration(
//           color: customColors.secondaryBackground,
//           borderRadius: new BorderRadius.only(topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0)),
//         ),
//         child: child,
//       );
//     },
//   );
// }
// }

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
//                             color: customColors.txt,
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             margin: EdgeInsets.only(bottom: 10.0),
//                           ),
//
//                         /// Body
//                         Txt(bodyText ?? '', textAlign: TextAlign.center, maxLines: 10, alignment: Alignment.center, color: customColors.txt),
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
//                       CustomText.success,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: customColors.primary, fontWeight: FontWeight.w500, fontSize: 16.0),
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
//                           color: customColors.btn,
//                           disabledColor: customColors.btn2,
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
//                       CustomText.success,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: customColors.primary, fontWeight: FontWeight.w500, fontSize: 16.0),
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
//                             color: customColors.txt,
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                             margin: EdgeInsets.only(bottom: 10.0),
//                           ),
//
//                         /// Body
//                         Txt(bodyText ?? '', textAlign: TextAlign.center, maxLines: 10, alignment: Alignment.center, color: customColors.txt),
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

/// Show dialog
// showDialog(
//   barrierDismissible: dismissible,
//   context: context,
//   builder: (BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         return Future.value(false);
//       },
//       child: AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(35.0))),
//         contentPadding: EdgeInsets.all(45.0),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             /// Icon
//             if (asset != null)
//               Container(
//                 margin: EdgeInsets.only(bottom: 35.0),
//                 child: SvgPicture.asset(asset, height: 50.0, width: 50.0),
//               ),
//
//             /// Text
//             if (text != null)
//               CustomText(
//                 text,
//                 margin: EdgeInsets.only(bottom: 35.0),
//                 alignment: Alignment.center,
//                 maxLines: 10,
//                 fontWeight: FontWeight.w500,
//               ),
//
//             /// Buttons
//             // Row(
//             //   mainAxisAlignment: (button1Text != null && button2Text != null) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
//             //   children: [
//             //     /// Button1
//             //     if (button1 != null) (button2 != null ? Expanded(child: button1!) : button1!),
//             //
//             //     // Margin
//             //     if (button1 != null && button2 != null) SizedBox(width: SizeHelper.margin),
//             //
//             //     /// Button2
//             //     if (button2 != null) (button1 != null ? Expanded(child: button2!) : button2!),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   },
// );
