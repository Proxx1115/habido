import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/verify_phone_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/code_input.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class VerifyPhoneRoute extends StatefulWidget {
  final String phoneNumber;

  const VerifyPhoneRoute({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _VerifyPhoneRouteState createState() => _VerifyPhoneRouteState();
}

class _VerifyPhoneRouteState extends State<VerifyPhoneRoute> {
  // Code
  String? _code = '';

  // Button next
  bool _enabledBtnNext = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: _blocListener,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return CustomScaffold(
              appBarTitle: LocaleKeys.phoneNumber,
              loading: state is AuthLoading,
              child: Container(
                padding: SizeHelper.paddingScreen,
                child: Column(
                  children: [
                    /// Танд мессежээр ирсэн 4-н оронтой кодыг оруулна уу
                    CustomText(
                      LocaleKeys.pleaseEnterVerifyCode,
                      maxLines: 4,
                      margin: EdgeInsets.only(top: 20.0),
                      alignment: Alignment.center,
                    ),

                    /// Утасны дугаар
                    _codeInput(),

                    Expanded(child: Container()),

                    /// Button save
                    _buttonNext(),
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
    if (state is VerifyPhoneSuccess) {
      showCustomDialog(
        context,
        isDismissible: false,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.success,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.popUntil(context, ModalRoute.withName(Routes.home));
          },
        ),
      );
    } else if (state is VerifyPhoneFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _codeInput() {
    return CustomCodeInput(
      margin: EdgeInsets.only(top: 35.0),
      onChanged: (value) {
        _code = value;
        _validateForm();
      },
      onFilled: (value) {
        _code = value;
        _validateForm();

        Func.hideKeyboard(context);

        _onPressedBtnNext();
      },
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = (_code != null && _code?.length == 4);
    });
  }

  _buttonNext() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      asset: Assets.long_arrow_next,
      onPressed: _enabledBtnNext
          ? () {
              _onPressedBtnNext();
            }
          : null,
    );
  }

  _onPressedBtnNext() {
    Func.hideKeyboard(context);

    if (!_enabledBtnNext) return;

    var request = VerifyPhoneRequest()
      ..phone = widget.phoneNumber
      ..code = _code;
    BlocManager.authBloc.add(VerifyPhoneEvent(request));
  }
}
