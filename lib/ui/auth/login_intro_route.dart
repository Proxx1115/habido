import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/hero.dart';
import 'package:habido_app/widgets/scaffold.dart';

class LoginIntroRoute extends StatelessWidget {
  const LoginIntroRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _loginIntroKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: CustomScaffold(
        scaffoldKey: _loginIntroKey,
        child: Column(
          children: [
            Expanded(
              child:

                  /// HabiDo logo
                  HeroHelper.getAppLogoWithText(),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: SizeHelper.margin),
                  child: SvgPicture.asset(
                    Assets.login_intro,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                  )),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: LocaleKeys.login,
                    isBordered: true,
                    onPressed: () {
                      _navigateToLogin(context);
                    },
                    borderRadius: BorderRadius.circular(15.0),
                    margin: EdgeInsets.symmetric(horizontal: 58.0),
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login2, (Route<dynamic> route) => false);
  }

  _navigateToSignUp(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.signUp, (Route<dynamic> route) => false);
  }
}
