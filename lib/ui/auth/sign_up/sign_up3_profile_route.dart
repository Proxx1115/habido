import 'package:flutter/material.dart';
import 'package:habido_app/models/gender.dart';
import 'package:habido_app/models/sign_up_register_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/checkbox.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/date_picker.dart';
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

  // Төрсөн огноо
  DateTime? _selectedBirthDate;

  // Нэр
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  // Хүйс
  bool _genderValue = false;

  // Term cond
  bool _visibleTermCond = false;
  bool _checkBoxValue = false;

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
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: ListView(
                  shrinkWrap: true,
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

                    /// Check
                    _checkboxAgree(),
                  ],
                ),
              ),
            ),
          ),

          /// Button next
          _buttonNext(),
          //_enabledBtnNext
        ],
      ),
    );
  }

  Widget _birthdayPicker() {
    return CustomDatePicker(
      hintText: LocaleKeys.birthDate,
      margin: EdgeInsets.only(top: 35.0),
      lastDate: DateTime.now(),
      onSelectedDate: (date) {
        // print(date);
        _selectedBirthDate = date;
        _validateForm();
      },
    );
  }

  Widget _nameTextField() {
    return CustomTextField(
      controller: _nameController,
      focusNode: _nameFocus,
      hintText: LocaleKeys.yourName,
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  Widget _genderSwitch() {
    return StadiumContainer(
      margin: EdgeInsets.only(top: 15.0),
      child: CustomSwitch(
        value: _genderValue,
        margin: EdgeInsets.only(left: 2.0),
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

  Widget _termCond() {
    return _visibleTermCond
        ? StadiumContainer(
            margin: EdgeInsets.only(top: 15.0),
            padding: SizeHelper.boxPadding,
            child: RichText(
              text: TextSpan(
                text: LocaleKeys.agreeTermCond1,
                style: TextStyle(color: customColors.primaryText),
                children: <TextSpan>[
                  TextSpan(
                      text: LocaleKeys.agreeTermCond2,
                      style: TextStyle(
                        color: customColors.primaryText,
                        fontWeight: FontWeight.w600,
                      )),
                  TextSpan(text: LocaleKeys.agreeTermCond3, style: TextStyle(color: customColors.primaryText)),
                ],
              ),
            ),
          )
        : Container();
  }

  _checkboxAgree() {
    return _visibleTermCond
        ? CustomCheckbox(
            text: LocaleKeys.iAgree,
            margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
            alignment: MainAxisAlignment.center,
            onChanged: (value) {
              _checkBoxValue = value;

              _validateForm();
            },
          )
        : Container();
  }

  _validateForm() {
    setState(() {
      // Term cond
      if (_selectedBirthDate == null) {
        _visibleTermCond = false;
      } else if (Func.isAdult(_selectedBirthDate!)) {
        _visibleTermCond = false;
      } else {
        _visibleTermCond = true;
      }

      // Button next
      _enabledBtnNext =
          _selectedBirthDate != null && _nameController.text.length > 0 && (_visibleTermCond ? _checkBoxValue : true);
    });
  }

  _buttonNext() {
    return !Func.visibleKeyboard(context)
        ? CustomButton(
            margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, SizeHelper.marginBottom),
            style: CustomButtonStyle.Secondary,
            asset: Assets.long_arrow_next,
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
          )
        : Container();
  }
}
