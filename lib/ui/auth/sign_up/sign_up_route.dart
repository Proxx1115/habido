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

class SignUpRoute extends StatelessWidget {
  const SignUpRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _signUpKey = GlobalKey<ScaffoldState>();

    return CustomScaffold(
      scaffoldKey: _signUpKey,
      child: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: SvgPicture.asset(
                  Assets.sign_up,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: SizeHelper.margin),
                  child: Column(
                    children: [
                      CustomText(
                        LocaleKeys.signUp,
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
                            LocaleKeys.signUpWithSocial,
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
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    '${LocaleKeys.hasAccount} ',
                    fontSize: 15.0,
                  ),
                  InkWell(
                    onTap: () {
                      _navigateToLogin(context);
                    },
                    child: CustomText(
                      LocaleKeys.login,
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
      ]),
    );
  }

  Widget _socialLoginBtn(BuildContext context, String type) {
    Map _googleData = {
      "social": LocaleKeys.loginWithGoogle,
      "icon": Assets.google,
      "backgroundColor": customColors.whiteBackground,
      "textColor": customColors.blackButtonContent
    };

    Map _facebookData = {
      "social": LocaleKeys.loginWithFb,
      "icon": Assets.facebook,
      "backgroundColor": customColors.blueButtonBackground,
      "textColor": customColors.primaryButtonContent
    };

    Map _appleData = {
      "social": LocaleKeys.loginWithApple,
      "icon": Assets.apple,
      "backgroundColor": customColors.blackButtonBackground,
      "textColor": customColors.primaryButtonContent
    };

    Map _data = {"google": _googleData, "facebook": _facebookData, "apple": _appleData};

    return InkWell(
      onTap: () {
        type == "google"
            ? _onGoogleAuth()
            : type == "facebook"
                ? _onFacebookAuth()
                : _onAppleAuth();
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

  _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login2, (Route<dynamic> route) => false);
  }

  _onGoogleAuth() {
    // todo
    print("google");
  }

  _onFacebookAuth() {
    // todo
    print("fb");
  }

  _onAppleAuth() {
    // todo
    print("apple");
  }
}
