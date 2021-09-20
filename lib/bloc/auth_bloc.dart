import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/change_password_request.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/models/login_response.dart';
import 'package:habido_app/models/sign_up_request.dart';
import 'package:habido_app/models/sign_up_response.dart';
import 'package:habido_app/models/verify_code_request.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/biometric_helper.dart';
import 'package:habido_app/utils/device_helper.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/widgets/dialogs.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInit());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is InitBiometricsEvent) {
      yield* _mapInitBiometricsEvent();
    } else if (event is LoginEvent) {
      yield* _mapLoginEventToState(event.request);
    } else if (event is LogoutEvent) {
      yield* _mapLogoutEventToState();
    } else if (event is SignUpEvent) {
      yield* _mapSignUpEventToState(event.request);
    } else if (event is VerifyCodeEvent) {
      yield* _mapVerifyCodeEventToState(event.request);
    } else if (event is SessionTimeoutEvent) {
      yield* _mapSessionTimeoutEventToState();
    } else if (event is ChangePasswordEvent) {
      yield* _mapChangePasswordEventToState(event);
    }
  }

  Stream<AuthState> _mapInitBiometricsEvent() async* {
    try {
      BiometricHelper biometricHelper = new BiometricHelper();
      await biometricHelper.initBiometrics();

      yield SetBiometrics(biometricHelper.canCheckBiometrics, biometricHelper.availableBiometricsCount);
    } on PlatformException catch (e) {
      print(e);
      yield SetBiometrics(false, 0);
    }
  }

  Stream<AuthState> _mapLoginEventToState(LoginRequest request) async* {
    try {
      yield AuthLoading();

      // yield LoginFailed(LocaleKeys.failed);
      // return;

      LoginResponse res = await ApiManager.login(request);
      if (res.code == ResponseCode.Success) {
        /// Session хадгалах
        SharedPref.setSessionToken(res.token!);

        /// Get user data
        var userData = await ApiManager.getUserData();
        if (userData.code == ResponseCode.Success) {
          // await afterLogin(); // todo test

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
      var res = await ApiManager.logout();
      if (res.code == ResponseCode.Success) {
        await afterLogout();

        yield LogoutSuccess();
      } else {
        yield LogoutFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield LogoutFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapSessionTimeoutEventToState() async* {
    yield SessionTimeoutState();
    AuthBloc.afterLogout();
  }

  static afterLogout() async {
    SharedPref.setSessionToken('');
    globals.clear();
  }

  static showLogoutDialog(BuildContext context) {
    showCustomDialog(
      context,
      child: CustomDialogBody(
        asset: Assets.error,
        text: LocaleKeys.sessionExpired,
        buttonText: LocaleKeys.ok,
        onPressedButton: () {
          afterLogout();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }

  Stream<AuthState> _mapSignUpEventToState(SignUpRequest request) async* {
    try {
      yield AuthLoading();

      var res = await ApiManager.signUp(request);
      if (res.code == ResponseCode.Success) {
        yield SignUpSuccess(res);
      } else {
        yield SignUpFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield SignUpFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapVerifyCodeEventToState(VerifyCodeRequest request) async* {
    try {
      yield AuthLoading();

      // yield VerifyCodeSuccess();
      // return;

      var res = await ApiManager.verifyCode(request);
      if (res.code == ResponseCode.Success) {
        yield VerifyCodeSuccess();
      } else {
        yield VerifyCodeFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield VerifyCodeFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapChangePasswordEventToState(ChangePasswordEvent event) async* {
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
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class InitBiometricsEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final SignUpRequest request;

  const SignUpEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SignUpEvent { request: $request }';
}

class VerifyCodeEvent extends AuthEvent {
  final VerifyCodeRequest request;

  const VerifyCodeEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'VerifyCodeEvent { request: $request }';
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

class SessionTimeoutEvent extends AuthEvent {}

class ChangePasswordEvent extends AuthEvent {
  final ChangePasswordRequest request;

  const ChangePasswordEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'ChangePasswordEvent { request: $request }';
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

class AuthLoading extends AuthState {}

class SetBiometrics extends AuthState {
  final bool canCheckBiometrics;
  final int availableBiometricsCount;

  const SetBiometrics(this.canCheckBiometrics, this.availableBiometricsCount);

  @override
  List<Object> get props => [canCheckBiometrics, availableBiometricsCount];

  @override
  String toString() =>
      'SetBiometrics { canCheckBiometrics: $canCheckBiometrics, availableBiometricsCount: $availableBiometricsCount }';
}

class SignUpSuccess extends AuthState {
  final SignUpResponse response;

  const SignUpSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'SignUpSuccess { SignUpResponse: $response }';
}

class SignUpFailed extends AuthState {
  final String message;

  const SignUpFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SignUpFailed { msg: $message }';
}

class VerifyCodeSuccess extends AuthState {}

class VerifyCodeFailed extends AuthState {
  final String message;

  const VerifyCodeFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'VerifyCodeFailed { msg: $message }';
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

class ChangePasswordSuccess extends AuthState {}

class ChangePasswordFailed extends AuthState {
  final String message;

  const ChangePasswordFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ChangePasswordFailed { message: $message }';
}
