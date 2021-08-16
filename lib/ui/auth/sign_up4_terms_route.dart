import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/sign_up_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/date_picker.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

/// Sign up step 4
class SignUp4TermsRoute extends StatefulWidget {
  final SignUpResponse signUpResponse;
  final String code;

  const SignUp4TermsRoute({Key? key, required this.signUpResponse, required this.code}) : super(key: key);

  @override
  _SignUp4TermsRouteState createState() => _SignUp4TermsRouteState();
}

class _SignUp4TermsRouteState extends State<SignUp4TermsRoute> {
  // UI
  final _signUpProfileKey = GlobalKey<ScaffoldState>();
  double _maxHeight = 0.0;
  double _minHeight = 500; //458

  // Төрсөн огноо

  // Нэр
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  // Хүйс

  // Button next
  bool _enabledBtnNext = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => _validateForm());
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
    if (state is VerifyCodeSuccess) {
      // Navigator.pushNamed(context, Routes.verifyCode, arguments: {
      //   'signUpResponse': state.response,
      // });
    } else if (state is SignUpFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, button1Text: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, AuthState state) {
    return CustomScaffold(
      scaffoldKey: _signUpProfileKey,
      appBarTitle: LocaleKeys.yourRegistration,
      body: LayoutBuilder(builder: (context, constraints) {
        if (_maxHeight < constraints.maxHeight) _maxHeight = constraints.maxHeight;
        if (_maxHeight < _minHeight) _maxHeight = _minHeight;

        return SingleChildScrollView(
          child: Container(
            height: _maxHeight,
            padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
            child: Column(
              children: [
                /// Хувийн мэдээллээ оруулна уу
                CustomText(LocaleKeys.enterProfile, alignment: Alignment.center, maxLines: 2),

                /// Төрсөн огноо
                _birthdayPicker(),

                /// Таны нэр
                _nameTextField(),

                /// Хүйс
                _genderSwitch(),

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

  _birthdayPicker() {
    return CustomDatePicker(
      hintText: LocaleKeys.birthDate,
      onSelectedDate: (date) {
        print(date);
      },
    );
//     return CustomButton(
//       text: 'test',
//       onPressed: () async {
//         var picked = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2015, 8),
//           lastDate: DateTime(2101),
//         );
//
//         print('test');
//
// //    if (picked != null && picked != selectedDate)
// //      setState(() {
// //        selectedDate = picked;
// //      });
//       },
//     );
  }

  _nameTextField() {
    return CustomTextField(
      controller: _nameController,
      focusNode: _nameFocus,
      hintText: LocaleKeys.yourName,
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  _genderSwitch() {
    return CustomTextField(
      controller: _nameController,
      focusNode: _nameFocus,
      hintText: LocaleKeys.gender,
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = (_nameController.text.length > 0);
    });
  }

  _buttonNext() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      asset: Assets.arrow_next,
      onPressed: _enabledBtnNext
          ? () {
        //
      }
          : null,
    );
  }
}
