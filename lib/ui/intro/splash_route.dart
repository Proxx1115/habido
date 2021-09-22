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

      // todo test
      // check version

      //   var buildVersion = await DeviceHelper.getBuildNumber();
      //   _showDialogUpdate('https://play.google.com/store/apps/details?id=mn.fr099y.optimal');
      //
      //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      //
      // }

      // if (Func.isNotEmpty(currentAppVersion) && param != null) {
      //   if (Platform.isAndroid && Func.isNotEmpty(param.androidVersion)) {
      //     if (Func.toInt(currentAppVersion) < Func.toInt(param.androidVersion)) {
      //       return;
      //     }
      //   } else if (Platform.isIOS && Func.isNotEmpty(param.iosVersion)) {
      //     if (Func.toInt(currentAppVersion) < Func.toInt(param.iosVersion)) {
      //       _showDialogUpdate('https://apps.apple.com/mn/app/zeely-by-optimal/id1419637942');
      //       return;
      //     }
      //   }
      // }
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
    // todo test
    // sharedPref?.clear();

    ApiManager.getUserData().then((response) {
      if (response.code == ResponseCode.Success) {
        AuthBloc.afterLogin().then(
            (value) => {Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false)});
      } else {
        // todo test
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

// _showDialogUpdate(String deepLink) {
//   showCustomDialog(
//     context,
//     dismissible: false,
//     bodyText: AppText.pleaseUpdateApp,
//     dialogType: DialogType.warning,
//     btnPositiveText: AppText.ok,
//     onPressedBtnPositive: () {
//       _navigateToFirstRoute();
//       _openDeeplink(deepLink);
//     },
//   );
// }
}
