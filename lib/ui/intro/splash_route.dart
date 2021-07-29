import 'package:flutter/material.dart';
import 'package:habido_app/ui/auth/login_route.dart';
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
    if (_needUpdate()) return;

    _checkSession();
  }

  bool _needUpdate() {
    bool res = false;

    try {
      // var param = await ApiManager.getParam();
      // var currentAppVersion = await DeviceHelper.getBuildNumber();
      // if (Func.isNotEmpty(currentAppVersion) && param != null) {
      //   if (Platform.isAndroid && Func.isNotEmpty(param.androidVersion)) {
      //     if (Func.toInt(currentAppVersion) < Func.toInt(param.androidVersion)) {
      //       _showDialogUpdate('https://play.google.com/store/apps/details?id=mn.fr099y.optimal');
      //       return;
      //     }
      //   } else if (Platform.isIOS && Func.isNotEmpty(param.iosVersion)) {
      //     if (Func.toInt(currentAppVersion) < Func.toInt(param.iosVersion)) {
      //       _showDialogUpdate('https://apps.apple.com/mn/app/zeely-by-optimal/id1419637942');
      //       return;
      //     }
      //   }
      //   }

    } catch (e) {
      print(e);
    }

    return res;
  }

  _showDialogNewVersion(String deepLink) {
    // showCustomDialog(
    //   context,
    //   dismissible: false,
    //   bodyText: CustomText.pleaseUpdateApp,
    //   dialogType: DialogType.warning,
    //   btnPositiveText: CustomText.ok,
    //   onPressedBtnPositive: () {
    //     _navigateToFirstRoute();
    //     _openDeeplink(deepLink);
    //   },
    // );
  }

  _checkSession() {
    /// User data
    // ApiManager.getUserData().then((response) {
    //   if (response.code == ResponseCode.Success) {
    if (false) {
      _navigateToHome();
    } else {
      // todo test
      Future.delayed(Duration(seconds: 1), () {
        _navigateToFirstRoute();
      });
    }
  }

  _navigateToFirstRoute() {
    if (SharedPref.checkIntroLimit()) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        SharedPref.checkIntroLimit() ? Routes.intro : Routes.login,
        (Route<dynamic> route) => false,
      );
    } else {
      HeroHelper.navigatePushReplacement(context: context, nextRoute: LoginRoute());
    }
  }

  _navigateToHome() {
    // AuthBloc.afterLogin();
    // Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);
  }

  _openDeeplink(String url) async {
    // try {
    //   // url = 'khanbank://q?qPay_QRcode=7729010259415096644150863802398062&object_type=&object_id='; // test
    //
    //   if (await canLaunch(url)) {
    //     await launch(url);
    //   } else {
    //     showCustomDialog(context, dialogType: DialogType.error, bodyText: CustomText.failed, btnPositiveText: CustomText.ok);
    //   }
    // } catch (e) {
    //   print(e);
    //   showCustomDialog(context, dialogType: DialogType.error, bodyText: CustomText.failed, btnPositiveText: CustomText.ok);
    // }
  }
}
