import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/oauth2_bloc.dart';
import 'package:habido_app/models/addOauth.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/hero.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({Key? key}) : super(key: key);

  @override
  State<SignUpRoute> createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.oauthBloc,
      child: BlocListener<OAuthBloc, OAuthState>(
        listener: _blocListener,
        child: BlocBuilder<OAuthBloc, OAuthState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, OAuthState state) {
    print("state::::::::::::$state");
    if (state is LoginSuccess) {
      if (globals.userData?.isOnboardingDone == false) {
        print("amjilttai ${globals.userData}");

        /// Go to home
        Navigator.pushNamed(context, Routes.home_new);

        /// Go to chat
        // Navigator.pushNamed(context, Routes.habidoAssistant);
      }
    } else if (state is LoginFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is SessionTimeoutState) {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.login2, (Route<dynamic> route) => false);

      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: LocaleKeys.sessionExpired,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {},
        ),
      );
    }
  }

  @override
  Widget _blocBuilder(BuildContext context, OAuthState state) {
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

                      /// Google-?????? ??????????????
                      _socialLoginBtn(context, "google"),
                      SizedBox(height: 15.0),

                      /// Facebook-?????? ??????????????
                      _socialLoginBtn(context, "facebook"),

                      SizedBox(height: 15.0),

                      /// Apple-?????? ??????????????
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

  _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login2, (Route<dynamic> route) => false);
  }

  Future<void> _onGoogleAuth(context) async {
    var gmail = 'Gmail';
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'], hostedDomain: "", clientId: "");

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print("amjilttai:::::${googleUser}");
      print('email:::::::::::${googleUser!.email}');

      var request = AddOauth()
        ..email = googleUser.email
        ..type = gmail;
      BlocManager.oauthBloc.add(LoginEvent(request));
    } catch (e) {
      print('Googleer newterch chadsangvi::::::$e');
    }
  }

  Future<void> _onFacebookAuth(context) async {
    try {
      Map? userFbData;
      var fb = 'Facebook';
      final result = await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
      if (result.status == LoginStatus.success) {
        final requestData = await FacebookAuth.i.getUserData(
          fields: "email, name",
        );
        setState(() {
          userFbData = requestData;
        });
        print('user:::::::::::${userFbData}');
        print('user:::::::::::${userFbData!['email']}');

        var request = AddOauth()
          ..email = userFbData!['email']
          ..type = fb;
        BlocManager.oauthBloc.add(LoginEvent(request));
      }
    } catch (e) {
      print("Fb bolohgvi bna $e");
    }
  }

  Future<void> _onAppleAuth(context) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        redirectUri: Uri.parse('https://api.dreamwod.app/auth/callbacks/apple-sign-in'),
        clientId: 'com.dreamwod.app.login',
      ),
    );

    var apple = 'AppleId';
    print('user:::::::::::${credential.email}');
    var request = AddOauth()
      ..email = credential.email
      ..type = apple;
    var res = await ApiManager.addOauth(request);

    if (res.code == ResponseCode.Success) {
      print("Amjilttai email nemlee");
      Navigator.pop(context);
    } else {
      print("mail nemj chadsangvi${res}");
    }
  }
}
