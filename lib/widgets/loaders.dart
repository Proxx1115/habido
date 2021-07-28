import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:habido_app/utils/size_helper.dart';

// ignore: non_constant_identifier_names
Widget CustomLoader({
  required BuildContext context,
  required double height,
  bool visible = true,
}) {
  return Container(
    height: height,
    child: visible
        ? Center(
            child: Container(
              height: SizeHelper.loaderSize,
              width: SizeHelper.loaderSize,
              child: CircularProgressIndicator(),
            ),
          )
        : Container(),
  );
}

// ignore: non_constant_identifier_names
Widget CustomLoaderStack({
  required BuildContext context,
  required double height,
  required Widget child,
  bool visible = true,
}) {
  var widgetList = <Widget>[];

  if (visible) {
    widgetList.add(Container(
      height: height,
      child: Center(
        child: Container(
          height: SizeHelper.loaderSize,
          width: SizeHelper.loaderSize,
          child: CircularProgressIndicator(),
        ),
      ),
    ));
  }

  if (child != null) widgetList.add(child);

  return Stack(children: widgetList);
}

// ignore: non_constant_identifier_names
Widget BlurLoadingContainer({
  required bool loading,
  required Widget child,
}) {
  var widgetList = <Widget>[child];

  if (loading) {
    Widget loadingContainer = Container(
      color: Colors.grey.withOpacity(0.1),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 1.0,
          sigmaY: 1.0,
        ),
        child:  Center(
          child: SizedBox(
            height: SizeHelper.loaderSize,
            width: SizeHelper.loaderSize,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    widgetList.add(loadingContainer);
  }

  return Stack(children: widgetList);
}


// class CircularLoader extends StatelessWidget {
//   final double size;
//
//   const CircularLoader({Key key, this.size = 50.0}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: size,
//         height: size,
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
//
// // ignore: non_constant_identifier_names
// Widget BlurLoadingContainer2({
//   @required bool loading,
//   Widget child,
// }) {
//   var widgetList = List<Widget>();
//   if (child != null) widgetList.add(child);
//
//   if (loading) {
//     Widget loadingContainer = Container(
//       color: Colors.grey.withOpacity(0.1),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(
//           sigmaX: 1.0,
//           sigmaY: 1.0,
//         ),
//         child: Center(
//           child: SizedBox(
//             height: SizeHelper.loaderSize,
//             width: SizeHelper.loaderSize,
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ),
//     );
//
//     widgetList.add(loadingContainer);
//   }
//
//   return Stack(children: widgetList);
// }
//
// // ignore: non_constant_identifier_names
// Widget LoadingContainer({
//   @required bool loading,
//   Widget child,
//   double height,
// }) {
//   var widgetList = List<Widget>();
//   if (child != null) widgetList.add(child);
//
//   if (loading) {
//     Widget loadingContainer = Center(
//       child: Container(
// //        color: Colors.black12.withOpacity(0.5),
//         child: Container(
//           height: SizeHelper.loaderSize,
//           width: SizeHelper.loaderSize,
//           child: CircularProgressIndicator(),
//
// //          ColorLoader4(
// //            dotOneColor: Colors.lightBlueAccent,
// //            dotTwoColor: Colors.lightBlue,
// //            dotThreeColor: Colors.blue,
// //            dotType: DotType.square,
// //            duration: Duration(milliseconds: 1200),
// //          ),
//         ),
//       ),
//     );
//
//     // Height
//     if (height != null) {
//       loadingContainer = Container(height: height, child: loadingContainer);
//     }
//
// //    widgetList.add(Positioned.fill(child: loadingContainer));
//     widgetList.add(loadingContainer);
//   }
//
//   return Stack(children: widgetList);
// }
//
// void showLoader(BuildContext context) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (context) {
//       return WillPopScope(
//         onWillPop: () {
//           return Future.value(false);
//         },
//         child: Center(
//           child: SizedBox(
//             height: SizeHelper.loaderSize,
//             width: SizeHelper.loaderSize,
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       );
//     },
//   );
// }
//
// Widget ShimmerContainer({BuildContext context, Widget child, double height}) {
//   return Container(
//     height: height,
//     child: Center(
//       child: Opacity(
//         opacity: 0.8,
//         child: Shimmer.fromColors(
//           child: child ?? Container(),
//           baseColor: Colors.grey.withOpacity(0.1),
//           highlightColor: Colors.white,
//           loop: 10,
//         ),
//       ),
//     ),
//   );
// }
