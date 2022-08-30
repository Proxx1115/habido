import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/change_password_request.dart';
import 'package:habido_app/ui/profile_v2/user_info/text_field_action_item.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class ChangePasswordRoute extends StatefulWidget {
  const ChangePasswordRoute({Key? key}) : super(key: key);

  @override
  _ChangePasswordRouteState createState() => _ChangePasswordRouteState();
}

class _ChangePasswordRouteState extends State<ChangePasswordRoute> {
  // Хуучин нууц үг
  // Бусад dispose хийгдээгүй TextField-үүдээс нэрийг нь өөр өгөх хэрэгтэй
  final _oldPsController = TextEditingController();

  // Нууц үг
  final _psController = TextEditingController();

  // Нууц үг давтах
  final _psRepeatController = TextEditingController();

  // Button save
  bool _enabledBtnSave = false;

  final _phoneNumberController = TextEditingController();

  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _oldPsController.addListener(() => _validateForm());
    _psController.addListener(() => _validateForm());
    _psRepeatController.addListener(() => _validateForm());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: _blocListener,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return CustomScaffold(
              appBarTitle: LocaleKeys.userInfo,
              loading: state is AuthLoading,
              child: Container(
                padding: SizeHelper.screenPadding,
                child: Column(
                  children: [
                    CustomText(
                      "Нууц үг",
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                    CustomText(
                      "солих",
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 20),

                    /// Хуучин нууц үг
                    // _oldPassTextField(),
                    _oldPassTextFieldNew(),
                    const SizedBox(height: 10),

                    /// Шинэ нууц үг
                    // _passTextField(),
                    _passTextFieldNew(),
                    const SizedBox(height: 10),

                    /// Шинэ нууц үг давтах
                    // _passRepeatTextField(),
                    _passRepeatTextFieldNew(),
                    const SizedBox(height: 10),

                    Expanded(child: Container()),

                    /// Button save
                    _buttonSave(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AuthState state) {
    if (state is ChangePasswordSuccess) {
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
    } else if (state is ChangePasswordFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _oldPassTextFieldNew() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: SvgPicture.asset(
            Assets.password,
            height: 18,
            width: 15,
            color: customColors.primary,
          ),
        ),
        Expanded(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _oldPsController,
            onChanged: (val) {
              setState(() {});
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
              // hintStyle: TextStyles.hintDisabledText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: customColors.primary, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFDDDFE3),
                  width: 2,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFDDDFE3),
                  width: 2,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFFF0319),
                  width: 2,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFFF0319),
                  width: 2,
                ),
              ),
              alignLabelWithHint: true,
              hintText: LocaleKeys.oldPassword,

              suffixIcon: TextFieldActionItem(
                asset: Assets.clear,
                onClick: () {
                  _oldPsController.text = '';
                  setState(() {});
                },
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Нууц үг хоосон байна';
              }
              // else if (value.length < 6) {
              //   return 'Нууц үг хамгийн багадаа 6 тэмдэгт байна';
              // }
              else {
                return null;
              }
            },
            obscureText: _obscure,
          ),
        ),
      ],
    );
  }

  _passTextFieldNew() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: SvgPicture.asset(
            Assets.password,
            height: 18,
            width: 15,
            color: customColors.primary,
          ),
        ),
        Expanded(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _psController,
            onChanged: (val) {
              setState(() {});
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
              // hintStyle: TextStyles.hintDisabledText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: customColors.primary, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFDDDFE3),
                  width: 2,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFDDDFE3),
                  width: 2,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFFF0319),
                  width: 2,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFFF0319),
                  width: 2,
                ),
              ),
              alignLabelWithHint: true,
              hintText: LocaleKeys.password,

              suffixIcon: TextFieldActionItem(
                asset: Assets.clear,
                onClick: () {
                  _psController.text = '';
                  setState(() {});
                },
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Нууц үг хоосон байна';
              } else if (value.length < 6) {
                return 'Нууц үг хамгийн багадаа 6 тэмдэгт байна';
              } else {
                return null;
              }
            },
            obscureText: _obscure,
          ),
        ),
      ],
    );
  }

  _passRepeatTextFieldNew() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: SvgPicture.asset(
            Assets.password,
            height: 18,
            width: 15,
            color: customColors.primary,
          ),
        ),
        Expanded(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _psRepeatController,
            onChanged: (val) {
              setState(() {});
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
              // hintStyle: TextStyles.hintDisabledText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: customColors.primary, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFDDDFE3),
                  width: 2,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFDDDFE3),
                  width: 2,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFFF0319),
                  width: 2,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFFF0319),
                  width: 2,
                ),
              ),
              alignLabelWithHint: true,
              hintText: LocaleKeys.passwordRepeat,

              suffixIcon: TextFieldActionItem(
                asset: Assets.clear,
                onClick: () {
                  _psRepeatController.text = '';
                  setState(() {});
                },
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Нууц үг хоосон байна';
              } else if (value.length < 6) {
                return 'Нууц үг хамгийн багадаа 6 тэмдэгт байна';
              } else {
                return null;
              }
            },
            obscureText: _obscure,
          ),
        ),
      ],
    );
  }

  _oldPassTextField() {
    return CustomTextField(
      controller: _oldPsController,
      hintText: LocaleKeys.oldPassword,
      margin: EdgeInsets.only(top: 15.0),
      suffixAsset: Assets.edit,
      obscureText: true,
    );
  }

  _passTextField() {
    return CustomTextField(
      controller: _psController,
      hintText: LocaleKeys.password,
      margin: EdgeInsets.only(top: 15.0),
      suffixAsset: Assets.edit,
      obscureText: true,
    );
  }

  _passRepeatTextField() {
    return CustomTextField(
      controller: _psRepeatController,
      hintText: LocaleKeys.passwordRepeat,
      margin: EdgeInsets.only(top: 15.0),
      suffixAsset: Assets.edit,
      obscureText: true,
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnSave = _oldPsController.text.length > 0 && _psController.text.length > 7 && _psRepeatController.text.length > 7;
    });
  }

  _buttonSaveOld() {
    return CustomButton(
      style: CustomButtonStyle.secondary,
      text: LocaleKeys.save,
      onPressed: _enabledBtnSave
          ? () {
              // Validation
              if (_psController.text != _psRepeatController.text) {
                showCustomDialog(
                  context,
                  child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.passwordsDoesNotMatch, buttonText: LocaleKeys.ok),
                );

                return;
              }
              var request = ChangePasswordRequest()
                ..oldPassword = _oldPsController.text
                ..newPassword = _psController.text;

              BlocManager.authBloc.add(ChangePasswordEvent(request));
            }
          : null,
    );
  }

  _buttonSave() {
    return CustomButton(
      margin: EdgeInsets.fromLTRB(45.0, 0, 45.0, 30.0),
      fontWeight: FontWeight.w700,
      alignment: Alignment.bottomCenter,
      text: LocaleKeys.save,
      borderRadius: BorderRadius.circular(15.0),
      onPressed: _enabledBtnSave
          ? () {
              // Validation
              if (_psController.text != _psRepeatController.text) {
                showCustomDialog(
                  context,
                  child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.passwordsDoesNotMatch, buttonText: LocaleKeys.ok),
                );

                return;
              }
              var request = ChangePasswordRequest()
                ..oldPassword = _oldPsController.text
                ..newPassword = _psController.text;

              BlocManager.authBloc.add(ChangePasswordEvent(request));
            }
          : null,
    );
  }
}
