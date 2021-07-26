import 'package:flutter/material.dart';
import 'package:habido_app/ui/auth/login_route.dart';
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
  static const home = 'home';

  /// Routing
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Route<dynamic> route;

    switch (settings.name) {
      case Routes.splash:
        route = NoTransitionRoute(IntroRoute(), settings);
        break;

      case Routes.intro:
        route = NoTransitionRoute(IntroRoute(), settings);
        break;

      case Routes.login:
        route = DefaultRoute(LoginRoute(), settings);
        break;

      case Routes.comingSoon:
      default:
        route = DefaultRoute(ComingSoonRoute(), settings);
        break;
    }

    return route;
  }

  Map<String, dynamic>? _getValueByKey(Map<String, dynamic> args, String key) {
    try {
      return args[key];
    } catch (e) {
      print(e);
    }

    return null;
  }
}
