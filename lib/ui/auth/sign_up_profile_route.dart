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

class SignUpProfileRoute extends StatefulWidget {
  final SignUpResponse signUpResponse;
  final String code;

  const SignUpProfileRoute({Key? key, required this.signUpResponse, required this.code}) : super(key: key);

  @override
  _SignUpProfileRouteState createState() => _SignUpProfileRouteState();
}

class _SignUpProfileRouteState extends State<SignUpProfileRoute> {
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
                _genderTextField(),

                Expanded(child: Container()),

                /// Button next
                _buttonNext(),
                //_enabledBtnNext
              ],
            ),

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Expanded(child: Container(), flex: 25),
            //
            //     /// Logo
            //     _logo(),
            //
            //     Expanded(child: Container(), flex: 25),
            //
            //     Container(
            //       padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, 35.0),
            //       decoration: BoxDecoration(
            //         color: customColors.secondaryBackground,
            //         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            //       ),
            //       child: Column(
            //         children: [
            //           /// Утасны дугаар
            //           _txtboxPhoneNumber(),
            //
            //           /// Нууц үг
            //           _txtboxPassword(),
            //
            //           // _chkboxBiometric(),
            //
            //           SizedBox(height: 30.0),
            //
            //           Row(
            //             children: [
            //               Expanded(
            //                 /// Нэвтрэх button
            //                 child: _btnLogin(),
            //               ),
            //
            //               /// Finger print button
            //               _btnBiometrics(),
            //             ],
            //           ),
            //
            //           MarginVertical(height: 25.0),
            //
            //           /// Button - Нууц үг мартсан уу? Сэргээх
            //           _btnForgotPass(),
            //         ],
            //       ),
            //     ),
            //
            //     Expanded(
            //       child: Container(color: customColors.secondaryBackground),
            //       flex: 25,
            //     ),
            //
            //     /// Button - Та бүртгэлтэй юу? Бүртгүүлэх
            //     _btnSignUp(),
            //   ],
            // ),
          ),
        );
      }),
    );
  }

  _birthdayPicker() {
    return CustomDatePicker(
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
      margin: EdgeInsets.only(top: 35.0),
    );
  }

  _genderTextField() {
    return Container();
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
