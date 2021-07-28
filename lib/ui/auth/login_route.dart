import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/biometric_helper.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/chkbox.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:habido_app/widgets/txt.dart';

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

  // String _phoneError;

  // Нууц үг
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();

  // Checkboxes
  bool _useBiometric = false;

  // Button biometrics
  bool _canCheckBiometrics = false;

  // Button login
  bool _loginByBiometric = false;

  @override
  void initState() {
    super.initState();

    // Biometric
    // BlocProvider.of<AuthBloc>(context).add(InitBiometricsEvent());

    // Phone number, pass
    _phoneNumberController.text = SharedPref.getPhoneNumber();
    _useBiometric = SharedPref.getBiometricAuth();
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
    // if (state is SetBiometrics) {
    //   _canCheckBiometrics = state.canCheckBiometrics;
    // }

    // else if (state is LoginSuccess) {
    //   globals.sessionToken = state.response.token;
    //
    //   SharedPref.saveBiometricAuth(_phoneController.text);
    //   if (!_loginByBiometric) SharedPref.savePassword(_useBiometric ? _passwordController.text : "");
    //   SharedPref.saveUseBiometrics(_useBiometric);
    //
    //   _passwordController.text = '';
    //
    //   _loginByBiometric = false;
    //   Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);
    // } else if (state is LoginFailed) {
    //   _loginByBiometric = false;
    //
    //   showCustomDialog(context,
    //       bodyText: state.message, dialogType: DialogType.warning, onPressedBtnPositive: () {}, btnPositiveText: CustomText.ok);
    // }
  }

  Widget _blocBuilder(BuildContext context, AuthState state) {
    return BlurLoadingContainer(
      loading: state is AuthLoading,
      child: Scaffold(
        key: _loginKey,
        appBar: AppBarEmpty(context: context),
        backgroundColor: customColors.backgroundRoseWhite,
        body: GestureDetector(
          onTap: () {
            Func.hideKeyboard(context);
          },
          child: LayoutBuilder(builder: (context, constraints) {
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
                        color: customColors.backgroundWhite,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      child: Column(
                        children: [
                          /// Утасны дугаар
                          _txtPhoneNumber(),

                          SizedBox(height: 14.0),

                          /// Нууц үг
                          _txtPassword(),

                          SizedBox(height: 18.0),

                          /// Цаашид хурууны хээгээр нэвтрэх
                          _chkBiometric(),

                          SizedBox(height: 18.0),

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
                      child: Container(color: customColors.backgroundWhite),
                      flex: 25,
                    ),

                    /// Button - Та бүртгэлтэй юу? Бүртгүүлэх
                    _btnSignUp(),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.0),
      child: SvgPicture.asset(
        Assets.app_icon_name,
        height: 45.0,
        width: 205.0,
      ),
    );
  }

  Widget _txtPhoneNumber() {
    return Txtbox(
      context: context,
      controller: _phoneNumberController,
      focusNode: _phoneNumberFocusNode,
      hintText: CustomText.phoneNumber,
      maxLength: 8,
      textInputType: TextInputType.number,
    );
  }

  Widget _txtPassword() {
    return Txtbox(
      context: context,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      hintText: CustomText.password,
    );
  }

  Widget _chkBiometric() {
    return Chkbox(
      text: CustomText.useLocalAuth,
      onChanged: (value) {
        _useBiometric = value;
        setState(() {});
      },
      isChecked: _useBiometric,
    );
  }

  Widget _btnLogin() {
    return Btn(
      text: CustomText.login,
      onPressed: (Func.isValidPhoneNumber(_phoneNumberController.text) &&
              _passwordController.text.isNotEmpty &&
              _passwordController.text.length > 5)
          ? _onPressedBtn
          : null,
    );
  }

  Widget _btnBiometrics() {
    return _canCheckBiometrics
        ? BtnBordered(
            asset: Assets.biometric,
            margin: EdgeInsets.only(left: 15.0),
            onPressed: () {
              _onPressedBtnBiometrics();
            },
          )
        : Container();
  }

  void _onPressedBtnBiometrics() async {
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
  }

  Future<bool> _checkBiometrics() async {
    bool didAuthenticate = false;
    try {
      /// Biometric
      BiometricHelper biometricHelper = new BiometricHelper();
      await biometricHelper.initBiometric();
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

  void _onPressedBtn() async {
    LoginRequest request = LoginRequest();
    request.username = _phoneNumberController.text;
    request.password = _passwordController.text;

    // BlocProvider.of<AuthBloc>(context).add(LoginEvent(request));

    // if (_useBiometric) {
    //   if (await _checkBiometrics()) {
    //     BlocProvider.of<AuthBloc>(context).add(SignIn(request));
    //   } else {
    //     showCustomDialog(
    //       context,
    //       dialogType: DialogType.error,
    //       text: CustomText.useBiometricError,
    //       btnPositiveText: CustomText.ok,
    //     );
    //   }
    // } else {
    //   BlocProvider.of<AuthBloc>(context).add(SignIn(request));
    // }
  }

  Widget _btnForgotPass() {
    return BtnTxtMulti(
      text1: CustomText.haveYouForgottenYourPassword,
      text2: CustomText.recover,
      textColor: customColors.txtGrey,
      alignment: Alignment.center,
      onPressed: () {
        Navigator.pushNamed(context, Routes.forgotPass);
      },
    );
  }

  Widget _btnSignUp() {
    return BtnTxtMulti(
      text1: CustomText.hasAccount,
      text2: CustomText.signUp,
      backgroundColor: customColors.backgroundWhite,
      textColor: customColors.txtGrey,
      padding: EdgeInsets.symmetric(vertical: 35.0),
      onPressed: () {
        Navigator.pushNamed(context, Routes.signUp);
      },
    );
  }

// Widget _logoItem() {
//   return Container(
//     child: Column(
//       children: [
//         Hero(
//           tag: "splashIcon",
//           child: Image.asset(
//             Assets.logo_small,
//             height: 120,
//           ),
//         ),
//         SizedBox(height: 20),
//         Txt(
//           CustomText.appTitle,
//           style: lblStyle.appTile,
//           fontFamily: FontAsset.taurus,
//           alignment: Alignment.center,
//         )
//       ],
//     ),
//   );
// }
}
