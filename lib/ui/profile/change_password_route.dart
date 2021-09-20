import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/change_password_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class ChangePasswordRoute extends StatefulWidget {
  const ChangePasswordRoute({Key? key}) : super(key: key);

  @override
  _ChangePasswordRouteState createState() => _ChangePasswordRouteState();
}

class _ChangePasswordRouteState extends State<ChangePasswordRoute> {
  // Хуучин нууц үг
  final _oldPassController = TextEditingController();

  // Нууц үг
  final _passController = TextEditingController();

  // Нууц үг давтах
  final _passRepeatController = TextEditingController();

  // Button save
  bool _enabledBtnSave = false;

  @override
  void initState() {
    super.initState();
    _oldPassController.addListener(() => _validateForm());
    _passController.addListener(() => _validateForm());
    _passRepeatController.addListener(() => _validateForm());
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
              appBarTitle: LocaleKeys.changePassword,
              loading: state is AuthLoading,
              child: Container(
                padding: SizeHelper.paddingScreen,
                child: Column(
                  children: [
                    /// Хуучин нууц үг
                    _oldPassTextField(),

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
    if (state is ChangePasswordSuccess) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.success,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.pop(context);
          },
        ),
      );
    } else if (state is ChangePasswordFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _oldPassTextField() {
    return CustomTextField(
      controller: _oldPassController,
      hintText: LocaleKeys.oldPassword,
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  _passTextField() {
    return CustomTextField(
      controller: _passController,
      hintText: LocaleKeys.password,
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  _passRepeatTextField() {
    return CustomTextField(
      controller: _passRepeatController,
      hintText: LocaleKeys.passwordRepeat,
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnSave = _oldPassController.text.length > 0 &&
          _passController.text.length > 0 &&
          _passRepeatController.text.length > 0;
    });
  }

  _buttonSave() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      text: LocaleKeys.save,
      onPressed: _enabledBtnSave
          ? () {
              // Validation
              if (_passController.text != _passRepeatController.text) {
                showCustomDialog(
                  context,
                  child: CustomDialogBody(
                      asset: Assets.error, text: LocaleKeys.passwordsDoesNotMatch, buttonText: LocaleKeys.ok),
                );

                return;
              }

              var request = ChangePasswordRequest()
                ..oldPassword = _oldPassController.text
                ..newPassword = _passController.text;

              BlocManager.authBloc.add(ChangePasswordEvent(request));
            }
          : null,
    );
  }
}
