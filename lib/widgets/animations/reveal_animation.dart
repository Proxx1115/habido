// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
//
// enum RevealAnimationType { SLIDE, FLIP, SCALE }
//
// const Duration revealAnimationDuration = Duration(milliseconds: 700);
// ScaleAnimation scaleAnimation(Widget w, Duration duration){
//   return ScaleAnimation(
//     duration: duration,
//     child: FadeInAnimation(
//       duration: duration,
//       child: w,
//     ),
//   );
// }
//
// SlideAnimation slideAnimation(Widget w, Duration duration){
//   return SlideAnimation(
//     duration: duration,
//     horizontalOffset: 300.0,
//     child: FadeInAnimation(
//       duration: duration,
//       child: w,
//     ),
//   );
// }
//
// FlipAnimation flipAnimation(Widget w, Duration duration){
//   return FlipAnimation(
//     duration: duration,
//     child: FadeInAnimation(
//       duration: duration,
//       child: w,
//     ),
//   );
// }
//
// revealAnimationSelector(Widget w, RevealAnimationType animationType){
//   switch(animationType){
//     case RevealAnimationType.SLIDE: return slideAnimation(w, revealAnimationDuration);
//     case RevealAnimationType.FLIP: return flipAnimation(w, revealAnimationDuration);
//     case RevealAnimationType.SCALE: return scaleAnimation(w, revealAnimationDuration);
//     default: return slideAnimation(w, revealAnimationDuration);
//   }
// }