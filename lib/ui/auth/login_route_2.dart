import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/hero.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class LoginRoute2 extends StatelessWidget {
  const LoginRoute2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _loginKey = GlobalKey<ScaffoldState>();

    return CustomScaffold(
      scaffoldKey: _loginKey,
      padding: const EdgeInsets.symmetric(horizontal: SizeHelper.margin),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child:

                      /// HabiDo logo
                      HeroHelper.getAppLogoWithName(),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          CustomText(
                            LocaleKeys.login,
                            fontWeight: FontWeight.w700,
                            fontSize: 30.0,
                          ),

                          SizedBox(height: 40.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1.0,
                                  width: MediaQuery.of(context).size.width,
                                  color: customColors.grayBorder,
                                ),
                              ),
                              SizedBox(width: 5.5),
                              CustomText(
                                LocaleKeys.loginWithSocial,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: customColors.grayBorder,
                              ),
                              SizedBox(width: 5.5),
                              Expanded(
                                child: Container(
                                  height: 1.0,
                                  width: MediaQuery.of(context).size.width,
                                  color: customColors.grayBorder,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 40.0),

                          /// Google-ээр нэвтрэх
                          _socialLoginBtn(context, "google"),
                          SizedBox(height: 15.0),

                          /// Facebook-ээр нэвтрэх
                          _socialLoginBtn(context, "facebook"),

                          SizedBox(height: 15.0),

                          /// Apple-аар нэвтрэх
                          _socialLoginBtn(context, "apple"),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      '${LocaleKeys.hasNotAccount} ',
                      fontSize: 15.0,
                    ),
                    InkWell(
                      onTap: () {
                        _navigateToSignUp(context);
                      },
                      child: CustomText(
                        LocaleKeys.signUp,
                        fontSize: 15.0,
                        color: customColors.primary,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30.0)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _socialLoginBtn(BuildContext context, String type) {
    Map _googleData = {
      "social": LocaleKeys.loginWithGoogle,
      "icon": Assets.google,
      "backgroundColor": customColors.whiteBackground,
      "textColor": customColors.blackButtonContent,
    };

    Map _facebookData = {
      "social": LocaleKeys.loginWithFb,
      "icon": Assets.facebook,
      "backgroundColor": customColors.blueButtonBackground,
      "textColor": customColors.primaryButtonContent,
    };

    Map _appleData = {
      "social": LocaleKeys.loginWithApple,
      "icon": Assets.apple,
      "backgroundColor": customColors.blackButtonBackground,
      "textColor": customColors.primaryButtonContent,
    };

    Map _data = {"google": _googleData, "facebook": _facebookData, "apple": _appleData};

    return InkWell(
      onTap: () {
        type == "google"
            ? _onGoogleAuth(context)
            : type == "facebook"
                ? _onFacebookAuth(context)
                : _onAppleAuth(context);
      },
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: _data[type]["backgroundColor"],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            type == "apple" // todo svg dr error
                ? Image.asset(
                    _data[type]["icon"],
                    height: 24.0,
                    fit: BoxFit.contain,
                  )
                : SvgPicture.asset(
                    _data[type]["icon"],
                    height: 24.0,
                    fit: BoxFit.contain,
                  ),
            SizedBox(width: 10.0),
            CustomText(
              _data[type]["social"],
              color: _data[type]["textColor"],
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              fontSize: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  _navigateToSignUp(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.signUp, (Route<dynamic> route) => false);
  }

  _onGoogleAuth(context) {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
  }

  _onFacebookAuth(context) {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
  }

  _onAppleAuth(context) {
    print("apple");
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
  }
}
