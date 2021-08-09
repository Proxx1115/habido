import 'package:flutter/material.dart';
import 'package:habido_app/ui/auth/forgot_pass_route.dart';
import 'package:habido_app/ui/auth/login_route.dart';
import 'package:habido_app/ui/auth/sign_up_route.dart';
import 'package:habido_app/ui/auth/verify_code_route.dart';
import 'package:habido_app/ui/global/coming_soon_route.dart';
import 'package:habido_app/ui/intro/intro_route.dart';
import 'route_transitions.dart';

class Routes {
  Routes() : routeObserver = RouteObserver<PageRoute>();

  /// Route Observer
  final RouteObserver<PageRoute> routeObserver;

  /// Route list
  static const comingSoon = 'comingSoon';
  static const splash = 'splash';
  static const intro = 'intro';
  static const login = 'login';
  static const signUp = 'signUp';
  static const verifyCode = 'verifyCode';
  static const forgotPass = 'forgotPass';
  static const home = 'home';

  /// Routing
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Route<dynamic> route;

    switch (settings.name) {
      case Routes.splash:
        route = NoTransitionRoute(IntroRoute(), settings);
        break;

      case Routes.intro:
        route = FadePageRouteBuilder(IntroRoute(), settings);
        break;

      case Routes.login:
        route = PageRouteBuilder(transitionDuration: Duration(milliseconds: 1600), pageBuilder: (_, __, ___) => LoginRoute());
        break;

      case Routes.signUp:
        route = SlideRightRoute(SignUpRoute(), settings);
        break;

      case Routes.verifyCode:
        var args = settings.arguments as Map;
        route = SlideRightRoute(
          VerifyCodeRoute(
            signUpResponse: _getValueByKey(args, 'signUpResponse'),
          ),
          settings,
        );

        route = SlideRightRoute(VerifyCodeRoute(), settings);
        break;

      case Routes.forgotPass:
        route = SlideRightRoute(ForgotPassRoute(), settings);
        break;

      case Routes.comingSoon:
      default:
        route = NoTransitionRoute(ComingSoonRoute(), settings);
        break;
    }

    return route;
  }

  _getValueByKey(Map<dynamic, dynamic> args, String key) {
    try {
      return args[key];
    } catch (e) {
      print(e);
    }

    return null;
  }
}
