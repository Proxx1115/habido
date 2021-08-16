import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/gender.dart';
import 'package:habido_app/models/sign_up_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/date_picker.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/switch.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

/// Sign up step 3
class SignUp3ProfileRoute extends StatefulWidget {
  final SignUpResponse signUpResponse;
  final String code;

  const SignUp3ProfileRoute({Key? key, required this.signUpResponse, required this.code}) : super(key: key);

  @override
  _SignUp3ProfileRouteState createState() => _SignUp3ProfileRouteState();
}

class _SignUp3ProfileRouteState extends State<SignUp3ProfileRoute> {
  // UI
  final _signUpProfileKey = GlobalKey<ScaffoldState>();
  double _maxHeight = 0.0;
  double _minHeight = 500; //458

  // Төрсөн огноо
  DateTime? _selectedBirthDate;

  // Нэр
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  // Хүйс
  bool _genderValue = false;
  String _genderText = Gender.Male;

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

                TextField(
                  controller: TextEditingController(),
                ),

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
      margin: EdgeInsets.only(top: 35.0),
      onSelectedDate: (date) {
        _selectedBirthDate = date;
        _validateForm();
      },
    );
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
    return StadiumContainer(
      margin: EdgeInsets.only(top: 15.0),
      child: CustomSwitch(
        value: _genderValue,
        activeText: LocaleKeys.female,
        inactiveText: LocaleKeys.male,
        onChanged: (value) {
          _genderValue = value;
        },
      ),
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = _selectedBirthDate != null && _nameController.text.length > 0;
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
