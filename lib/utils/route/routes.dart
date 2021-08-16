import 'package:flutter/material.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/ui/auth/forgot_pass_route.dart';
import 'package:habido_app/ui/auth/login_route.dart';
import 'package:habido_app/ui/auth/sign_up3_profile_route.dart';
import 'package:habido_app/ui/auth/sign_up1_phone_route.dart';
import 'package:habido_app/ui/auth/sign_up2_code_route.dart';
import 'package:habido_app/ui/auth/sign_up4_terms_route.dart';
import 'package:habido_app/ui/auth/sign_up5_success_route.dart';
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
  static const forgotPass = 'forgotPass';
  static const signUp1Phone = 'signUp1Phone';
  static const signUp2Code = 'signUp2Code';
  static const signUp3Profile = 'signUp3Profile';
  static const signUp4Terms = 'signUp4Terms';
  static const signUp5Success = 'signUp5Success';
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
        route = PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1600),
          pageBuilder: (_, __, ___) => LoginRoute(),
        );
        break;

      case Routes.signUp1Phone:
        route = SlideRightRoute(SignUp1PhoneRoute(), settings);
        break;

      case Routes.signUp2Code:
        var args = settings.arguments as Map;
        route = SlideRightRoute(
          SignUp2CodeRoute(
            signUpResponse: _getValueByKey(args, 'signUpResponse'),
          ),
          settings,
        );
        break;

      case Routes.signUp3Profile:
        var args = settings.arguments as Map;
        route = SlideRightRoute(
          SignUp3ProfileRoute(
            signUpResponse: _getValueByKey(args, 'signUpResponse'),
            code: _getValueByKey(args, 'code'),
          ),
          settings,
        );
        break;

      case Routes.signUp4Terms:
        var args = settings.arguments as Map;
        route = SlideRightRoute(
          SignUp4TermsRoute(
            signUpResponse: _getValueByKey(args, 'signUpResponse'),
            code: _getValueByKey(args, 'code'),
          ),
          settings,
        );
        break;

      case Routes.signUp5Success:
        route = SlideRightRoute(SignUp5SuccessRoute(), settings);
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
