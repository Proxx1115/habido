import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/change_password_request.dart';
import 'package:habido_app/models/forgot_password_change_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class ForgotPasswordChangeRoute extends StatefulWidget {
  final int userId;
  final String phoneNumber;
  final String code;

  const ForgotPasswordChangeRoute({
    Key? key,
    required this.userId,
    required this.phoneNumber,
    required this.code,
  }) : super(key: key);

  @override
  _ForgotPasswordChangeRouteState createState() => _ForgotPasswordChangeRouteState();
}

class _ForgotPasswordChangeRouteState extends State<ForgotPasswordChangeRoute> {
  // Нууц үг
  final _pController = TextEditingController(); // Бусад dispose хийгдээгүй TextField-үүдээс нэрийг нь өөр өгөх хэрэгтэй

  // Нууц үг давтах
  final _pRepeatController = TextEditingController();

  // Button save
  bool _enabledBtnSave = false;

  @override
  void initState() {
    super.initState();
    _pController.addListener(() => _validateForm());
    _pRepeatController.addListener(() => _validateForm());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: _blocListener,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return CustomScaffold(
              appBarTitle: LocaleKeys.resetPassword,
              loading: state is AuthLoading,
              child: Container(
                padding: SizeHelper.paddingScreen,
                child: Column(
                  children: [
                    /// Шинэ нууц үг
                    _passTextField(),

                    /// Шинэ нууц үг давтах
                    _passRepeatTextField(),

                    Expanded(child: Container()),

                    /// Button save
                    _buttonSave(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AuthState state) {
    if (state is ForgotPasswordChangeSuccess) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.success,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      );
    } else if (state is ForgotPasswordChangeFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _passTextField() {
    return CustomTextField(
      controller: _pController,
      hintText: LocaleKeys.password,
      margin: EdgeInsets.only(top: 15.0),
      obscureText: true,
    );
  }

  _passRepeatTextField() {
    return CustomTextField(
      controller: _pRepeatController,
      hintText: LocaleKeys.passwordRepeat,
      margin: EdgeInsets.only(top: 15.0),
      obscureText: true,
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnSave = _pController.text.length > 0 && _pRepeatController.text.length > 0;
    });
  }

  _buttonSave() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      asset: Assets.long_arrow_next,
      onPressed: _enabledBtnSave
          ? () {
              // Validation
              if (_pController.text != _pRepeatController.text) {
                showCustomDialog(
                  context,
                  child: CustomDialogBody(
                      asset: Assets.error, text: LocaleKeys.passwordsDoesNotMatch, buttonText: LocaleKeys.ok),
                );

                return;
              }

              var request = ForgotPasswordChangeRequest()
                ..userId = widget.userId
                ..code = widget.code
                ..newPassword = _pController.text;

              BlocManager.authBloc.add(ForgotPasswordChangeEvent(request));
            }
          : null,
    );
  }
}
