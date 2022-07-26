import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/addOauth.dart';
import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  EmailBloc() : super(AuthInit());

  @override
  Stream<EmailState> mapEventToState(EmailEvent event) async* {
    if (event is AddEmailEvent) {
      yield* _mapLoginEventToState(event.request);
    }
  }

  Stream<EmailState> _mapLoginEventToState(AddOauth request) async* {
    try {
      yield OAuthLoading();
      BaseResponse res = await ApiManager.addOauth(request);
      if (res.code == ResponseCode.Success) {
        /// Get user data
        var userData = await ApiManager.getUserData();
        if (userData.code == ResponseCode.Success) {
          print("usrdataa ::::::::::::::$res");

          yield AddEmailSuccess(res);
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
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class EmailEvent extends Equatable {
  const EmailEvent();

  @override
  List<Object> get props => [];
}

class AddEmailEvent extends EmailEvent {
  final AddOauth request;

  const AddEmailEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'LoginEvent { request: $request }';
}

class LogoutEvent extends EmailEvent {}

class SessionTimeoutEvent extends EmailEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class EmailState extends Equatable {
  const EmailState();

  @override
  List<Object> get props => [];
}

class AuthInit extends EmailState {}

class AuthDefault extends EmailState {}

class OAuthLoading extends EmailState {}

class AddEmailSuccess extends EmailState {
  final BaseResponse response;

  const AddEmailSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'LoginSuccess { response: $response }';
}

class LoginFailed extends EmailState {
  final String message;

  const LoginFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'LoginFailed { message: $message }';
}
