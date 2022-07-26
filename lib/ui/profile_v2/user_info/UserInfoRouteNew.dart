import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_bloc.dart';
import 'package:habido_app/models/dictionary.dart';
import 'package:habido_app/models/gender.dart';
import 'package:habido_app/models/get_dict_request.dart';
import 'package:habido_app/models/get_dict_response.dart';
import 'package:habido_app/models/update_profile_picture_request.dart';
import 'package:habido_app/models/update_user_data_request.dart';
import 'package:habido_app/models/user_device.dart';
import 'package:habido_app/ui/profile_v2/user_info/textbox.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/biometrics_util.dart';
import 'package:habido_app/utils/device_helper.dart';
import 'package:habido_app/utils/dict_helper.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/image_utils.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/combobox/combo_helper.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/customDialog.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/date_picker/date_picker.dart';
import 'package:habido_app/widgets/date_picker/date_picker_bloc.dart';
import 'package:habido_app/widgets/date_picker/date_picker_v2.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/listItem.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/switch.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoRouteNew extends StatefulWidget {
  const UserInfoRouteNew({Key? key}) : super(key: key);

  @override
  _UserInfoRouteNewState createState() => _UserInfoRouteNewState();
}

class _UserInfoRouteNewState extends State<UserInfoRouteNew> {
  // Profile picture
  double _profilePictureSize = 105.0;

  // Овог
  final _lastNameController = TextEditingController();

  String? _selectedEmp;
  String? _selectedAdd;

  List<DictData>? _employmentList;
  List<DictData>? _addressList;

  // Нэр
  final _firstNameController = TextEditingController();

  // Төрсөн огноо
  DateTime? _selectedBirthDate;
  final _birthDatePickerBloc = DatePickerBloc();

  // Хүйс
  bool _genderValue = false;

  // Биометр
  UserDevice? _userDevice;

  // Button save
  bool _enabledBtnSave = false;

  @override
  void initState() {
    _lastNameController.addListener(() => _validateForm());
    _firstNameController.addListener(() => _validateForm());

    if (globals.userData?.lastName != null)
      _lastNameController.text = globals.userData!.lastName!;
    if (globals.userData?.firstName != null)
      _firstNameController.text = globals.userData!.firstName!;
    if (globals.userData?.gender != null)
      _genderValue = globals.userData!.gender == Gender.Female;
    if (globals.userData?.birthDay != null)
      _selectedBirthDate = Func.toDate(globals.userData!.birthDay!);
    if (globals.userData?.employment != null)
      _selectedEmp = globals.userData!.employment!;
    if (globals.userData?.address != null)
      _selectedAdd = globals.userData!.address!;

    if (Func.isNotEmpty(DeviceHelper.deviceId)) {
      BlocManager.userBloc.add(GetUserDeviceEvent(DeviceHelper.deviceId!));
      BlocManager.userBloc.add(GetEmploymentDict());
      BlocManager.userBloc.add(GetAddressDict());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _validateForm());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.userBloc,
      child: BlocListener<UserBloc, UserState>(
        listener: _blocListener,
        child: BlocBuilder<UserBloc, UserState>(
          builder: _blocBuilder,
        ),
      ),
    );
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
    } else if (state is UpdateUserDataFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    }
    if (state is UpdateProfilePictureSuccess) {
      print('UpdateProfilePictureSuccess');
    } else if (state is UpdateProfilePictureFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is GetUserDeviceSuccess) {
      _userDevice = state.userDevice;
    } else if (state is GetUserDeviceFailed) {
      print('GetUserDeviceFailed');
    } else if (state is UpdateUserDeviceSuccess) {
      SharedPref.setBiometricAuth(_userDevice!.isBiometric);

      BlocManager.authBloc
          .add(BiometricsChangedEvent(_userDevice!.isBiometric ?? false));
    } else if (state is UpdateUserDeviceFailed) {
      print('UpdateUserDeviceFailed');
    }
    if (state is EmploymentDictSuccess) {
      _employmentList = state.dictData;
    } else if (state is EmploymentDictFailed) {
      print("Failed employment dict");
    }
    if (state is AddressDictSuccess) {
      _addressList = state.dictData;
    } else if (state is AddressDictFailed) {
      print("Failed address dict");
    }
  }

  Widget _blocBuilder(BuildContext context, UserState state) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.userInfo,
      loading: state is UserLoading,
      child: Column(
        children: [
          RoundedCornerListView(
            padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0,
                SizeHelper.padding, SizeHelper.padding),
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 52.5),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(SizeHelper.borderRadius),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 55),

                        /// Овог
                        _lastNameTextField(),
                        HorizontalLine(),

                        /// Таны нэр
                        _firstNameTextField(),
                        HorizontalLine(),

                        /// Төрсөн огноо
                        _birthdayPicker(),
                        HorizontalLine(),

                        /// Employment
                        _employmentChooser(),
                        HorizontalLine(),

                        /// Address
                        _addressChooser(),
                        HorizontalLine(),

                        /// И-мэйл хаяг солих
                        _changeEmailCard(),
                        HorizontalLine(),

                        /// Утасны дугаар солих
                        _changePhoneCard(),

                        /// Биометрээр нэвтрэх
                        _biometricsSwitch(),
                        const SizedBox(height: 25)
                      ],
                    ),
                  ),
                  _profilePicture(),
                ],
              ),
              SizedBox(height: 10.0),

              /// Profile pic
              // _profilePicture(),
            ],
          ),

          /// Button save
          _buttonSave(),
        ],
      ),
    );
  }

  Widget _profilePicture() {
    return InkWell(
      onTap: () async {
        showCustomDialog(
          context,
          isDismissible: true,
          child: CustomDialogBody(
            asset: Assets.camera,
            text: LocaleKeys.pleaseSelectPicture,
            buttonText: LocaleKeys.camera,
            button2Text: LocaleKeys.gallery,
            onPressedButton: () async {
              String base64Image =
                  await ImageUtils.getBase64Image(context, ImageSource.camera);
              if (base64Image.isNotEmpty) {
                var request = UpdateProfilePictureRequest()
                  ..photoBase64 = base64Image;
                BlocManager.userBloc.add(UpdateProfilePictureEvent(request));
              }
            },
            onPressedButton2: () async {
              String base64Image =
                  await ImageUtils.getBase64Image(context, ImageSource.gallery);
              if (base64Image.isNotEmpty) {
                var request = UpdateProfilePictureRequest()
                  ..photoBase64 = base64Image;
                BlocManager.userBloc.add(UpdateProfilePictureEvent(request));
              }
            },
          ),
        );
      },
      child: Container(
        width: _profilePictureSize,
        height: _profilePictureSize,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            /// Image
            if (Func.isNotEmpty(globals.userData!.photo))
              Align(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(_profilePictureSize)),
                  child: CachedNetworkImage(
                    imageUrl: globals.userData!.photo!,
                    fit: BoxFit.cover,
                    width: _profilePictureSize,
                    height: _profilePictureSize,
                    placeholder: (context, url) =>
                        CustomLoader(size: _profilePictureSize),
                    // placeholder: (context, url, error) => Container(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
              ),

            /// Overlay
            if (Func.isEmpty(globals.userData!.photo))
              Align(
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: 0.75,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(_profilePictureSize)),
                    child: Container(
                      padding: EdgeInsets.all(41.0),
                      height: _profilePictureSize,
                      width: _profilePictureSize,
                      decoration: BoxDecoration(color: customColors.primary),
                      child: SvgPicture.asset(Assets.camera,
                          color: customColors.iconWhite),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _lastNameTextField() {
    return UserInfoTextField(
      controller: _lastNameController,
      hintText: LocaleKeys.lastName,
      suffixAsset: Assets.editV2,
      margin: EdgeInsets.only(top: 15.0),
      backgroundColor: Colors.transparent,
    );
  }

  _firstNameTextField() {
    return UserInfoTextField(
      controller: _firstNameController,
      hintText: LocaleKeys.yourName,
      suffixAsset: Assets.editV2,
      margin: EdgeInsets.only(top: 15.0),
      backgroundColor: Colors.transparent,
    );
  }

  _birthdayPicker() {
    return CustomDatePickerV2(
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
      backgroundColor: Colors.transparent,
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

  _address() {
    return ListItemContainer(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.symmetric(vertical: 15),
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      title: Func.isNotEmpty(globals.userData?.phone)
          ? globals.userData!.phone!
          : LocaleKeys.address,
      suffixAsset: Assets.down_arrow,
      onPressed: () {
        Navigator.pushNamed(context, Routes.changePhone);
      },
    );
  }

  Widget _changePhoneCard() {
    return ListItemContainer(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.symmetric(vertical: 15),
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      title: Func.isNotEmpty(globals.userData?.phone)
          ? globals.userData!.phone!
          : LocaleKeys.phone,
      suffixAsset: Assets.arrow_forward,
      onPressed: () {
        Navigator.pushNamed(context, Routes.changePhone);
      },
    );
  }

  Widget _changeEmailCard() {
    return ListItemContainer(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.symmetric(vertical: 15),
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      title: Func.isNotEmpty(globals.userData?.email)
          ? globals.userData!.email!
          : LocaleKeys.email,
      suffixAsset: Assets.arrow_forward,
      // onPressed: () {
      //   Navigator.pushNamed(context, Routes.changeEmail);
      // },
    );
  }

  Widget _changePasswordCard() {
    return ListItemContainer(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.symmetric(vertical: 15),
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      title: LocaleKeys.changePassword,
      suffixAsset: Assets.arrow_forward,
      onPressed: () {
        Navigator.pushNamed(context, Routes.changePass);
      },
    );
  }

  Widget _biometricsSwitch() {
    return (_userDevice != null &&
            biometricsUtil.canCheckBiometrics &&
            biometricsUtil.availableBiometricsCount > 0)
        ? StadiumContainer(
            backgroundColor: Colors.transparent,
            margin: EdgeInsets.only(top: 15.0),
            child: CustomSwitch(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
              activeText: LocaleKeys.biometricAuth,
              activeColor: customColors.primary,
              value: _userDevice!.isBiometric ?? false,
              onChanged: (value) {
                if (_userDevice != null) {
                  setState(() {
                    _userDevice!.isBiometric = value;
                  });

                  BlocManager.userBloc.add(UpdateUserDeviceEvent(_userDevice!));
                }
              },
            ),
          )
        : Container();
  }

  _validateForm() {
    setState(() {
      _enabledBtnSave = _selectedBirthDate != null &&
          _lastNameController.text.length > 0 &&
          _firstNameController.text.length > 0;
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

  _buttonSave() {
    return !Func.visibleKeyboard(context)
        ? CustomButton(
            margin: EdgeInsets.fromLTRB(45.0, 0, 45.0, 30.0),
            fontWeight: FontWeight.w700,
            alignment: Alignment.bottomCenter,
            text: LocaleKeys.save,
            borderRadius: BorderRadius.circular(15.0),
            onPressed: _enabledBtnSave
                ? () {
                    if (!_validateAge()) {
                      showCustomDialog(
                        context,
                        child: CustomDialogBody(
                            asset: Assets.error,
                            text: LocaleKeys.validate12UserProfile,
                            buttonText: LocaleKeys.ok),
                      );

                      return;
                    }
                    var request = UpdateUserDataRequest()
                      ..lastName = _lastNameController.text
                      ..firstName = _firstNameController.text
                      ..birthday = Func.toDateStr(_selectedBirthDate!)
                      ..userGender = _genderValue ? Gender.Female : Gender.Male
                      ..employment = _selectedEmp
                      ..address = _selectedAdd;
                    // ..email = _firstNameController.text
                    // ..phone = _firstNameController.text;

                    BlocManager.userBloc.add(UpdateUserDataEvent(request));
                  }
                : null,
          )
        : Container();
  }

  Widget _employmentChooser() {
    return ListItemContainer(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.symmetric(vertical: 15),
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      title: globals.userData!.employment != null
          ? globals.userData!.employment
          : _selectedEmp == null
              ? null
              : _selectedEmp,
      hintText:
          globals.userData!.employment == null ? LocaleKeys.employment : null,
      suffixAsset: Assets.down_arrow,
      onPressed: () {
        showCustomDialog(
          context,
          child: CustomDialogBody(
            child: Container(
              height: 300,
              child: Column(
                children: [
                  CustomText(
                    LocaleKeys.chooseEmp.toUpperCase(),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: customColors.primary,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  if (_employmentList != null)
                    for (var el in _employmentList!)
                      Column(
                        children: [
                          InkWell(
                            child: CustomText(
                              el.txt,
                              fontSize: 13.0,
                            ),
                            onTap: () {
                              el.isSelected = true;
                              _selectedEmp = el.txt;
                              print(_selectedEmp);
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                          HorizontalLine(
                              margin: EdgeInsets.symmetric(vertical: 14.0)),
                        ],
                      )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _addressChooser() {
    return ListItemContainer(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.symmetric(vertical: 15),
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      title: globals.userData!.address != null
          ? globals.userData!.address
          : _selectedAdd == null
              ? null
              : _selectedAdd,
      hintText:
          globals.userData!.employment == null ? LocaleKeys.address : null,
      suffixAsset: Assets.down_arrow,
      onPressed: () {
        showCustomDialog(
          context,
          child: CustomDialogBody(
            child: Container(
              height: 300,
              child: Column(
                children: [
                  CustomText(
                    LocaleKeys.chooseEmp.toUpperCase(),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: customColors.primary,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  if (_addressList != null)
                    for (var el in _addressList!)
                      Column(
                        children: [
                          InkWell(
                            child: CustomText(
                              el.txt,
                              fontSize: 13.0,
                            ),
                            onTap: () {
                              el.isSelected = true;
                              _selectedAdd = el.txt;
                              print(_selectedAdd);
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                          HorizontalLine(
                              margin: EdgeInsets.symmetric(vertical: 14.0)),
                        ],
                      )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
