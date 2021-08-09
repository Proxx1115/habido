import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/sign_up_request.dart';
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

class SignUpRoute extends StatefulWidget {
  @override
  _SignUpRouteState createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
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

    // todo test
    _controller.text = '99887766';
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
      Navigator.pushNamed(context, Routes.verifyCode, arguments: {
        'signUpResponse': state.response,
      });
    } else if (state is SignUpFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, button1Text: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, AuthState state) {
    return CustomScaffold(
      scaffoldKey: _signUpKey,
      appBarTitle: LocaleKeys.yourRegistration,
      padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
      loading: state is AuthLoading,
      body: Column(
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
      asset: Assets.arrow_next,
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
