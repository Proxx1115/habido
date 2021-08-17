import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DefaultRoute<T> extends MaterialPageRoute<T> {
  DefaultRoute(Widget widget, RouteSettings settings) : super(builder: (_) => widget, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class SlideRightRouteBuilder extends PageRouteBuilder {
  final Widget w;
  @override
  final RouteSettings settings;

  SlideRightRouteBuilder(this.w, this.settings)
      : super(
          settings: settings,
          pageBuilder: (BuildContext ctx, _, __) {
            return w;
          },
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}

class NoTransitionRoute<T> extends MaterialPageRoute<T> {
  NoTransitionRoute(Widget widget, RouteSettings settings) : super(builder: (_) => widget, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class FadeRouteBuilder extends PageRouteBuilder {
  final Widget w;

  @override
  final RouteSettings settings;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  FadeRouteBuilder(this.w, this.settings)
      : super(
          settings: settings,
          pageBuilder: (BuildContext ctx, _, __) {
            return w;
          },
          transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}

/// NoPushTransitionRoute - Custom route which has no transition when pushed, but has a pop animation
// class NoPushTransitionRoute<T> extends MaterialPageRoute<T> {
//   NoPushTransitionRoute(Widget widget, RouteSettings settings) : super(builder: (_) => widget, settings: settings);
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//     // is popping
//     if (animation.status == AnimationStatus.reverse) {
//       return super.buildTransitions(context, animation, secondaryAnimation, child);
//     }
//     return child;
//   }
// }

/// NoPopTransitionRoute - Custom route which has no transition when popped, but has a push animation
// class NoPopTransitionRoute<T> extends MaterialPageRoute<T> {
//   NoPopTransitionRoute(Widget widget, RouteSettings settings) : super(builder: (_) => widget, settings: settings);
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//     // is pushing
//     if (animation.status == AnimationStatus.forward) {
//       return super.buildTransitions(context, animation, secondaryAnimation, child);
//     }
//     return child;
//   }
// }

// class EnterExitRoute extends PageRouteBuilder {
//   final Widget enterPage;
//   final Widget exitPage;
//   @override
//   final RouteSettings settings;
//
//   EnterExitRoute(
//     this.exitPage,
//     this.enterPage,
//     this.settings,
//   ) : super(
//           settings: settings,
//           pageBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//           ) =>
//               enterPage,
//           transitionsBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//             Widget child,
//           ) =>
//               Stack(
//             children: <Widget>[
//               SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(0.0, 0.0),
//                   end: const Offset(-1.0, 0.0),
//                 ).animate(animation),
//                 child: exitPage ?? Container(),
//               ),
//               SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(1.0, 0.0),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: enterPage,
//               )
//             ],
//           ),
//         );
// }
