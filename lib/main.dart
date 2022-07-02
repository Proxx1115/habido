import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/main_bloc.dart';
import 'package:habido_app/ui/intro/intro_route.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/push_notif_manager.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'bloc/bloc_manager.dart';
import 'ui/intro/splash_route.dart';
import 'utils/device_helper.dart';
import 'utils/route/routes.dart';

void main() async {
  // Binds the framework to flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.getInstance().then((instance) {
    sharedPref = instance;

    // Firebase push notification
    pushNotifManager.init();

    // Local notification
    // LocalNotifHelper.init();

    // Run flutter application
    runApp(HabidoApp());
  });
}

class HabidoApp extends StatelessWidget {
  HabidoApp() {
    // Init global params
    // globals.init();

    // Init device info
    DeviceHelper.init();

    // Bloc
    // BlocManager.mainBloc.add(InitEvent());

    // Init locale
    initializeDateFormatting('mn');
  }

  void dispose() {
    BlocManager.dispose();
  }

  final Routes _routes = Routes();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        ?.addObserver(LifecycleEventHandler(BlocManager.mainBloc));

    return BlocProvider(
      create: (context) => BlocManager.mainBloc,
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(fontFamily: FontAsset.SFProRounded),
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
            home: IntroRoute(),
          );
        },
      ),
    );
  }
}
