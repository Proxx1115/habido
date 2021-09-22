import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/change_phone_request.dart';
import 'package:habido_app/models/forgot_password_request.dart';
import 'package:habido_app/models/verify_phone_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/code_input.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class VerifyPasswordRoute extends StatefulWidget {
  final String phoneNumber;
  final int userId;

  const VerifyPasswordRoute({
    Key? key,
    required this.phoneNumber,
    required this.userId,
  }) : super(key: key);

  @override
  _VerifyPasswordRouteState createState() => _VerifyPasswordRouteState();
}

class _VerifyPasswordRouteState extends State<VerifyPasswordRoute> {
  // Code
  String? _code = '';

  // Countdown timer
  CountdownTimerController? _countdownTimerController;
  int _countdownSec = 60;
  late int _endTime;

  // Button resend code
  bool _enabledBtnResend = false;

  // Button next
  bool _enabledBtnNext = false;

  @override
  void initState() {
    super.initState();

    // Timer
    WidgetsBinding.instance?.addPostFrameCallback((_) => _startCountDown(_countdownSec));
  }

  @override
  void dispose() {
    _countdownTimerController?.dispose();
    super.dispose();
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
              appBarTitle: LocaleKeys.resetPassword,
              loading: state is AuthLoading,
              child: (_countdownTimerController != null)
                  ? Column(
                      children: [
                        RoundedCornerListView(
                          padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.padding),
                          children: [
                            /// Танд мессежээр ирсэн 4-н оронтой кодыг оруулна уу
                            CustomText(
                              LocaleKeys.pleaseEnterVerifyCode,
                              maxLines: 4,
                              margin: EdgeInsets.only(top: 20.0),
                              alignment: Alignment.center,
                            ),

                            /// Код
                            _codeInput(),

                            /// Цаг
                            _timer(),

                            /// Button resend
                            _buttonResend()
                          ],
                        ),

                        /// Button save
                        _buttonNext(),
                      ],
                    )
                  : Container(),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AuthState state) {
    if (state is ForgotPasswordResendCodeSuccess) {
      print('ResendCodeSuccess');
    } else if (state is ForgotPasswordResendCodeFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _codeInput() {
    return Container(
      alignment: Alignment.center,
      child: CustomCodeInput(
        margin: EdgeInsets.only(top: 35.0),
        onChanged: (value) {
          _code = value;
          _validateForm();
        },
        onFilled: (value) {
          _code = value;
          _validateForm();

          Func.hideKeyboard(context);

          _onPressedBtnNext();
        },
      ),
    );
  }

  Widget _timer() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 25.0),
      child: CountdownTimer(
        controller: _countdownTimerController,
        onEnd: _onEndCountDown,
        endTime: _endTime,
        widgetBuilder: (BuildContext context, CurrentRemainingTime? time) {
          return CustomText(
            '${time?.min != null ? time?.min.toString().padLeft(2, '0') : '00'}:${time?.sec != null ? time?.sec.toString().padLeft(2, '0') : '00'}',
            alignment: Alignment.center,
            fontWeight: FontWeight.w500,
          );
        },
        endWidget: CustomText(
          '00 : 00',
          color: customColors.primaryText,
          alignment: Alignment.center,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _startCountDown(int sec) {
    setState(() {
      _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * sec;
      _countdownTimerController = CountdownTimerController(endTime: _endTime, onEnd: _onEndCountDown);
    });
  }

  _onEndCountDown() {
    setState(() => _enabledBtnResend = true);
  }

  _buttonResend() {
    return CustomButton(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 25.0),
      style: CustomButtonStyle.Secondary,
      borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
      text: LocaleKeys.resendVerifyCode,
      onPressed: _enabledBtnResend
          ? () {
              _startCountDown(_countdownSec);
              setState(() => _enabledBtnResend = false);

              var request = ForgotPasswordRequest()..phone = widget.phoneNumber;
              BlocManager.authBloc.add(ForgotPasswordResendCodeEvent(request));
            }
          : null,
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = (_code != null && _code?.length == 4);
    });
  }

  _buttonNext() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      asset: Assets.long_arrow_next,
      margin: EdgeInsets.only(right: SizeHelper.margin, bottom: SizeHelper.marginBottom),
      onPressed: _enabledBtnNext
          ? () {
              _onPressedBtnNext();
            }
          : null,
    );
  }

  _onPressedBtnNext() {
    Func.hideKeyboard(context);

    if (!_enabledBtnNext) return;

    Navigator.pushNamed(context, Routes.forgotPassChange, arguments: {
      'userId': widget.userId,
      'phoneNumber': widget.phoneNumber,
      'code': _code,
    });
  }
}
