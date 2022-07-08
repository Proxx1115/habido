import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/ui/auth/login_route.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/http_utils.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/biometrics_util.dart';
import 'package:habido_app/utils/device_helper.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/hero.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashRoute extends StatefulWidget {
  @override
  _SplashRouteState createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
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
    // Init biometrics
    await biometricsUtil.init();

    // Check update
    // try {
    //   var param = await ApiManager.param();
    //   var currentAppVersion = await DeviceHelper.getBuildNumber();
    //   if (Func.isNotEmpty(currentAppVersion) && param != null) {
    //     if (Platform.isAndroid && Func.isNotEmpty(param.androidVersion)) {
    //       if (Func.toInt(currentAppVersion) < Func.toInt(param.androidVersion)) {
    //         _showDialogUpdate('https://play.google.com/store/apps/details?id=mn.app.habido_app');
    //         return;
    //       }
    //     } else if (Platform.isIOS && Func.isNotEmpty(param.iosVersion)) {
    //       if (Func.toInt(currentAppVersion) < Func.toInt(param.iosVersion)) {
    //         _showDialogUpdate('https://apps.apple.com/mn/app/habido/id1579996644');
    //         return;
    //       }
    //     }
    //   }
    // } catch (e) {
    //   print(e);
    // }

    _checkSession();
  }

  _checkSession() {
    ApiManager.getUserData().then((userData) async {
      if (userData.code == ResponseCode.Success) {
        await AuthBloc.afterLogin();
        if (globals.userData!.birthDay == null ||
            globals.userData!.gender == null ||
            globals.userData!.firstName == null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.personalInfo, (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.home_new, (Route<dynamic> route) => false);
        }

        /// Go to home

      } else {
        Future.delayed(Duration(seconds: 1), () {
          _navigateToFirstRoute();
        });
      }
    });
  }

  _showDialogUpdate(String deepLink) {
    // showCustomDialog(
    //   context,
    //   dismissible: false,
    //   bodyText: LocaleKeys.pleaseUpdateApp,
    //   dialogType: DialogType.warning,
    //   btnPositiveText: AppText.ok,
    //   onPressedBtnPositive: () {
    //     _navigateToFirstRoute();
    //     _openDeeplink(deepLink);
    //   },
    // );
  }

  _navigateToFirstRoute() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      SharedPref.checkIntroLimit()
          ? Routes.intro
          : Routes.login2, // signUpQuestion loginIntro
      (Route<dynamic> route) => false,
    );
  }
  // _openDeeplink(String url) async {
  //   try {
  //     // url = 'khanbank://q?qPay_QRcode=7729010259415096644150863802398062&object_type=&object_id='; // test
  //
  //     if (await canLaunch(url)) {
  //       await launch(url);
  //     } else {
  //       showCustomDialog(context, dialogType: DialogType.error, bodyText: AppText.failed, btnPositiveText: AppText.ok);
  //     }
  //   } catch (e) {
  //     print(e);
  //     showCustomDialog(context, dialogType: DialogType.error, bodyText: AppText.failed, btnPositiveText: AppText.ok);
  //   }
  // }
}
