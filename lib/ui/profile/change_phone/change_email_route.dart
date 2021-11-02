import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/change_phone_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class ChangeEmailRoute extends StatefulWidget {
  const ChangeEmailRoute({Key? key}) : super(key: key);

  @override
  _ChangeEmailRouteState createState() => _ChangeEmailRouteState();
}

class _ChangeEmailRouteState extends State<ChangeEmailRoute> {
  // Утасны дугаар
  TextEditingController _emailNumberController = TextEditingController();

  // Button save
  bool _enabledBtnSave = false;

  @override
  void initState() {
    super.initState();
    _emailNumberController.text = globals.userData?.email ?? '';
    _enabledBtnSave = Func.isValidPhoneNumber(_emailNumberController.text);

    _emailNumberController.addListener(() => _validateForm());
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
              appBarTitle: LocaleKeys.changeEmailNumber,
              loading: state is AuthLoading,
              child: Container(
                padding: SizeHelper.screenPadding,
                child: Column(
                  children: [
                    /// И-мэйл хаяг
                    _txtboxEmailNumber(),

                    Expanded(child: Container()),

                    /// Button save
                    // _buttonSave(),
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
    if (state is ChangePhoneSuccess) {
      Navigator.pushNamed(context, Routes.verifyPhone, arguments: {
        'phoneNumber': state.phoneNumber,
      });
    } else if (state is ChangePasswordFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _txtboxEmailNumber() {
    return CustomTextField(
      controller: _emailNumberController,
      hintText: LocaleKeys.email,
      margin: EdgeInsets.only(top: 15.0),
      // maxLength: 8,
      suffixAsset: Assets.edit,
      keyboardType: TextInputType.text,
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnSave = Func.isValidPhoneNumber(_emailNumberController.text);
    });
  }

  _buttonSave() {
    return CustomButton(
      style: CustomButtonStyle.secondary,
      text: LocaleKeys.save,
      onPressed: _enabledBtnSave
          ? () {
              Func.hideKeyboard(context);
              var request = ChangePhoneRequest()..phone = _emailNumberController.text;
              BlocManager.authBloc.add(ChangePhoneEvent(request));
            }
          : null,
    );
  }
}
