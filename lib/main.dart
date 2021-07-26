import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/main_bloc.dart';
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

  Globals globals = Globals();

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

    return MultiBlocProvider(
      /// Providers
      providers: [
        BlocProvider<MainBloc>(create: (BuildContext context) => BlocManager.mainBloc),
      ],

      /// Listeners
      child: BlocBuilder<MainBloc, MainState>(
        builder: _blocBuilder,
      ),
    );

    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (_, theme) {
          return MaterialApp(
            title: CustomText.appName,
            onGenerateTitle: (BuildContext context) => CustomText.appName,
            theme: theme,
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

  Widget _blocBuilder(BuildContext context, MainState state) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (_, theme) {
          return MaterialApp(
            title: CustomText.appName,
            onGenerateTitle: (BuildContext context) => CustomText.appName,
            theme: theme,
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
