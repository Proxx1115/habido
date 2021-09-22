import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/sign_up_phone_request.dart';
import 'package:habido_app/models/sign_up_register_request.dart';
import 'package:habido_app/models/sign_up_verify_code_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/code_input.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

/// Sign up step 2
class SignUp2CodeRoute extends StatefulWidget {
  final SignUpRegisterRequest signUpRegisterRequest;

  const SignUp2CodeRoute({Key? key, required this.signUpRegisterRequest}) : super(key: key);

  @override
  _SignUp2CodeRouteState createState() => _SignUp2CodeRouteState();
}

class _SignUp2CodeRouteState extends State<SignUp2CodeRoute> {
  // UI
  final _signUp2CodeKey = GlobalKey<ScaffoldState>();

  // Countdown timer
  CountdownTimerController? _countdownTimerController;
  int _countdownSec = 60;
  int? _endTime;

  // Button resend code
  bool _enabledBtnResend = false;

  // Code input
  String? _code = '';

  // Button next
  bool _enabledBtnNext = false;

  @override
  void initState() {
    super.initState();

    // Timer
    WidgetsBinding.instance?.addPostFrameCallback((_) => _startCountDown(_countdownSec));
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
              scaffoldKey: _signUp2CodeKey,
              appBarTitle: LocaleKeys.yourRegistration,
              padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
              child: Column(
                children: [
                  /// Танд мессежээр ирсэн 4-н оронтой кодыг оруулна уу.
                  CustomText(LocaleKeys.enterCode, alignment: Alignment.center, maxLines: 2),

                  /// Code input
                  _codeInput(),

                  /// Цаг
                  _timer(),

                  /// Button resend
                  _buttonResend(),

                  Spacer(),

                  /// Button next
                  _buttonNext(),
                  //_enabledBtnNext
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AuthState state) {
    if (state is SignUpVerifyCodeSuccess) {
      Navigator.pushNamed(context, Routes.signUp3Profile, arguments: {
        'signUpRegisterRequest': widget.signUpRegisterRequest,
      });
    } else if (state is SignUpVerifyCodeFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is SignUpPhoneResendSuccess) {
      print('SignUpPhoneResendSuccess');
    } else if (state is SignUpPhoneResendFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _codeInput() {
    return CustomCodeInput(
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
    );
  }

  Widget _timer() {
    return _endTime != null
        ? Container(
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
          )
        : Container();
  }

  _startCountDown(int sec) {
    setState(() {
      _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * sec;
      _countdownTimerController = CountdownTimerController(endTime: _endTime!, onEnd: _onEndCountDown);
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

              var request = SignUpPhoneRequest()..phone = widget.signUpRegisterRequest.phoneNumber;
              BlocManager.authBloc.add(SignUpPhoneResendEvent(request));
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
      onPressed: _enabledBtnNext
          ? () {
              _onPressedBtnNext();
            }
          : null,
    );
  }

  _onPressedBtnNext() {
    if (!_enabledBtnNext) return;

    BlocManager.authBloc.add(
      SignUpVerifyCodeEvent(
        SignUpVerifyCodeRequest()
          ..userId = widget.signUpRegisterRequest.userId
          ..code = _code,
      ),
    );
  }
}
