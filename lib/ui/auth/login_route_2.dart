import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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

class LoginRoute2 extends StatefulWidget {
  const LoginRoute2({Key? key}) : super(key: key);

  @override
  State<LoginRoute2> createState() => _LoginRoute2State();
}

class _LoginRoute2State extends State<LoginRoute2> {
  GoogleSignInAccount? currentUser;

  @override
  void initState() {
    super.initState();
    // _googleSignIn.onCurrentUserChanged.listen((account) {
    //   setState(() {
    //     currentUser = account;
    //   });
    // });
  }

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
    if (state is LoginSuccess) {
      if (globals.userData!.birthDay == null ||
          globals.userData!.gender == null ||
          globals.userData!.firstName == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.personalInfo, (Route<dynamic> route) => false);
      } else {
        if (globals.userData?.isOnboardingDone2 == false) {
          /// Go to home
          Navigator.pushNamed(context, Routes.home_new);
          print("home ruu userlee");
        } else {
          Navigator.pushNamed(context, Routes.home_new);
        }
      }
    } else if (state is LoginFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is SessionTimeoutState) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.login2, (Route<dynamic> route) => false);

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
    final _loginNewKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      bottom: false,
      top: true,
      child: CustomScaffold(
        onWillPop: () async => false,
        scaffoldKey: _loginNewKey,
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
                            _oldLogin(context),
                            SizedBox(height: 20.0),

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
                                  LocaleKeys.loginOr,
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

                            SizedBox(height: 20.0),

                            /// Google-ээр нэвтрэх
                            _socialLoginBtn(context, "google"),
                            SizedBox(height: 15.0),

                            /// Facebook-ээр нэвтрэх
                            _socialLoginBtn(context, "facebook"),

                            SizedBox(height: 15.0),

                            /// Apple-аар нэвтрэх
                            Platform.isIOS
                                ? _socialLoginBtn(context, "apple")
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            )
          ],
        ),
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

    Map _data = {
      "google": _googleData,
      "facebook": _facebookData,
      "apple": _appleData
    };

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

  Widget _oldLogin(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.login,
        );
      },
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: customColors.primary,
              width: 1,
            ),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              LocaleKeys.phoneNumber,
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
    Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.signUp, (Route<dynamic> route) => false);
  }

  Future<void> _onGoogleAuth(context) async {
    var gmail = 'Gmail';
    try {
      final GoogleSignIn _googleSignIn =
          GoogleSignIn(scopes: ['email'], hostedDomain: "");

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
      final result =
          await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
      if (result.status == LoginStatus.success) {
        final requestData = await FacebookAuth.i.getUserData();
        setState(() {
          userFbData = requestData;
        });
        print('user:::::::::::${userFbData!['email']}');
        var request = AddOauth()
          ..email = userFbData!['email']
          ..type = fb;
        print("auth req::::::::::::${request.toJson()}");

        BlocManager.oauthBloc.add(LoginEvent(request));
      } else {
        print("result::::::::::${result.status}");
        print("result::::::::::${result.message}");
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
    );
    final provider = OAuthProvider('apple.com');
    final cred = provider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );
    await FirebaseAuth.instance.signInWithCredential(cred);
    String? token = credential.identityToken;

    String normalizedSource = base64Url.normalize(token!.split(".")[1]);
    dynamic payload =
        jsonDecode(utf8.decode(base64Url.decode(normalizedSource)));
    print("token::::::::$payload");

    var apple = 'AppleId';
    // print('user:::::::::::${credential.identityToken}');
    var request = AddOauth()
      ..email = payload['email']
      ..type = apple;
    print("userData::::::::::::::::::$request");

    BlocManager.oauthBloc.add(LoginEvent(request));
  }
}
