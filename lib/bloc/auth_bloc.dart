import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/models/login_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_router.dart';
import 'package:habido_app/utils/biometric_helper.dart';
import 'package:habido_app/utils/shared_pref.dart';

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
    }

    // else if (event is SignUp) {
    //   yield* _mapSignUpToState(event.request);
    // } else if (event is Verify) {
    //   yield* _mapVerifyToState(event.request);
    // } else if (event is ForgotPass) {
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
      await biometricHelper.initBiometric();

      yield SetBiometrics(
        canCheckBiometrics: biometricHelper.canCheckBiometrics,
        availableBiometrics: biometricHelper.availableBiometrics,
      );
    } on PlatformException catch (e) {
      print(e);
      yield SetBiometrics(
        canCheckBiometrics: false,
        availableBiometrics: 0,
      );
    }
  }

  Stream<AuthState> _mapLoginEventToState(LoginRequest request) async* {
    try {
      yield AuthLoading();

      LoginResponse res = await ApiRouter.login(request);
      if (res.code == ResponseCode.Success) {
        /// Session хадгалах
        SharedPref.saveSessionToken(res.token!);

        /// Get user data
        // var userDataResponse = await ApiRouter.getUserData();
        // if (userDataResponse.code == ResponseCode.Success) {
        //   await afterLogin();
        //
        //   yield LoginSuccess(res);
        // } else {
        //   yield LoginFailed(res.message);
        // }
      } else {
        // yield LoginFailed(res.message);
      }
    } catch (e) {
      // yield LoginFailed(CustomText.errorOccurred);
    }
  }

// static Future afterLogin() async {
//   ApiManager.getParam();
//   ApiManager.custPhotos();
//   DeviceHelper.registerDeviceToken();
// }
//
// Stream<AuthState> _mapSignUpToState(SignUpRequest request) async* {
//   try {
//     yield AuthLoading();
//     var res = await ApiManager.signUp(request);
//     if (res.code == ResponseCode.Success) {
//       yield SignUpSuccess(res);
//     } else {
//       yield SignUpFailed(res.message);
//     }
//   } catch (e) {
//     yield SignUpFailed(CustomText.errorOccurred);
//   }
// }
//
// Stream<AuthState> _mapVerifyToState(VerifyRequest request) async* {
//   try {
//     yield AuthLoading();
//     var res = await ApiManager.verify(request);
//     if (res.code == ResponseCode.Success) {
//       yield VerifySuccess(res);
//     } else {
//       yield VerifyFailed(res.message);
//     }
//   } catch (e) {
//     yield VerifyFailed(CustomText.errorOccurred);
//   }
// }
//
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

class LoginEvent extends AuthEvent {
  final LoginRequest request;

  const LoginEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'LoginEvent { request: $request }';
}

// class SignUp extends AuthEvent {
//   final SignUpRequest request;
//
//   const SignUp(this.request);
//
//   @override
//   List<Object> get props => [request];
//
//   @override
//   String toString() => 'SignUp { request: $request }';
// }
//
// class Verify extends AuthEvent {
//   final VerifyRequest request;
//
//   const Verify(this.request);
//
//   @override
//   List<Object> get props => [request];
//
//   @override
//   String toString() => 'Verify { request: $request }';
// }
//
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
  final int availableBiometrics;

  const SetBiometrics({
    this.canCheckBiometrics = false,
    this.availableBiometrics = 0,
  });

  @override
  List<Object> get props => [canCheckBiometrics, availableBiometrics];

  @override
  String toString() => 'SetBiometrics { canCheckBiometrics: $canCheckBiometrics, availableBiometrics: $availableBiometrics }';
}

// class SignUpSuccess extends AuthState {
//   final SignUpResponse response;
//
//   const SignUpSuccess([this.response]);
//
//   @override
//   List<Object> get props => [response];
//
//   @override
//   String toString() => 'SignUpSuccess { SignUpResponse: $response }';
// }
//
// class SignUpFailed extends AuthState {
//   final String msg;
//
//   const SignUpFailed([this.msg]);
//
//   @override
//   List<Object> get props => [msg];
//
//   @override
//   String toString() => 'SignUpFailed { msg: $msg }';
// }
//
// class VerifySuccess extends AuthState {
//   final BaseResponse response;
//
//   const VerifySuccess([this.response]);
//
//   @override
//   List<Object> get props => [response];
//
//   @override
//   String toString() => 'VerifySuccess { BaseResponse: $response }';
// }
//
// class VerifyFailed extends AuthState {
//   final String msg;
//
//   const VerifyFailed([this.msg]);
//
//   @override
//   List<Object> get props => [msg];
//
//   @override
//   String toString() => 'VerifyFailed { msg: $msg }';
// }
//
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

// class LoginSuccess extends AuthState {
//   final LoginResponse? response;
//
//   const LoginSuccess([this.response]);
//
//   @override
//   List<Object> get props => [response];
//
//   @override
//   String toString() => 'LoginSuccess { BaseResponse: $response }'`;
// }

// class LoginFailed extends AuthState {
//   final String message;
//
//   const LoginFailed([this.message]);
//
//   @override
//   List<Object> get props => [message];
//
//   @override
//   String toString() => 'LoginFailed { msg: $message }';
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
