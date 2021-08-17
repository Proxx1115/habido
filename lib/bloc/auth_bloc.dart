import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/models/login_response.dart';
import 'package:habido_app/models/sign_up_request.dart';
import 'package:habido_app/models/sign_up_response.dart';
import 'package:habido_app/models/verify_code_request.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_router.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/biometric_helper.dart';
import 'package:habido_app/utils/device_helper.dart';
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
    } else if (event is SignUpEvent) {
      yield* _mapSignUpEventToState(event.request);
    } else if (event is VerifyCodeEvent) {
      yield* _mapVerifyCodeEventToState(event.request);
    }

    //else if (event is ForgotPass) {
    //   yield* _mapForgotPassToState(event.request);
    // } else if (event is ChangePass) {
    //   yield* _mapChangePassToState(event.request);
    // } else if (event is InitBiometrics) {
    //   yield* _mapInitBiometrics();
    // } else if (event is ConnectDevice) {
    //   yield* _mapConnectDeviceToState(event.request);
    // } else if (event is ChangePassEvent) {
    //   yield* _mapChangePassEventToState(event.request);
    // }
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

      yield LoginFailed(LocaleKeys.failed);
      return;

      LoginResponse res = await ApiRouter.login(request);
      if (res.code == ResponseCode.Success) {
        /// Session хадгалах
        SharedPref.setSessionToken(res.token!);

        /// Get user data
        var userData = await ApiRouter.getUserData();
        if (userData.code == ResponseCode.Success) {
          await afterLogin();

          yield LoginSuccess(res);
        } else {
          yield LoginFailed(res.message ?? LocaleKeys.failed);
        }
      } else {
        yield LoginFailed(res.message ?? LocaleKeys.failed);
      }
    } catch (e) {
      yield LoginFailed(LocaleKeys.errorOccurred);
    }
  }

  static Future afterLogin() async {
    DeviceHelper.registerDeviceToken();
  }

  /// Logout
  static showLogoutDialog(BuildContext context) {
    // showCustomDialog(
    //   context,
    //   child: CustomDialogBody(asset: Assets.error, text: state.message, button1Text: LocaleKeys.ok),
    // );

    // showCustomDialog(
    //   context,
    //   bodyText: AppText.sureToLogout,
    //   btnNegativeText: AppText.no,
    //   btnPositiveText: AppText.yes,
    //   onPressedBtnPositive: () {
    //     logout();
    //     Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
    //   },
    // );
  }

  // static Future<void> logout() async {
  //   ApiManager.signOut();
  //
  //   // Session устгах
  //   SharedPrefManager.clearSessionToken();
  //
  //   // Clear user data
  //   globals.clear();
  // }
  //
  // static void handleUserInteraction(AppState state) {
  //   if (Func.isNotEmpty(globals.sessionToken)) {
  //     //
  //   }
  // }

  Stream<AuthState> _mapSignUpEventToState(SignUpRequest request) async* {
    try {
      yield AuthLoading();

      var res = await ApiRouter.signUp(request);
      if (res.code == ResponseCode.Success) {
        yield SignUpSuccess(res);
      } else {
        yield SignUpFailed(res.message ?? LocaleKeys.failed);
      }
    } catch (e) {
      yield SignUpFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AuthState> _mapVerifyCodeEventToState(VerifyCodeRequest request) async* {
    try {
      yield AuthLoading();

      // todo test
      // yield VerifyCodeSuccess();
      // return;

      var res = await ApiRouter.verifyCode(request);
      if (res.code == ResponseCode.Success) {
        yield VerifyCodeSuccess();
      } else {
        yield VerifyCodeFailed(res.message ?? LocaleKeys.failed);
      }
    } catch (e) {
      yield VerifyCodeFailed(LocaleKeys.errorOccurred);
    }
  }

// Stream<AuthState> _mapForgotPassToState(ForgotPassRequest request) async* {
//   try {
//     yield AuthLoading();
//     var res = await ApiManager.forgotPass(request);
//     if (res.code == ResponseCode.Success) {
//       yield ForgotPassSuccess(res);
//     } else {
//       yield ForgotPassFailed(res.message);
//     }
//   } catch (e) {
//     yield ForgotPassFailed(CustomText.errorOccurred);
//   }
// }
//
// Stream<AuthState> _mapChangePassToState(VerifyRequest request) async* {
//   try {
//     yield AuthLoading();
//     var res = await ApiManager.changePass(request);
//     if (res.code == ResponseCode.Success) {
//       yield ChangePassSuccess(res);
//     } else {
//       yield ChangePassFailed(res.message);
//     }
//   } catch (e) {
//     yield ChangePassFailed(CustomText.errorOccurred);
//   }
// }

// Stream<AuthState> _mapConnectDeviceToState(ConnectDeviceRequest request) async* {
//   try {
//     yield AuthLoading();
//     var res = await ApiManager.connectDevice(request);
//     if (res.code == ResponseCode.Success) {
//       yield ConnectDeviceSuccess(res);
//     } else {
//       yield ConnectDeviceFailed(res.message);
//     }
//   } catch (e) {
//     yield ConnectDeviceFailed(CustomText.errorOccurred);
//   }
// }
//
// Stream<AuthState> _mapChangePassEventToState(ChangePassRequest request) async* {
//   try {
//     yield AuthLoading();
//     var res = await ApiManager.changePassSettings(request);
//     if (res.code == ResponseCode.Success) {
//       yield ChangePassSuccessState(res);
//     } else {
//       yield ChangePassFailedState(res.message);
//     }
//   } catch (e) {
//     yield ChangePassFailedState(CustomText.errorOccurred);
//   }
// }
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

// class ForgotPass extends AuthEvent {
//   final ForgotPassRequest request;
//
//   const ForgotPass(this.request);
//
//   @override
//   List<Object> get props => [request];
//
//   @override
//   String toString() => 'ForgotPass { request: $request }';
// }
//
// class ChangePass extends AuthEvent {
//   final VerifyRequest request;
//
//   const ChangePass(this.request);
//
//   @override
//   List<Object> get props => [request];
//
//   @override
//   String toString() => 'ChangePass { request: $request }';
// }
//
// class ChangePassEvent extends AuthEvent {
//   final ChangePassRequest request;
//
//   const ChangePassEvent(this.request);
//
//   @override
//   List<Object> get props => [request];
//
//   @override
//   String toString() => 'ChangePassEvent { request: $request }';
// }

//
// class ConnectDevice extends AuthEvent {
//   final ConnectDeviceRequest request;
//
//   const ConnectDevice(this.request);
//
//   @override
//   List<Object> get props => [request];
//
//   @override
//   String toString() => 'ConnectDevice { request: $request }';
// }

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
  String toString() => 'SetBiometrics { canCheckBiometrics: $canCheckBiometrics, availableBiometricsCount: $availableBiometricsCount }';
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

// class ForgotPassSuccess extends AuthState {
//   final SignUpResponse response;
//
//   const ForgotPassSuccess([this.response]);
//
//   @override
//   List<Object> get props => [response];
//
//   @override
//   String toString() => 'ForgotPassSuccess { response: $response }';
// }
//
// class ForgotPassFailed extends AuthState {
//   final String msg;
//
//   const ForgotPassFailed([this.msg]);
//
//   @override
//   List<Object> get props => [msg];
//
//   @override
//   String toString() => 'VerifyFailed { msg: $msg }';
// }
//
// class ChangePassSuccess extends AuthState {
//   final BaseResponse response;
//
//   const ChangePassSuccess([this.response]);
//
//   @override
//   List<Object> get props => [response];
//
//   @override
//   String toString() => 'ChangePassSuccess { BaseResponse: $response }';
// }
//
// class ChangePassFailed extends AuthState {
//   final String msg;
//
//   const ChangePassFailed([this.msg]);
//
//   @override
//   List<Object> get props => [msg];
//
//   @override
//   String toString() => 'ChangePassFailed { msg: $msg }';
// }

// class ConnectDeviceSuccess extends AuthState {
//   final LoginResponse response;
//
//   const ConnectDeviceSuccess([this.response]);
//
//   @override
//   List<Object> get props => [response];
//
//   @override
//   String toString() => 'ConnectDeviceSuccess { BaseResponse: $response }';
// }
//
// class ConnectDeviceFailed extends AuthState {
//   final String msg;
//
//   const ConnectDeviceFailed([this.msg]);
//
//   @override
//   List<Object> get props => [msg];
//
//   @override
//   String toString() => 'ConnectDeviceFailed { msg: $msg }';
// }
//
// class EmptyState extends AuthState {}
//
// class ChangePassSuccessState extends AuthState {
//   final BaseResponse response;
//
//   const ChangePassSuccessState([this.response]);
//
//   @override
//   List<Object> get props => [response];
//
//   @override
//   String toString() => 'ChangePassSuccessState { BaseResponse: $response }';
// }
//
// class ChangePassFailedState extends AuthState {
//   final String msg;
//
//   const ChangePassFailedState([this.msg]);
//
//   @override
//   List<Object> get props => [msg];
//
//   @override
//   String toString() => 'ChangePassFailedState { msg: $msg }';
// }
