import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:url_launcher/url_launcher.dart';

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
        child: Container(
          child: SvgPicture.asset(
            Assets.appIcon,
            width: 60.0,
          ),
        ),
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
    //   bodyText: AppText.pleaseUpdateApp,
    //   dialogType: DialogType.warning,
    //   btnPositiveText: AppText.ok,
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
      _navigateToFirstRoute();
    }
  }

  _navigateToFirstRoute() {
    sharedPref?.clear(); // todo test

    Navigator.of(context).pushNamedAndRemoveUntil(
      SharedPref.checkIntroLimit() ? Routes.intro : Routes.login,
      (Route<dynamic> route) => false,
    );
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
    //     showCustomDialog(context, dialogType: DialogType.error, bodyText: AppText.failed, btnPositiveText: AppText.ok);
    //   }
    // } catch (e) {
    //   print(e);
    //   showCustomDialog(context, dialogType: DialogType.error, bodyText: AppText.failed, btnPositiveText: AppText.ok);
    // }
  }
}
