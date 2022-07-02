import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habido_app/bloc/authDialog_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/addOauth.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

void showAuthDialog(BuildContext context,
    {required Widget child, bool isDismissible = false}) {
  Func.hideKeyboard(context);

  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    isScrollControlled: false,
    builder: (BuildContext context) {
      return child;
    },
  );
}

class AuthDialog extends StatefulWidget {
  final Color? primaryColor;
  final String? asset;
  final String? text;
  final Widget? child;
  final String? buttonText;
  final int? skipCount;
  final VoidCallback? onPressedButton;
  final VoidCallback? onPressedButton2;

  AuthDialog(
      {Key? key,
      this.primaryColor,
      this.asset,
      this.text,
      this.buttonText,
      this.skipCount,
      this.onPressedButton,
      this.onPressedButton2,
      this.child})
      : super(key: key);

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.emailBloc,
      child: BlocListener<EmailBloc, EmailState>(
        listener: _blocListener,
        child: BlocBuilder<EmailBloc, EmailState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, EmailState state) {
    if (state is AddEmailSuccess) {
      Navigator.pop(context);
    } else if (state is LoginFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    }
  }

  @override
  Widget _blocBuilder(BuildContext context, EmailState state) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      decoration: new BoxDecoration(
        color: customColors.whiteBackground,
        borderRadius: new BorderRadius.only(
            topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(45.0),
              child: Column(
                children: [
                  /// Icon
                  Center(
                    child: CustomText(
                      LocaleKeys.oauthWarning,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      fontWeight: FontWeight.w500,
                      maxLines: 4,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialLoginBtn(context),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  /// Buttons
                  _buttons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialLoginBtn(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              _onGoogleAuth(context);
            },
            child: Image.asset(
              Assets.google_icon,
              width: 50,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              _onFacebookAuth(context);
            },
            child: Image.asset(
              Assets.fb_icon,
              width: 50,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              _onAppleAuth(context);
            },
            child: Image.asset(
              Assets.apple_icon,
              width: 50,
            ),
          ),
          SizedBox(width: 10.0),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    var gmail = 'Gmail';

    return InkWell(
        onTap: (() async {
          var request = AddOauth()
            ..email = null
            ..type = gmail;
          var res = await ApiManager.addOauth(request);
          if (res.code == ResponseCode.Success) {
            if (globals.userData!.oAuth2SkipCount == 0 ||
                globals.userData!.oAuth2SkipCount == 1 ||
                globals.userData!.oAuth2SkipCount == 2) {
              Navigator.pop(context);
            }
          }
        }),
        child: Container(
          width: ResponsiveFlutter.of(context).wp(60),
          height: ResponsiveFlutter.of(context).hp(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: customColors.greyBackground,
          ),
          child: CustomText(
            "Алгасах ${widget.skipCount}/3",
            alignment: Alignment.center,
          ),
        ));
  }

  Future<void> _onGoogleAuth(context) async {
    var gmail = 'Gmail';
    try {
      final GoogleSignIn _googleSignIn =
          GoogleSignIn(scopes: ['email'], hostedDomain: "", clientId: "");

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print("amjilttai:::::${googleUser}");

      var request = AddOauth()
        ..email = googleUser!.email
        ..type = gmail;
      BlocManager.emailBloc.add(AddEmailEvent(request));
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
        final requestData = await FacebookAuth.i.getUserData(
          fields: "email, name",
        );
        setState(() {
          userFbData = requestData;
        });
        print('user:::::::::::${userFbData}');
        var request = AddOauth()
          ..email = userFbData!['email']
          ..type = fb;
        BlocManager.emailBloc.add(AddEmailEvent(request));
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
        redirectUri:
            Uri.parse('https://api.dreamwod.app/auth/callbacks/apple-sign-in'),
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
