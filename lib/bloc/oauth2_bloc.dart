import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/addOauth.dart';
import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/models/login_response.dart';
import 'package:habido_app/models/oauthResponse.dart';
import 'package:habido_app/models/sign_up_phone_request.dart';
import 'package:habido_app/models/sign_up_verify_code_request.dart';
import 'package:habido_app/models/sign_up_register_request.dart';
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

class OAuthBloc extends Bloc<OAuthEvent, OAuthState> {
  OAuthBloc() : super(AuthInit());

  @override
  Stream<OAuthState> mapEventToState(OAuthEvent event) async* {
    if (event is LoginEvent) {
      yield* _mapLoginEventToState(event.request);
    }
  }

  Stream<OAuthState> _mapLoginEventToState(AddOauth request) async* {
    try {
      yield OAuthLoading();
      OAuthResponse res = await ApiManager.userOauth2(request);
      if (res.code == ResponseCode.Success) {
        /// Session хадгалах
        SharedPref.setSessionToken(res.token!);

        /// Get user data
        var userData = await ApiManager.getUserData();
        if (userData.code == ResponseCode.Success) {
          print("usrdataa ::::::::::::::$res");
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

  Stream<OAuthState> _mapLogoutEventToState() async* {
    try {
      await ApiManager.logout();
      await afterLogout();
      yield LogoutSuccess();
    } catch (e) {
      yield LogoutFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<OAuthState> _mapSessionTimeoutEventToState() async* {
    yield SessionTimeoutState();
    OAuthBloc.afterLogout();
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
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class OAuthEvent extends Equatable {
  const OAuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpPhoneEvent extends OAuthEvent {
  final SignUpPhoneRequest request;

  const SignUpPhoneEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SignUpEvent { request: $request }';
}

class SignUpPhoneResendEvent extends OAuthEvent {
  final SignUpPhoneRequest request;

  const SignUpPhoneResendEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SignUpPhoneResendEvent { request: $request }';
}

class SignUpVerifyCodeEvent extends OAuthEvent {
  final SignUpVerifyCodeRequest request;

  const SignUpVerifyCodeEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SignUpVerifyCodeEvent { request: $request }';
}

class SignUpRegisterEvent extends OAuthEvent {
  final SignUpRegisterRequest request;

  const SignUpRegisterEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SignUpRegisterEvent { request: $request }';
}

class LoginEvent extends OAuthEvent {
  final AddOauth request;

  const LoginEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'LoginEvent { request: $request }';
}

class LogoutEvent extends OAuthEvent {}

class SessionTimeoutEvent extends OAuthEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class OAuthState extends Equatable {
  const OAuthState();

  @override
  List<Object> get props => [];
}

class AuthInit extends OAuthState {}

class AuthDefault extends OAuthState {}

class OAuthLoading extends OAuthState {}

class LoginSuccess extends OAuthState {
  final OAuthResponse response;

  const LoginSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'LoginSuccess { response: $response }';
}

class LoginFailed extends OAuthState {
  final String message;

  const LoginFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'LoginFailed { message: $message }';
}

class LogoutSuccess extends OAuthState {}

class LogoutFailed extends OAuthState {
  final String message;

  const LogoutFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'LogoutFailed { message: $message }';
}

class SessionTimeoutState extends OAuthState {}

class BiometricsChangedState extends OAuthState {
  final bool biometricsAuth;

  const BiometricsChangedState(this.biometricsAuth);

  @override
  List<Object> get props => [biometricsAuth];

  @override
  String toString() =>
      'BiometricsChangedState { biometricsAuth: $biometricsAuth }';
}
