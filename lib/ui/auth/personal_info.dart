import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_bloc.dart';
import 'package:habido_app/models/gender.dart';
import 'package:habido_app/models/update_user_data_request.dart';
import 'package:habido_app/ui/profile_v2/user_info/textbox.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/date_picker/date_picker.dart';
import 'package:habido_app/widgets/date_picker/date_pickerInfo.dart';
import 'package:habido_app/widgets/date_picker/date_picker_bloc.dart';
import 'package:habido_app/widgets/date_picker/date_picker_v2.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:habido_app/widgets/userInfoSwitch.dart';

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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateForm());

    super.initState();
  }

  void _blocListener(BuildContext context, UserState state) {
    if (state is UpdateUserDataSuccess) {
      BlocManager.userBloc.add(GetUserDataEvent());
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.success,
          buttonText: LocaleKeys.ok,
          primaryColor: customColors.feijoBackground,
          onPressedButton: () {
            Navigator.pop(context);
          },
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.home_new, (Route<dynamic> route) => false);
    } else if (state is UpdateUserDataFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _signUpKey = GlobalKey<ScaffoldState>();

    return BlocProvider.value(
      value: BlocManager.userBloc,
      child: BlocListener<UserBloc, UserState>(
        listener: _blocListener,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
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
                          width: 200.0,
                          height: 200.0,
                          margin: EdgeInsets.fromLTRB(62, 48, 62, 32),
                          child: SvgPicture.asset(
                            Assets.PersonalInfo,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: SizeHelper.margin),
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      CustomText(
                                        LocaleKeys.personalInfo,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 30.0,
                                      ),
                                      FormItem(image: Assets.username, widget: _userNameTextField()),
                                      FormItem(image: Assets.calendar, widget: _birthdayPicker()),
                                      FormItem(image: Assets.username, widget: _genderSwitch()),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(45.0, 0.0, 45.0, 31.0),
                                child: CustomButton(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  onPressed: () {
                                    _buttonSave();
                                  },
                                  text: LocaleKeys.continueTxt,
                                  fontWeight: FontWeight.w900,
                                  backgroundColor: customColors.primaryButtonBackground,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  )
                ]),
              ),
            );
          },
        ),
      ),
    );
  }

  _userNameTextField() {
    return CustomTextField(
      padding: 0,
      controller: _userNameController,
      // decoration: InputDecoration(contentPadding: EdgeInsets.zero,),
      hintText: LocaleKeys.firstName,
      // suffixAsset: Assets.editV2,
      backgroundColor: Colors.transparent,
    );
  }

  _birthdayPicker() {
    return CustomDatePickerV2(
      margin: EdgeInsets.zero,
      bloc: _birthDatePickerBloc,
      initialDate: _selectedBirthDate,
      hintText: LocaleKeys.birthDate,
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
      backgroundColor: Colors.transparent,
      child: UserInfoSwitch(
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
      _enabledBtnSave = _selectedBirthDate != null && _userNameController.text.length > 0;
    });
  }

  _validateAge() {
    // Is older than 12 years old
    if (_selectedBirthDate == null) return false;

    DateTime today = DateTime.now();
    int yearDiff = today.year - _selectedBirthDate!.year;
    int monthDiff = today.month - _selectedBirthDate!.month;
    int dayDiff = today.day - _selectedBirthDate!.day;

    return yearDiff > 12 || yearDiff == 12 && monthDiff >= 0 && dayDiff >= 0;
  }

  Widget FormItem({image, widget}) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: customColors.whiteBackground,
              borderRadius: BorderRadius.circular(5.0),
            ),
            width: 26.0,
            height: 26.0,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: SvgPicture.asset(
              image,
              width: 12.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              children: [
                widget,
                Container(height: 2.0, width: double.infinity, color: ConstantColors.cornflowerBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buttonSave() {
    print("button ajillaj bna");

    if (!_validateAge()) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.validate12UserProfile, buttonText: LocaleKeys.ok),
      );

      return;
    }
    var request = UpdateUserDataRequest()
      ..firstName = _userNameController.text
      ..birthday = Func.toDateStr(_selectedBirthDate!)
      ..userGender = _genderValue ? Gender.Female : Gender.Male;
    print("ene :::::::::$request");
    print("ene :::::::::${_userNameController.text}");
    print("ene :::::::::$_selectedBirthDate");
    print("ene :::::::::$_genderValue");

    BlocManager.userBloc.add(UpdateUserDataEvent(request));
  }
}
