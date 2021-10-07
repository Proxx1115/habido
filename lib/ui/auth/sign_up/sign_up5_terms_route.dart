import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/sign_up_register_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/checkbox.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'terms_screen.dart';

/// Sign up step 5
class SignUp5TermsRoute extends StatefulWidget {
  final SignUpRegisterRequest signUpRegisterRequest;

  const SignUp5TermsRoute({Key? key, required this.signUpRegisterRequest}) : super(key: key);

  @override
  _SignUp5TermsRouteState createState() => _SignUp5TermsRouteState();
}

class _SignUp5TermsRouteState extends State<SignUp5TermsRoute> {
  // UI
  final _signUp4TermsKey = GlobalKey<ScaffoldState>();

  // Agree checkbox
  bool _checkBoxValue = false;

  // Button next
  bool _enabledBtnNext = false;

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
    if (state is SignUpRegisterSuccess) {
      Navigator.pushNamed(context, Routes.signUp6Success, arguments: {
        'signUpRegisterRequest': widget.signUpRegisterRequest,
      });
    } else if (state is SignUpRegisterFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, AuthState state) {
    return CustomScaffold(
      scaffoldKey: _signUp4TermsKey,
      appBarTitle: LocaleKeys.yourRegistration,
      child: Container(
        padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
        child: Column(
          children: [
            /// Та үйлчилгээний нөхцөлтэй танилцана уу.
            CustomText(
              LocaleKeys.termsOfService,
              maxLines: 2,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 35.0),
            ),

            /// Terms of service
            Expanded(
              child: ListView(
                children: [
                  TermsScreen(),
                ],
              ),
            ),

            /// Check agree
            _checkboxAgree(),

            /// Button next
            _buttonNext(),
            //_enabledBtnNext
          ],
        ),
      ),
    );
  }

  _checkboxAgree() {
    return CustomCheckbox(
      text: LocaleKeys.iAgree,
      margin: EdgeInsets.only(top: 45.0, bottom: 45.0),
      alignment: MainAxisAlignment.center,
      onChanged: (value) {
        _checkBoxValue = value;

        _validateForm();
      },
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = _checkBoxValue;
    });
  }

  _buttonNext() {
    return CustomButton(
      style: CustomButtonStyle.secondary,
      asset: Assets.long_arrow_next,
      onPressed: _enabledBtnNext
          ? () {
              BlocManager.authBloc.add(SignUpRegisterEvent(widget.signUpRegisterRequest));
            }
          : null,
    );
  }
}
