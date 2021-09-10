import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/sign_up_request.dart';
import 'package:habido_app/models/verify_code_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

/// Sign up step 1
class SignUp1PhoneRoute extends StatefulWidget {
  @override
  _SignUp1PhoneRouteState createState() => _SignUp1PhoneRouteState();
}

class _SignUp1PhoneRouteState extends State<SignUp1PhoneRoute> {
  // UI
  final _signUp1PhoneKey = GlobalKey<ScaffoldState>();

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
    _controller.dispose();
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
      var verifyCodeRequest = VerifyCodeRequest()
        ..userId = state.response.userId
        ..phoneNumber = _controller.text;

      Navigator.pushNamed(context, Routes.signUp2Code, arguments: {
        'verifyCodeRequest': verifyCodeRequest,
      });
    } else if (state is SignUpFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, AuthState state) {
    return CustomScaffold(
      scaffoldKey: _signUp1PhoneKey,
      appBarTitle: LocaleKeys.yourRegistration,
      padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
      loading: state is AuthLoading,
      child: Column(
        children: [
          /// Та өөрийн утасны дугаараа оруулна уу.
          CustomText(LocaleKeys.enterPhoneNumber, alignment: Alignment.center, maxLines: 2),

          /// Утасны дугаар
          _phoneNumberTextField(),

          Spacer(),

          /// Button next
          _buttonNext(),
        ],
      ),
    );
  }

  _phoneNumberTextField() {
    return CustomTextField(
      controller: _controller,
      focusNode: _focusNode,
      hintText: LocaleKeys.phoneNumber,
      margin: EdgeInsets.only(top: 35.0),
      maxLength: 8,
      textInputType: TextInputType.number,
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = Func.isValidPhoneNumber(_controller.text);
    });
  }

  _buttonNext() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      asset: Assets.long_arrow_next,
      onPressed: _enabledBtnNext
          ? () {
              Func.hideKeyboard(context);

              var request = SignUpRequest()..phone = _controller.text;
              BlocManager.authBloc.add(SignUpEvent(request));
            }
          : null,
    );
  }
}
