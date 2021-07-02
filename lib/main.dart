import 'package:flutter/material.dart';
import 'package:habido_app/modules/intro/splash_route.dart';
import 'package:habido_app/utils/shared_pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  SharedPreferences? sharedPreferences;
}

void main() async {
  // Binds the framework to flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  Globals globals = Globals();

  globals.sharedPreferences = await SharedPreferences.getInstance();

  var test = await SP.getIntroCount();
}

class HabidoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashRoute(),
    );
  }
}
