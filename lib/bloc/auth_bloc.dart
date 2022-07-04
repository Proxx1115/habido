import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/change_password_request.dart';
import 'package:habido_app/models/change_phone_request.dart';
import 'package:habido_app/models/forgot_password_change_request.dart';
import 'package:habido_app/models/forgot_password_request.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/models/login_response.dart';
import 'package:habido_app/models/sign_up_phone_request.dart';
import 'package:habido_app/models/sign_up_phone_response.dart';
import 'package:habido_app/models/sign_up_verify_code_request.dart';
import 'package:habido_app/models/sign_up_register_request.dart';
import 'package:habido_app/models/user_device.dart';
import 'package:habido_app/models/verify_phone_request.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/device_helper.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/widgets/dialogs.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInit());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield* _mapLoginEventToState(event.request);
    } else if (event is LogoutEvent) {
      yield* _mapLogoutEventToState();
    } else if (event is BiometricsChangedEvent) {
      yield* _mapBiometricsChangedEventToState(event);
    } else if (event is SignUpPhoneEvent) {
      yield* _mapSignUpPhoneEventToState(event.request);
    } else if (event is SignUpPhoneResendEvent) {
      yield* _mapSignUpPhoneResendEventToState(event.request);
    } else if (event is SignUpVerifyCodeEvent) {
      yield* _mapSignUpVerifyCodeEventToState(event);
    } else if (event is SignUpRegisterEvent) {
      yield* _mapSignUpRegisterEventToState(event.request);
    } else if (event is SessionTimeoutEvent) {
      yield* _mapSessionTimeoutEventToState();
    } else if (event is ChangePasswordEvent) {
      yield* _mapChangePasswordEventToState(event);
    } else if (event is ChangePhoneEvent) {
      yield* _mapChangePhoneEventToState(event);
    } else if (event is VerifyPhoneEvent) {
      yield* _mapVerifyPhoneEventToState(event);
    } else if (event is ChangePhoneResendCodeEvent) {
      yield* _mapChangePhoneResendCodeEventToState(event);
    } else if (event is ForgotPasswordEvent) {
      yield* _mapForgotPasswordEventToState(event);
    } else if (event is ForgotPasswordResendCodeEvent) {
      yield* _mapForgotPasswordResendCodeEventToState(event);
    } else if (event is ForgotPasswordChangeEvent) {
      yield* _mapForgotPasswordChangeEventToState(event);
    }
  }

  Stream<AuthState> _mapLoginEventToState(LoginRequest request) async* {
    try {
      yield AuthLoading();

      LoginResponse res = await ApiManager.login(request);
      if (res.code == ResponseCode.Success) {
        /// Session хадгалах
        SharedPref.setSessionToken(res.token!);

        /// Get user data
        var userData = await ApiManager.getUserData();
        if (userData.code == ResponseCode.Success) {
          await afterLogin();

          yield LoginSuccess(res);
        } else {
          yield LoginFailed(ApiHelper.getFailedMessage(res.message));
        }
      } else {
        yield LoginFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield LoginFailed(LocaleKeys.errorOccurred);
    }
  }

  static Future<void> afterLogin() async {
    await DeviceHelper.registerDeviceToken();
  }

  Stream<AuthState> _mapLogoutEventToState() async* {
    try {
      await ApiManager.logout();
      await afterLogout();
      yield LogoutSuccess();
    } catch (e) {
      yield LogoutFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapBiometricsChangedEventToState(
      BiometricsChangedEvent event) async* {
    yield BiometricsChangedState(event.biometricsAuth);
    yield AuthDefault();
  }

  Stream<AuthState> _mapSessionTimeoutEventToState() async* {
    yield SessionTimeoutState();
    AuthBloc.afterLogout();
  }

  static afterLogout() async {
    SharedPref.setSessionToken('');
    globals.clear();
  }

  static showSessionExpiredDialog(BuildContext context) {
    showCustomDialog(
      context,
      child: CustomDialogBody(
        asset: Assets.error,
        text: LocaleKeys.sessionExpired,
        buttonText: LocaleKeys.ok,
        onPressedButton: () {
          afterLogout();
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.login, (Route<dynamic> route) => false);
        },
      ),
    );
  }

  static showLogoutDialog(BuildContext context) {
    showCustomDialog(
      context,
      child: CustomDialogBody(
        asset: Assets.warning,
        text: LocaleKeys.sureToLogout,
        buttonText: LocaleKeys.yes,
        onPressedButton: () async {
          await ApiManager.logout();
          await afterLogout();
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.login2, (Route<dynamic> route) => false);
        },
        button2Text: LocaleKeys.no,
      ),
    );
  }

  Stream<AuthState> _mapSignUpPhoneEventToState(
      SignUpPhoneRequest request) async* {
    try {
      yield AuthLoading();

      SignUpPhoneResponse res = await ApiManager.signUpPhone(request);
      if (res.code == ResponseCode.Success) {
        yield SignUpPhoneSuccess(res);
      } else {
        yield SignUpPhoneFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield SignUpPhoneFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapSignUpPhoneResendEventToState(
      SignUpPhoneRequest request) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.signUpPhone(request);
      if (res.code == ResponseCode.Success) {
        yield SignUpPhoneResendSuccess(res);
      } else {
        yield SignUpPhoneResendFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield SignUpPhoneResendFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapSignUpVerifyCodeEventToState(
      SignUpVerifyCodeEvent event) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.signUpVerifyCode(event.request);
      if (res.code == ResponseCode.Success) {
        yield SignUpVerifyCodeSuccess();
      } else {
        yield SignUpVerifyCodeFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield SignUpVerifyCodeFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapSignUpRegisterEventToState(
      SignUpRegisterRequest request) async* {
    try {
      yield AuthLoading();

      // yield VerifyCodeSuccess();
      // return;

      var res = await ApiManager.signUpRegister(request);
      if (res.code == ResponseCode.Success) {
        yield SignUpRegisterSuccess();
      } else {
        yield SignUpRegisterFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield SignUpRegisterFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapChangePasswordEventToState(
      ChangePasswordEvent event) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.changePassword(event.request);
      if (res.code == ResponseCode.Success) {
        yield ChangePasswordSuccess();
      } else {
        yield ChangePasswordFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield ChangePasswordFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapChangePhoneEventToState(ChangePhoneEvent event) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.changePhone(event.request);
      if (res.code == ResponseCode.Success) {
        yield ChangePhoneSuccess(event.request.phone ?? '');
      } else {
        yield ChangePhoneFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield ChangePhoneFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapVerifyPhoneEventToState(VerifyPhoneEvent event) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.verifyPhone(event.request);
      if (res.code == ResponseCode.Success) {
        yield VerifyPhoneSuccess();
      } else {
        yield VerifyPhoneFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield VerifyPhoneFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapChangePhoneResendCodeEventToState(
      ChangePhoneResendCodeEvent event) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.changePhone(event.request);
      if (res.code == ResponseCode.Success) {
        yield ChangePhoneResendCodeSuccess();
      } else {
        yield ChangePhoneResendCodeFailed(
            ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield ChangePhoneResendCodeFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapForgotPasswordEventToState(
      ForgotPasswordEvent event) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.forgotPassword(event.request);
      if (res.code == ResponseCode.Success) {
        yield ForgotPasswordSuccess(event.request.phone ?? '', res.userId ?? 0);
      } else {
        yield ForgotPasswordFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield ForgotPasswordFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapForgotPasswordResendCodeEventToState(
      ForgotPasswordResendCodeEvent event) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.forgotPassword(event.request);
      if (res.code == ResponseCode.Success) {
        yield ForgotPasswordResendCodeSuccess();
      } else {
        yield ForgotPasswordResendCodeFailed(
            ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield ForgotPasswordResendCodeFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapForgotPasswordChangeEventToState(
      ForgotPasswordChangeEvent event) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.forgotPasswordChange(event.request);
      if (res.code == ResponseCode.Success) {
        yield ForgotPasswordChangeSuccess();
      } else {
        yield ForgotPasswordChangeFailed(
            ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield ForgotPasswordChangeFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpPhoneEvent extends AuthEvent {
  final SignUpPhoneRequest request;

  const SignUpPhoneEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SignUpEvent { request: $request }';
}

class SignUpPhoneResendEvent extends AuthEvent {
  final SignUpPhoneRequest request;

  const SignUpPhoneResendEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SignUpPhoneResendEvent { request: $request }';
}

class SignUpVerifyCodeEvent extends AuthEvent {
  final SignUpVerifyCodeRequest request;

  const SignUpVerifyCodeEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SignUpVerifyCodeEvent { request: $request }';
}

class SignUpRegisterEvent extends AuthEvent {
  final SignUpRegisterRequest request;

  const SignUpRegisterEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SignUpRegisterEvent { request: $request }';
}

class LoginEvent extends AuthEvent {
  final LoginRequest request;

  const LoginEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'LoginEvent { request: $request }';
}

class LogoutEvent extends AuthEvent {}

class BiometricsChangedEvent extends AuthEvent {
  final bool biometricsAuth;

  const BiometricsChangedEvent(this.biometricsAuth);

  @override
  List<Object> get props => [biometricsAuth];

  @override
  String toString() =>
      'BiometricsChangedEvent { biometricsAuth: $biometricsAuth }';
}

class SessionTimeoutEvent extends AuthEvent {}

class ChangePasswordEvent extends AuthEvent {
  final ChangePasswordRequest request;

  const ChangePasswordEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'ChangePasswordEvent { request: $request }';
}

class ChangePhoneEvent extends AuthEvent {
  final ChangePhoneRequest request;

  const ChangePhoneEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'ChangePhoneEvent { request: $request }';
}

class VerifyPhoneEvent extends AuthEvent {
  final VerifyPhoneRequest request;

  const VerifyPhoneEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'VerifyPhoneEvent { request: $request }';
}

class ChangePhoneResendCodeEvent extends AuthEvent {
  final ChangePhoneRequest request;

  const ChangePhoneResendCodeEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'ChangePhoneResendCodeEvent { request: $request }';
}

class ForgotPasswordEvent extends AuthEvent {
  final ForgotPasswordRequest request;

  const ForgotPasswordEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'ForgotPasswordEvent { request: $request }';
}

class ForgotPasswordResendCodeEvent extends AuthEvent {
  final ForgotPasswordRequest request;

  const ForgotPasswordResendCodeEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'ForgotPasswordResendCodeEvent { request: $request }';
}

class ForgotPasswordChangeEvent extends AuthEvent {
  final ForgotPasswordChangeRequest request;

  const ForgotPasswordChangeEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'ForgotPasswordChangeEvent { request: $request }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInit extends AuthState {}

class AuthDefault extends AuthState {}

class AuthLoading extends AuthState {}

class SignUpPhoneSuccess extends AuthState {
  final SignUpPhoneResponse response;

  const SignUpPhoneSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'SignUpPhoneSuccess { SignUpResponse: $response }';
}

class SignUpPhoneFailed extends AuthState {
  final String message;

  const SignUpPhoneFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SignUpPhoneFailed { message: $message }';
}

class SignUpPhoneResendSuccess extends AuthState {
  final SignUpPhoneResponse response;

  const SignUpPhoneResendSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'SignUpPhoneResendSuccess { SignUpResponse: $response }';
}

class SignUpPhoneResendFailed extends AuthState {
  final String message;

  const SignUpPhoneResendFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SignUpPhoneResendFailed { msg: $message }';
}

class SignUpVerifyCodeSuccess extends AuthState {}

class SignUpVerifyCodeFailed extends AuthState {
  final String message;

  const SignUpVerifyCodeFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SignUpVerifyCodeFailed { msg: $message }';
}

class SignUpRegisterSuccess extends AuthState {}

class SignUpRegisterFailed extends AuthState {
  final String message;

  const SignUpRegisterFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SignUpRegisterFailed { msg: $message }';
}

class LoginSuccess extends AuthState {
  final LoginResponse response;

  const LoginSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'LoginSuccess { response: $response }';
}

class LoginFailed extends AuthState {
  final String message;

  const LoginFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'LoginFailed { message: $message }';
}

class LogoutSuccess extends AuthState {}

class LogoutFailed extends AuthState {
  final String message;

  const LogoutFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'LogoutFailed { message: $message }';
}

class SessionTimeoutState extends AuthState {}

class BiometricsChangedState extends AuthState {
  final bool biometricsAuth;

  const BiometricsChangedState(this.biometricsAuth);

  @override
  List<Object> get props => [biometricsAuth];

  @override
  String toString() =>
      'BiometricsChangedState { biometricsAuth: $biometricsAuth }';
}

class ChangePasswordSuccess extends AuthState {}

class ChangePasswordFailed extends AuthState {
  final String message;

  const ChangePasswordFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ChangePasswordFailed { message: $message }';
}

class ChangePhoneSuccess extends AuthState {
  final String phoneNumber;

  const ChangePhoneSuccess(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'ChangePhoneSuccess { phoneNumber: $phoneNumber }';
}

class ChangePhoneFailed extends AuthState {
  final String message;

  const ChangePhoneFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ChangePhoneFailed { message: $message }';
}

class VerifyPhoneSuccess extends AuthState {}

class VerifyPhoneFailed extends AuthState {
  final String message;

  const VerifyPhoneFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'VerifyPhoneFailed { message: $message }';
}

class ChangePhoneResendCodeSuccess extends AuthState {}

class ChangePhoneResendCodeFailed extends AuthState {
  final String message;

  const ChangePhoneResendCodeFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ResendCodeFailed { message: $message }';
}

class ForgotPasswordSuccess extends AuthState {
  final String phoneNumber;
  final int userId;

  const ForgotPasswordSuccess(this.phoneNumber, this.userId);

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() =>
      'ForgotPasswordSuccess { phoneNumber: $phoneNumber, userId: $userId }';
}

class ForgotPasswordFailed extends AuthState {
  final String message;

  const ForgotPasswordFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ResendCodeFailed { message: $message }';
}

class ForgotPasswordResendCodeSuccess extends AuthState {}

class ForgotPasswordResendCodeFailed extends AuthState {
  final String message;

  const ForgotPasswordResendCodeFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ForgotPasswordResendCodeFailed { message: $message }';
}

class ForgotPasswordChangeSuccess extends AuthState {}

class ForgotPasswordChangeFailed extends AuthState {
  final String message;

  const ForgotPasswordChangeFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ForgotPasswordChangeFailed { message: $message }';
}
