import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/date_picker/date_picker.dart';
import 'package:habido_app/widgets/date_picker/date_picker_bloc.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/switch.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  // User name
  final _userNameController = TextEditingController();

  // Төрсөн огноо
  DateTime? _selectedBirthDate;
  final _birthDatePickerBloc = DatePickerBloc();

  // Хүйс
  bool _genderValue = false;

  // Button save
  bool _enabledBtnSave = false;
  @override
  Widget build(BuildContext context) {
    final _signUpKey = GlobalKey<ScaffoldState>();
    return Container(
      color: customColors.primaryBackground,
      child: CustomScaffold(
        scaffoldKey: _signUpKey,
        child: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Container(
                  width: 251.0,
                  height: 251.0,
                  margin: EdgeInsets.fromLTRB(62, 48, 62, 32),
                  child: SvgPicture.asset(
                    Assets.PersonalInfo,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: SizeHelper.margin),
                      child: Column(
                        children: [
                          CustomText(
                            LocaleKeys.personalInfo,
                            fontWeight: FontWeight.w700,
                            fontSize: 30.0,
                          ),
                          _userNameTextField(),
                          _birthdayPicker(),
                          _genderSwitch(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(45.0, 0.0, 45.0, 31.0),
                      child: CustomButton(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        onPressed: () {},
                        text: LocaleKeys.continueTxt,
                        fontWeight: FontWeight.w900,
                        backgroundColor: customColors.primaryButtonBackground,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          )
        ]),
      ),
    );
  }

  _userNameTextField() {
    return CustomTextField(
      controller: _userNameController,
      hintText: LocaleKeys.lastName,
      suffixAsset: Assets.edit,
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  _birthdayPicker() {
    return CustomDatePicker(
      bloc: _birthDatePickerBloc,
      initialDate: _selectedBirthDate,
      hintText: LocaleKeys.birthDate,
      margin: EdgeInsets.only(top: 15.0),
      lastDate: DateTime.now(),
      callback: (date) {
        // print(date);
        _selectedBirthDate = date;
        _validateForm();
      },
    );
  }

  _genderSwitch() {
    return StadiumContainer(
      margin: EdgeInsets.only(top: 15.0),
      child: CustomSwitch(
        value: _genderValue,
        // margin: EdgeInsets.only(left: 18.0),
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

  _validateForm() {
    setState(() {
      _enabledBtnSave =
          _selectedBirthDate != null && _userNameController.text.length > 0;
    });
  }
}
