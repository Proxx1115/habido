import 'package:flutter/material.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/ui/auth/login_route.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/http_utils.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/device_helper.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/widgets/hero.dart';

class SplashRoute extends StatefulWidget {
  @override
  _SplashRouteState createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  @override
  void initState() {
    super.initState();

    // sharedPref?.clear();

    WidgetsBinding.instance?.addPostFrameCallback((_) => _init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: HeroHelper.getAppLogoWithName(),
      ),
    );
  }

  void _init() async {
    // Check update
    if (await _needUpdate()) return;

    _checkSession();
  }

  Future<bool> _needUpdate() async {
    bool res = false;

    try {
      var res = await ApiManager.param();
      if (res.code == ResponseCode.Success) {
        print('Success');
      } else {
        print('Failed');
      }
    } catch (e) {
      print(e);
    }

    return res;
  }

  _checkSession() {
    ApiManager.getUserData().then((response) {
      if (response.code == ResponseCode.Success) {
        AuthBloc.afterLogin().then(
            (value) => {Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false)});
      } else {
        Future.delayed(Duration(seconds: 1), () {
          _navigateToFirstRoute();
        });
      }
    });
  }

  _navigateToFirstRoute() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      SharedPref.checkIntroLimit() ? Routes.intro : Routes.login,
      (Route<dynamic> route) => false,
    );
  }
}
