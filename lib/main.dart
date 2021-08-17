import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/main_bloc.dart';
import 'package:habido_app/models/verify_code_request.dart';
import 'package:habido_app/ui/auth/login_route.dart';
import 'package:habido_app/ui/auth/sign_up1_phone_route.dart';
import 'package:habido_app/ui/auth/sign_up5_success_route.dart';
import 'package:habido_app/ui/intro/intro_route.dart';
import 'package:habido_app/ui/test/hero1_route.dart';
import 'package:habido_app/ui/test/test_route.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/bloc_manager.dart';
import 'ui/intro/splash_route.dart';
import 'utils/globals.dart';
import 'utils/route/routes.dart';
import 'utils/theme/theme_cubit.dart';

void main() async {
  // Binds the framework to flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.getInstance().then((instance) {
    sharedPref = instance;

    // Firebase push notification
    // pushNotifManager.init();

    // API
    // apiCaller = new ApiCaller();

    // Local notification
    // LocalNotifHelper.init();

    // Run flutter application
    runApp(HabidoApp());
  });
}

class HabidoApp extends StatelessWidget {
  HabidoApp() {
    // Init global params
    globals = Globals();

    // Bloc
    // BlocManager.mainBloc.add(InitEvent());
  }

  void dispose() {
    BlocManager.dispose();
  }

  final Routes _routes = Routes();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addObserver(LifecycleEventHandler(BlocManager.mainBloc));

    return BlocProvider(
      create: (context) => BlocManager.mainBloc,
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return MaterialApp(
            title: LocaleKeys.appName,
            onGenerateTitle: (BuildContext context) => LocaleKeys.appName,
            // theme: theme,
            localizationsDelegates: [
              FlutterBlocLocalizationsDelegate(),
            ],
            debugShowCheckedModeBanner: false,
            showPerformanceOverlay: false,
            showSemanticsDebugger: false,
            onGenerateRoute: _routes.onGenerateRoute,
            navigatorObservers: [_routes.routeObserver],
            home: SplashRoute(),
          );
        },
      ),
    );
  }
}
