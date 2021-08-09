import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/sign_up_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class VerifyCodeRoute extends StatefulWidget {
  final SignUpResponse? signUpResponse;

  const VerifyCodeRoute({Key? key, this.signUpResponse}) : super(key: key);

  @override
  _VerifyCodeRouteState createState() => _VerifyCodeRouteState();
}

class _VerifyCodeRouteState extends State<VerifyCodeRoute> {
  // UI
  final _signUpKey = GlobalKey<ScaffoldState>();

  // Утасны дугаар
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  // Button next
  bool _enabledBtnNext = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _validateForm());
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
    if (state is SignUpSuccess) {
      // Navigator.pushNamed(context, Routes.forgotPass);
    } else if (state is SignUpFailed) {
      // todo test
      // showCustomDialog(
      //   context,
      //   bodyText: state.message,
      //   dialogType: DialogType.warning,
      //   onPressedBtnPositive: () {},
      //   btnPositiveText: CustomText.ok,
      // );
    }

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
    // }
    // else if (state is LoginFailed) {
    //   _loginByBiometric = false;
    //
    //   showCustomDialog(context,
    //       bodyText: state.message, dialogType: DialogType.warning, onPressedBtnPositive: () {}, btnPositiveText: CustomText.ok);
    // }
  }

  Widget _blocBuilder(BuildContext context, AuthState state) {
    return CustomScaffold(
      scaffoldKey: _signUpKey,
      appBarTitle: LocaleKeys.yourRegistration,
      padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
      body: Column(
        children: [
          /// Та өөрийн утасны дугаараа оруулна уу.
          CustomText(LocaleKeys.enterPhoneNumber, alignment: Alignment.center, maxLines: 2),

          /// Утасны дугаар
          CustomTextField(
            controller: _controller,
            focusNode: _focusNode,
            hintText: LocaleKeys.phoneNumber,
            margin: EdgeInsets.only(top: 35.0),
            maxLength: 8,
            textInputType: TextInputType.number,
          ),

          Spacer(),

          /// Button next
          CustomButton(
            style: CustomButtonStyle.Secondary,
            asset: Assets.arrow_next,
            onPressed: _enabledBtnNext
                ? () {
                    // Api
                  }
                : null,
          ), //_enabledBtnNext
        ],
      ),
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = Func.isValidPhoneNumber(_controller.text);
    });
  }
}
