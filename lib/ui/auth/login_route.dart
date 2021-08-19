import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/biometric_helper.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers.dart';
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
  double _maxHeight = 0.0;

  // Утасны дугаар
  TextEditingController _phoneNumberController = TextEditingController();
  FocusNode _phoneNumberFocusNode = FocusNode();

  // Нууц үг
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();
  bool _obscure = true;

  // Button login
  bool _isEnabledBtnLogin = false;

  // Biometrics
  bool isEnabledBtnBiometrics = false;
  bool _biometricAuth = false;
  bool _canCheckBiometrics = false;
  int _availableBiometrics = 0;

  // bool _loginByBiometric = false;

  @override
  void initState() {
    super.initState();

    // Biometric
    BlocManager.authBloc.add(InitBiometricsEvent());

    WidgetsBinding.instance?.addPostFrameCallback((_) => _init());
  }

  _init() {
    _phoneNumberController.addListener(() => _validateForm());
    _passwordController.addListener(() => _validateForm());

    // Phone number, pass
    _phoneNumberController.text = SharedPref.getPhoneNumber();
    _biometricAuth = SharedPref.getBiometricAuth();

    // todo test
    _phoneNumberController.text = '88989800';
    _passwordController.text = '123qwe';
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
    if (state is SetBiometrics) {
      _canCheckBiometrics = state.canCheckBiometrics;
      _availableBiometrics = state.availableBiometricsCount;
    } else if (state is LoginSuccess) {
      // Clear controllers
      _passwordController.clear();
      SharedPref.setPhoneNumber(_phoneNumberController.text);

      // globals.userData?.isOnboardingDone = false; // todo test

      if (globals.userData?.isOnboardingDone ?? false) {
        /// Go to home
        Navigator.pushNamed(context, Routes.home);
      } else {
        /// Go to chat
        Navigator.pushNamed(context, Routes.habidoAssistant);
      }
    } else if (state is LoginFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, button1Text: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, AuthState state) {
    return CustomScaffold(
      scaffoldKey: _loginKey,
      loading: state is AuthLoading,
      backgroundColor: customColors.primaryBackground,
      body: LayoutBuilder(builder: (context, constraints) {
        if (_maxHeight < constraints.maxHeight) _maxHeight = constraints.maxHeight;
        if (_maxHeight < SizeHelper.minHeightScreen) _maxHeight = SizeHelper.minHeightScreen;

        return SingleChildScrollView(
          child: Container(
            height: _maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container(), flex: 25),

                /// Logo
                _logo(),

                Expanded(child: Container(), flex: 25),

                Container(
                  padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, 35.0),
                  decoration: BoxDecoration(
                    color: customColors.secondaryBackground,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    children: [
                      /// Утасны дугаар
                      _txtboxPhoneNumber(),

                      /// Нууц үг
                      _txtboxPassword(),

                      // _chkboxBiometric(),

                      SizedBox(height: 30.0),

                      Row(
                        children: [
                          Expanded(
                            /// Нэвтрэх button
                            child: _btnLogin(),
                          ),

                          /// Finger print button
                          _btnBiometrics(),
                        ],
                      ),

                      MarginVertical(height: 25.0),

                      /// Button - Нууц үг мартсан уу? Сэргээх
                      _btnForgotPass(),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(color: customColors.secondaryBackground),
                  flex: 25,
                ),

                /// Button - Та бүртгэлтэй юу? Бүртгүүлэх
                _btnSignUp(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _logo() {
    return HeroHelper.getAppLogoWithName();
  }

  Widget _txtboxPhoneNumber() {
    return CustomTextField(
      style: CustomTextFieldStyle.secondary,
      controller: _phoneNumberController,
      focusNode: _phoneNumberFocusNode,
      maxLength: 8,
      textInputType: TextInputType.number,
      prefixAsset: Assets.username,
      hintText: LocaleKeys.phoneNumber,
      suffixAsset: Assets.clear,
      alwaysVisibleSuffix: false,
      onPressedSuffix: () {
        _phoneNumberController.clear();
      },
    );
  }

  Widget _txtboxPassword() {
    return CustomTextField(
      style: CustomTextFieldStyle.secondary,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      margin: EdgeInsets.only(top: 15.0),
      obscureText: true,
      prefixAsset: Assets.password,
      hintText: LocaleKeys.password,
      alwaysVisibleSuffix: false,
    );
  }

  _validateForm() {
    setState(() {
      _isEnabledBtnLogin = (Func.isValidPhoneNumber(_phoneNumberController.text) &&
          _passwordController.text.isNotEmpty &&
          _passwordController.text.length > 0);
    });
  }

  // Widget _chkboxBiometric() {
  //   return (_canCheckBiometrics && _availableBiometrics > 0)
  //       ? Chkbox(
  //           text: CustomText.useLocalAuth,
  //           isChecked: _biometricAuth,
  //           margin: EdgeInsets.only(top: 25.0),
  //           onChanged: (value) {
  //             setState(() {
  //               _biometricAuth = value;
  //             });
  //
  //             SharedPref.saveBiometricAuth(value);
  //           },
  //         )
  //       : Container();
  // }

  Widget _btnLogin() {
    return CustomButton(
      text: LocaleKeys.login,
      onPressed: () {
        if (!_isEnabledBtnLogin) return;

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
    return _canCheckBiometrics && _availableBiometrics > 0
        ? ButtonStadium(
            asset: Assets.biometric,
            margin: EdgeInsets.only(left: 15.0),
            size: 50.0,
            visibleBorder: true,
            iconColor: customColors.primary,
            onPressed: () {
              // FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard
              // if (SharedPref.getBiometricAuth()) {
              //   if (await _checkBiometrics()) {
              //     var loginRequest = LoginRequest(username: SharedPref.getPhoneNumber(), password: SharedPref.getPassword());
              //     _loginByBiometric = true;
              //     BlocProvider.of<AuthBloc>(context).add(Login(loginRequest));
              //   } else {
              //     print('failed');
              //   }
              // } else {
              //   showCustomDialog(
              //     context,
              //     dialogType: DialogType.error,
              //     bodyText: CustomText.useBiometricNotSaved,
              //     btnPositiveText: CustomText.ok,
              //   );
              // }
            },
          )
        : Container();
  }

  Future<bool> _checkBiometrics() async {
    bool didAuthenticate = false;
    try {
      /// Biometric
      BiometricHelper biometricHelper = new BiometricHelper();
      await biometricHelper.initBiometrics();
      if (await biometricHelper.checkBiometrics()) {
        didAuthenticate = true;
      } else {
        didAuthenticate = false;
      }
    } on PlatformException catch (e) {
      print(e);
      didAuthenticate = false;
    }

    return didAuthenticate;
  }

  Widget _btnForgotPass() {
    return ButtonText2(
      text1: LocaleKeys.haveYouForgottenYourPassword,
      text2: LocaleKeys.recover,
      textColor: customColors.secondaryText,
      alignment: Alignment.center,
      onPressed: () {
        Navigator.pushNamed(context, Routes.forgotPass);
      },
    );
  }

  Widget _btnSignUp() {
    return ButtonText2(
      text1: LocaleKeys.hasAccount,
      text2: LocaleKeys.signUp,
      backgroundColor: customColors.secondaryBackground,
      textColor: customColors.secondaryText,
      padding: EdgeInsets.symmetric(vertical: 35.0),
      onPressed: () {
        Navigator.pushNamed(context, Routes.signUp1Phone);
      },
    );
  }
}
