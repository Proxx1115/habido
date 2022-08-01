import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/biometrics_util.dart';
import 'package:habido_app/utils/device_helper.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/hero.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  // UI
  final _loginKey = GlobalKey<ScaffoldState>();
  double _height = 0.0;

  // Утасны дугаар
  TextEditingController _phoneNumberController = TextEditingController();
  FocusNode _phoneNumberFocusNode = FocusNode();

  // Нууц үг
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();

  // Button login
  bool _enabledButtonLogin = false;

  // Biometrics
  bool _visibleButtonBiometrics = false;

  @override
  void initState() {
    super.initState();

    _phoneNumberController.addListener(() => _validateForm());
    _passwordController.addListener(() => _validateForm());

    // Phone number, pass
    _phoneNumberController.text = SharedPref.getPhoneNumber();
    _visibleButtonBiometrics =
        SharedPref.getBiometricAuth(_phoneNumberController.text);

    // todo test
    // _phoneNumberController.text = '88989800';
    // _passwordController.text = '123qwe';
    // _phoneNumberController.text = '95688910';
    // _passwordController.text = '123qwe';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: _blocListener,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AuthState state) {
    if (state is LoginSuccess) {
      // Clear controllers
      _passwordController.clear();
      SharedPref.setPhoneNumber(_phoneNumberController.text);

      if (globals.userData?.isOnboardingDone2 ?? false) {
        // Go to home
        Navigator.pushNamed(context, Routes.home_new);
      } else {
        // Go to chat
        Navigator.pushNamed(context, Routes.signUpQuestion);
      }

      // if (globals.userData?.isOnboardingDone ?? false) {
      //   /// Go to home
      //   Navigator.pushNamed(context, Routes.home_new); // todo home
      // } else {
      //   /// Go to chat
      //   Navigator.pushNamed(context, Routes.habidoAssistant);
      // }
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
          Routes.login, (Route<dynamic> route) => false);

      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: LocaleKeys.sessionExpired,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {},
        ),
      );
    } else if (state is BiometricsChangedState) {
      _visibleButtonBiometrics = state.biometricsAuth;
    }
  }

  Widget _blocBuilder(BuildContext context, AuthState state) {
    return CustomScaffold(
      scaffoldKey: _loginKey,
      loading: state is AuthLoading,
      backgroundColor: customColors.primaryBackground,
      child: LayoutBuilder(builder: (context, constraints) {
        if (_height < constraints.maxHeight) _height = constraints.maxHeight;
        if (_height < SizeHelper.minHeightScreen)
          _height = SizeHelper.minHeightScreen;

        return SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: _height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container(), flex: 25),

                /// HabiDo logo
                HeroHelper.getAppLogoWithName(),

                Expanded(child: Container(), flex: 25),

                Container(
                  padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, 35.0),
                  decoration: BoxDecoration(
                    color: customColors.whiteBackground,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    children: [
                      /// Утасны дугаар
                      _phoneNumberTextField(),

                      /// Нууц үг
                      _passwordTextField(),

                      SizedBox(height: 15.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _btnForgotPass(),
                        ],
                      ),

                      SizedBox(height: 15.0),

                      Row(
                        children: [
                          Expanded(
                            /// Нэвтрэх button
                            child: _btnLogin(),
                          ),

                          /// Biometrics button
                          _btnBiometrics(),
                        ],
                      ),

                      MarginVertical(height: 10.0),
                      _btnSignUp(),

                      /// Button - Нууц үг мартсан уу? Сэргээх
                      // _btnForgotPass(),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(color: customColors.whiteBackground),
                  flex: 25,
                ),

                /// Button - Та бүртгэлтэй юу? Бүртгүүлэх
                // _btnSignUp(),
                Container(
                  height: 120,
                  color: customColors.whiteBackground,
                  // margin: EdgeInsets.symmetric(vertical: 35.0),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _phoneNumberTextField() {
    return CustomTextField(
      style: CustomTextFieldStyle.secondary,
      controller: _phoneNumberController,
      focusNode: _phoneNumberFocusNode,
      // maxLength: 8,
      keyboardType: TextInputType.text,
      prefixAsset: Assets.username,
      hintText: LocaleKeys.phoneNumber,
    );
  }

  Widget _passwordTextField() {
    return CustomTextField(
      style: CustomTextFieldStyle.secondary,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      margin: EdgeInsets.only(top: 15.0),
      obscureText: true,
      prefixAsset: Assets.password,
      hintText: LocaleKeys.password,
    );
  }

  _validateForm() {
    setState(() {
      _enabledButtonLogin =
          (Func.isValidPhoneNumber(_phoneNumberController.text) &&
              _passwordController.text.isNotEmpty &&
              _passwordController.text.length > 0);
    });
  }

  Widget _btnLogin() {
    return CustomButton(
      text: LocaleKeys.login,
      onPressed: () {
        if (!_enabledButtonLogin) return;

        LoginRequest request = LoginRequest();
        request.username = _phoneNumberController.text;
        request.password = _passwordController.text;
        request.isBiometric = false;
        request.deviceId = 'Emulator iPhone 12';

        BlocManager.authBloc.add(LoginEvent(request));
      },
    );
  }

  Widget _btnBiometrics() {
    return (_visibleButtonBiometrics &&
            biometricsUtil.canCheckBiometrics &&
            biometricsUtil.availableBiometricsCount > 0)
        ? ButtonStadium(
            asset: Assets.biometric,
            margin: EdgeInsets.only(left: 15.0),
            size: 50.0,
            visibleBorder: true,
            iconColor: customColors.primary,
            onPressed: () async {
              Func.hideKeyboard(context);

              if (await biometricsUtil.checkBiometrics()) {
                /// Biometrics authentication
                var request = LoginRequest();
                request.username = _phoneNumberController.text;
                request.password = _passwordController.text;
                request.isBiometric = true;
                request.deviceId = DeviceHelper.deviceId;

                BlocManager.authBloc.add(LoginEvent(request));
              } else {
                /// Биометрээр нэвтрэх үйлдэл амжилтгүй боллоо. Дахин оролдоно уу.
                showCustomDialog(
                  context,
                  child: CustomDialogBody(
                    asset: Assets.error,
                    text: LocaleKeys.biometricFailed,
                    buttonText: LocaleKeys.ok,
                  ),
                );
              }
            },
          )
        : Container();
  }

  Widget _btnForgotPass() {
    return ButtonMultiPartText(
      text1: "",
      text2: LocaleKeys.resetPassword,
      textColor: customColors.greyText,
      alignment: Alignment.center,
      onPressed: () {
        Navigator.pushNamed(context, Routes.forgotPass);
      },
    );
  }

  Widget _btnSignUp() {
    return ButtonMultiPartText(
      text1: "",
      text2: LocaleKeys.back,
      backgroundColor: customColors.whiteBackground,
      textColor: customColors.greyText,
      padding: EdgeInsets.symmetric(vertical: 15.0),
      onPressed: () {
        Navigator.popUntil(context, ModalRoute.withName(Routes.login2));
      },
    );
  }
}
