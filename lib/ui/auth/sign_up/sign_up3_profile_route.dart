import 'package:flutter/material.dart';
import 'package:habido_app/models/gender.dart';
import 'package:habido_app/models/sign_up_register_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/date_picker.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/switch.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

/// Sign up step 3
class SignUp3ProfileRoute extends StatefulWidget {
  final SignUpRegisterRequest signUpRegisterRequest;

  const SignUp3ProfileRoute({Key? key, required this.signUpRegisterRequest}) : super(key: key);

  @override
  _SignUp3ProfileRouteState createState() => _SignUp3ProfileRouteState();
}

class _SignUp3ProfileRouteState extends State<SignUp3ProfileRoute> {
  // UI
  final _signUp3ProfileKey = GlobalKey<ScaffoldState>();
  double _maxHeight = 0.0;
  double _minHeight = 600;

  // Төрсөн огноо
  DateTime? _selectedBirthDate;

  // Нэр
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  // Хүйс
  bool _genderValue = false;

  // Button next
  bool _enabledBtnNext = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => _validateForm());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);

    return CustomScaffold(
      scaffoldKey: _signUp3ProfileKey,
      appBarTitle: LocaleKeys.yourRegistration,
      child: LayoutBuilder(builder: (context, constraints) {
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

                /// TermCond
                _termCond(),

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
      lastDate: DateTime.now(),
      onSelectedDate: (date) {
        print(date);

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
        margin: EdgeInsets.only(left: 18.0),
        activeText: LocaleKeys.female,
        inactiveText: LocaleKeys.male,
        activeColor: Colors.transparent,
        inactiveThumbColor: Colors.transparent,
        activeTrackColor: Colors.grey,
        inactiveTrackColor: Colors.grey,
        activeAsset: Assets.female,
        inactiveAsset: Assets.male,
        onChanged: (value) {
          _genderValue = value;
        },
      ),
    );
  }

  _termCond() {
    return CustomText(
      LocaleKeys.agreeTermCond,
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
      asset: Assets.long_arrow_next,
      margin: EdgeInsets.only(top: 35.0),
      onPressed: _enabledBtnNext
          ? () {
              SignUpRegisterRequest verifyCodeRequest = widget.signUpRegisterRequest;
              verifyCodeRequest
                ..birthday = Func.toDateStr(_selectedBirthDate!)
                ..firstName = _nameController.text
                ..gender = _genderValue ? Gender.Female : Gender.Male;

              Navigator.pushNamed(context, Routes.signUp4Password, arguments: {
                'signUpRegisterRequest': verifyCodeRequest,
              });
            }
          : null,
    );
  }
}
