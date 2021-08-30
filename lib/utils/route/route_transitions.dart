import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

class SlideBottomRouteBuilder<T> extends MaterialPageRoute<T> {
  final tween = Tween(
    begin: Offset(0.0, 1.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.ease));

  SlideBottomRouteBuilder(Widget widget, RouteSettings settings) : super(builder: (context) => widget, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
