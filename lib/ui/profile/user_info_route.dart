import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_bloc.dart';
import 'package:habido_app/models/gender.dart';
import 'package:habido_app/models/update_profile_picture_request.dart';
import 'package:habido_app/models/update_user_data_request.dart';
import 'package:habido_app/models/user_device.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/biometrics_util.dart';
import 'package:habido_app/utils/device_helper.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/image_utils.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/date_picker/date_picker.dart';
import 'package:habido_app/widgets/date_picker/date_picker_bloc.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/switch.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoRoute extends StatefulWidget {
  const UserInfoRoute({Key? key}) : super(key: key);

  @override
  _UserInfoRouteState createState() => _UserInfoRouteState();
}

class _UserInfoRouteState extends State<UserInfoRoute> {
  // Profile picture
  double _profilePictureSize = 105.0;

  // Овог
  final _lastNameController = TextEditingController();

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

    if (globals.userData?.lastName != null) _lastNameController.text = globals.userData!.lastName!;
    if (globals.userData?.firstName != null) _firstNameController.text = globals.userData!.firstName!;
    if (globals.userData?.gender != null) _genderValue = globals.userData!.gender == Gender.Female;
    if (globals.userData?.birthDay != null) _selectedBirthDate = Func.toDate(globals.userData!.birthDay!);

    if (Func.isNotEmpty(DeviceHelper.deviceId)) {
      BlocManager.userBloc.add(GetUserDeviceEvent(DeviceHelper.deviceId!));
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) => _validateForm());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.userBloc,
      child: BlocListener<UserBloc, UserState>(
        listener: _blocListener,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return CustomScaffold(
              appBarTitle: LocaleKeys.userInfo,
              loading: state is UserLoading,
              child: Column(
                children: [
                  RoundedCornerListView(
                    padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.padding),
                    children: [
                      SizedBox(height: 10.0),

                      /// Profile pic
                      _profilePicture(),

                      /// Овог
                      _lastNameTextField(),

                      /// Таны нэр
                      _firstNameTextField(),

                      /// Төрсөн огноо
                      _birthdayPicker(),

                      /// Хүйс
                      _genderSwitch(),

                      /// Утасны дугаар солих
                      _changePhoneCard(),

                      /// Нууц үг солих
                      _changePasswordCard(),

                      /// Биометрээр нэвтрэх
                      _biometricsSwitch(),
                    ],
                  ),

                  /// Button save
                  _buttonSave(),
                ],
              ),
            );
          },
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
          onPressedButton: () {
            Navigator.pop(context);
          },
        ),
      );
    } else if (state is UpdateUserDataFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
    if (state is UpdateProfilePictureSuccess) {
      print('UpdateProfilePictureSuccess');
    } else if (state is UpdateProfilePictureFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is GetUserDeviceSuccess) {
      _userDevice = state.userDevice;
    } else if (state is GetUserDeviceFailed) {
      print('GetUserDeviceFailed');
    } else if (state is UpdateUserDeviceSuccess) {
      SharedPref.setBiometricAuth(_userDevice!.isBiometric);

      BlocManager.authBloc.add(BiometricsChangedEvent(_userDevice!.isBiometric ?? false));
    } else if (state is UpdateUserDeviceFailed) {
      print('UpdateUserDeviceFailed');
    }
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
              String base64Image = await ImageUtils.getBase64Image(context, ImageSource.camera);
              if (base64Image.isNotEmpty) {
                var request = UpdateProfilePictureRequest()..photoBase64 = base64Image;
                BlocManager.userBloc.add(UpdateProfilePictureEvent(request));
              }
            },
            onPressedButton2: () async {
              String base64Image = await ImageUtils.getBase64Image(context, ImageSource.gallery);
              if (base64Image.isNotEmpty) {
                var request = UpdateProfilePictureRequest()..photoBase64 = base64Image;
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
                  borderRadius: BorderRadius.all(Radius.circular(_profilePictureSize)),
                  child: CachedNetworkImage(
                    imageUrl: globals.userData!.photo!,
                    fit: BoxFit.fill,
                    width: _profilePictureSize,
                    height: _profilePictureSize,
                    placeholder: (context, url) => CustomLoader(size: _profilePictureSize),
                    // placeholder: (context, url, error) => Container(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
              ),

            /// Overlay
            if (Func.isEmpty(globals.userData!.photo))
              Align(
                alignment: Alignment.topCenter,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(_profilePictureSize)),
                  onTap: () async {
                    String base64Image = await ImageUtils.getBase64Image(context);
                    if (base64Image.isNotEmpty) {
                      var request = UpdateProfilePictureRequest()..photoBase64 = base64Image;
                      BlocManager.userBloc.add(UpdateProfilePictureEvent(request));
                    }
                  },
                  child: Opacity(
                    opacity: 0.75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(_profilePictureSize)),
                      child: Container(
                        padding: EdgeInsets.all(41.0),
                        height: _profilePictureSize,
                        width: _profilePictureSize,
                        decoration: BoxDecoration(color: customColors.primary),
                        child: SvgPicture.asset(Assets.camera, color: customColors.iconWhite),
                      ),
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
    return CustomTextField(
      controller: _lastNameController,
      hintText: LocaleKeys.lastName,
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  _firstNameTextField() {
    return CustomTextField(
      controller: _firstNameController,
      hintText: LocaleKeys.yourName,
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
        print(date);

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

  Widget _changePhoneCard() {
    return ListItemContainer(
      margin: EdgeInsets.only(top: 15.0),
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      title: LocaleKeys.phoneNumber,
      suffixAsset: Assets.arrow_forward,
      onPressed: () {
        Navigator.pushNamed(context, Routes.changePhone);
      },
    );
  }

  Widget _changePasswordCard() {
    return ListItemContainer(
      margin: EdgeInsets.only(top: 15.0),
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      title: LocaleKeys.changePassword,
      suffixAsset: Assets.arrow_forward,
      onPressed: () {
        Navigator.pushNamed(context, Routes.changePass);
      },
    );
  }

  Widget _biometricsSwitch() {
    return (_userDevice != null && biometricsUtil.canCheckBiometrics && biometricsUtil.availableBiometricsCount > 0)
        ? StadiumContainer(
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
      _enabledBtnSave =
          _selectedBirthDate != null && _lastNameController.text.length > 0 && _firstNameController.text.length > 0;
    });
  }

  _buttonSave() {
    return !Func.visibleKeyboard(context)
        ? CustomButton(
            style: CustomButtonStyle.Secondary,
            text: LocaleKeys.save,
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.marginBottom),
            onPressed: _enabledBtnSave
                ? () {
                    var request = UpdateUserDataRequest()
                      ..lastName = _lastNameController.text
                      ..firstName = _firstNameController.text
                      ..birthday = Func.toDateStr(_selectedBirthDate!)
                      ..userGender = _genderValue ? Gender.Female : Gender.Male;

                    BlocManager.userBloc.add(UpdateUserDataEvent(request));
                  }
                : null,
          )
        : Container();
  }
}
