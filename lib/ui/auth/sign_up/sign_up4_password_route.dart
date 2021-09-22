import 'package:flutter/material.dart';
import 'package:habido_app/models/gender.dart';
import 'package:habido_app/models/sign_up_register_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/date_picker.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/switch.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

/// Sign up step 4
class SignUp4PasswordRoute extends StatefulWidget {
  final SignUpRegisterRequest signUpRegisterRequest;

  const SignUp4PasswordRoute({Key? key, required this.signUpRegisterRequest}) : super(key: key);

  @override
  _SignUp4PasswordRouteState createState() => _SignUp4PasswordRouteState();
}

class _SignUp4PasswordRouteState extends State<SignUp4PasswordRoute> {
  // UI
  final _signUp4PasswordKey = GlobalKey<ScaffoldState>();
  double _maxHeight = 0.0;
  double _minHeight = 600;

  // Нууц үг
  final _pssController = TextEditingController();
  final _pssFocus = FocusNode();

  // Нууц үг давтах
  final _pssRepeatController = TextEditingController();
  final _pssRepeatFocus = FocusNode();

  // Button next
  bool _enabledBtnNext = false;

  @override
  void initState() {
    super.initState();
    _pssController.addListener(() => _validateForm());
    _pssRepeatController.addListener(() => _validateForm());
  }

  @override
  void dispose() {
    // _pssController.dispose();
    // _pssRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);

    return CustomScaffold(
      scaffoldKey: _signUp4PasswordKey,
      appBarTitle: LocaleKeys.yourRegistration,
      child: LayoutBuilder(builder: (context, constraints) {
        if (_maxHeight < constraints.maxHeight) _maxHeight = constraints.maxHeight;
        if (_maxHeight < _minHeight) _maxHeight = _minHeight;

        return SingleChildScrollView(
          child: Container(
            height: _maxHeight,
            padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
            child: Column(
              children: [
                /// Нэвтрэх нууц үг үүсгэнэ үү
                CustomText(
                  LocaleKeys.createPassword,
                  alignment: Alignment.center,
                  maxLines: 2,
                ),

                /// Нууц үг
                _passwordTextField(),

                /// Нууц үг давтах
                _passwordRepeatTextField(),

                Expanded(child: Container()),

                /// Button next
                _buttonNext(),
                //_enabledBtnNext
              ],
            ),
          ),
        );
      }),
    );
  }

  _passwordTextField() {
    return CustomTextField(
      controller: _pssController,
      focusNode: _pssFocus,
      hintText: LocaleKeys.password,
      obscureText: true,
      margin: EdgeInsets.only(top: 35.0),
    );
  }

  _passwordRepeatTextField() {
    return CustomTextField(
      controller: _pssRepeatController,
      focusNode: _pssRepeatFocus,
      hintText: LocaleKeys.passwordRepeat,
      obscureText: true,
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = _pssController.text.length > 0 && _pssRepeatController.text.length > 0;
    });
  }

  _buttonNext() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      asset: Assets.long_arrow_next,
      margin: EdgeInsets.only(top: 35.0),
      onPressed: _enabledBtnNext
          ? () {
              // Validation
              if (_pssController.text != _pssRepeatController.text) {
                showCustomDialog(
                  context,
                  child: CustomDialogBody(
                      asset: Assets.error, text: LocaleKeys.passwordsDoesNotMatch, buttonText: LocaleKeys.ok),
                );

                return;
              }

              SignUpRegisterRequest verifyCodeRequest = widget.signUpRegisterRequest;
              verifyCodeRequest.password = _pssController.text;

              Navigator.pushNamed(context, Routes.signUp5Terms, arguments: {
                'signUpRegisterRequest': verifyCodeRequest,
              });
            }
          : null,
    );
  }
}
