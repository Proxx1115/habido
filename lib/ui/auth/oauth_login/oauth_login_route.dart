import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/onboarding_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class OauthLoginRoute extends StatefulWidget {
  const OauthLoginRoute({Key? key}) : super(key: key);

  @override
  State<OauthLoginRoute> createState() => _OauthLoginRouteState();
}

class _OauthLoginRouteState extends State<OauthLoginRoute> {
  // Bloc
  late OnBoardingBloc _onBoardingBloc;

  // Main
  final _oauthKey = GlobalKey<ScaffoldState>();

  // OnBoardingSaveResponse? _saveResponse;

  // Утасны дугаар эсвэл имэйл
  TextEditingController _phoneNumberController = TextEditingController();

  // Button save
  bool _enabledBtnSave = false;

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(() => _validateForm());

    _onBoardingBloc = OnBoardingBloc();
    _onBoardingBloc.add(GetOnBoardingEvent());
  }

  @override
  void dispose() {
    _onBoardingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: customColors.primaryBackground,
        scaffoldKey: _oauthKey,
        child: BlocProvider.value(
          value: _onBoardingBloc,
          child: BlocListener<OnBoardingBloc, OnBoardingState>(
            listener: _blocListener,
            child: BlocBuilder<OnBoardingBloc, OnBoardingState>(builder: (context, state) {
              return Column(
                // controller: _listScrollController,
                children: [
                  /// Cover image
                  Expanded(
                    child: ListView(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SvgPicture.asset(
                            Assets.oauth,
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),

                        /// Other
                        Container(
                          margin: const EdgeInsets.fromLTRB(SizeHelper.margin, 69.0, SizeHelper.margin, SizeHelper.margin),
                          child: Column(
                            children: [
                              /// Title
                              CustomText(
                                LocaleKeys.login,
                                color: customColors.primaryText,
                                fontWeight: FontWeight.w700,
                                fontSize: 30.0,
                              ),

                              SizedBox(height: 14.0),

                              /// Info
                              CustomText(
                                LocaleKeys.oauthInfo,
                                fontSize: 15.0,
                                maxLines: 5,
                              ),

                              _txtboxPhoneNumber()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  _buttonNext(
                    text: LocaleKeys.continueTxt,
                    onPressed: _phoneNumberController.text.length > 0
                        ? () {
                            _navigateToOtpRoute();
                          }
                        : null,
                  ),
                ],
              );
            }),
          ),
        ));
  }

  _blocListener(BuildContext context, OnBoardingState state) {
    // if (state is OnBoardingSaveSuccess) {
    //   _saveResponse = state.onBoardingSaveResponse;
    // } else if (state is OnBoardingSaveFailed) {
    //   showCustomDialog(
    //     context,
    //     child: CustomDialogBody(
    //       asset: Assets.error,
    //       text: state.message,
    //       buttonText: LocaleKeys.ok,
    //       onPressedButton: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //   );
    // }
  }

  _buttonNext({text, onPressed}) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(15.0),
      margin: EdgeInsets.fromLTRB(45.0, 0, 45.0, 45.0),
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnSave = _phoneNumberController.text.length > 0;
    });
  }

  Widget _txtboxPhoneNumber() {
    return CustomTextField(
      controller: _phoneNumberController,
      hintText: LocaleKeys.phoneNumber,
      margin: EdgeInsets.only(top: 15.0),
      keyboardType: TextInputType.text,
      // backgroundColor: Colors.transparent,
    );
  }

  _navigateToOtpRoute() {
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //   Routes.signUpCompleted,
    //   (Route<dynamic> route) => false,
    // );
    Navigator.of(context).pushNamed(
      Routes.home_new, // todo change to OTP screen
    );
  }
}
