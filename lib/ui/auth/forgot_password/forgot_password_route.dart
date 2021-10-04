import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/change_phone_request.dart';
import 'package:habido_app/models/forgot_password_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class ForgotPasswordRoute extends StatefulWidget {
  const ForgotPasswordRoute({Key? key}) : super(key: key);

  @override
  _ForgotPasswordRouteState createState() => _ForgotPasswordRouteState();
}

class _ForgotPasswordRouteState extends State<ForgotPasswordRoute> {
  // Утасны дугаар
  TextEditingController _phoneNumberController = TextEditingController();

  // Button save
  bool _enabledBtnSave = false;

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(() => _validateForm());
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
                padding: SizeHelper.screenPadding,
                child: Column(
                  children: [
                    /// Утасны дугаар
                    _txtboxPhoneNumber(),

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
    if (state is ForgotPasswordSuccess) {
      Navigator.pushNamed(context, Routes.verifyPassword, arguments: {
        'userId': state.userId,
        'phoneNumber': state.phoneNumber,
      });
    } else if (state is ForgotPasswordFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _txtboxPhoneNumber() {
    return CustomTextField(
      controller: _phoneNumberController,
      hintText: LocaleKeys.phoneNumber,
      margin: EdgeInsets.only(top: 15.0),
      maxLength: 8,
      keyboardType: TextInputType.number,
      suffixAsset: Assets.edit,
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnSave = Func.isValidPhoneNumber(_phoneNumberController.text);
    });
  }

  _buttonSave() {
    return CustomButton(
      style: CustomButtonStyle.secondary,
      asset: Assets.long_arrow_next,
      onPressed: _enabledBtnSave
          ? () {
              Func.hideKeyboard(context);
              var request = ForgotPasswordRequest()..phone = _phoneNumberController.text;
              BlocManager.authBloc.add(ForgotPasswordEvent(request));
            }
          : null,
    );
  }
}
