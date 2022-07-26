import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/mood_tracker_answer.dart';
import 'package:habido_app/models/mood_tracker_question.dart';
import 'package:habido_app/models/mood_tracker_save_request.dart';
import 'package:habido_app/models/onboarding_save_request.dart';
import 'package:habido_app/models/onboarding_save_response.dart';
import 'package:habido_app/models/onboarding_start_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  OnBoardingBloc() : super(OnBoardingInit());

  @override
  Stream<OnBoardingState> mapEventToState(OnBoardingEvent event) async* {
    if (event is GetOnBoardingEvent) {
      yield* _mapGetOnBoardingQuestEventToState();
    } else if (event is SaveOnBoardingEvent) {
      yield* _mapSaveOnBoardingEventToState(event);
    }
  }

  Stream<OnBoardingState> _mapGetOnBoardingQuestEventToState() async* {
    try {
      yield GetOnBoardingQuestLoading();

      OnBoardingStartResponse res = await ApiManager.getOnBoardingQuestion();
      if (res.code == ResponseCode.Success) {
        yield GetOnBoardingQuestSuccess(res);
      } else {
        yield GetOnBoardingQuestFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetOnBoardingQuestFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<OnBoardingState> _mapSaveOnBoardingEventToState(SaveOnBoardingEvent event) async* {
    try {
      yield OnBoardingSaveLoading();

      OnBoardingSaveResponse res = await ApiManager.saveOnBoarding(event.request);
      if (res.code == ResponseCode.Success) {
        yield OnBoardingSaveSuccess(res);
      } else {
        yield OnBoardingSaveFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield OnBoardingSaveFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();

  @override
  List<Object> get props => [];
}

class GetOnBoardingEvent extends OnBoardingEvent {}

class SaveOnBoardingEvent extends OnBoardingEvent {
  final OnBoardingSaveRequest request;

  const SaveOnBoardingEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SaveOnBoardingEvent { request: $request }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

class OnBoardingInit extends OnBoardingState {}

class GetOnBoardingQuestLoading extends OnBoardingState {}

class GetOnBoardingQuestSuccess extends OnBoardingState {
  final OnBoardingStartResponse onBoardingStartResponse;

  const GetOnBoardingQuestSuccess(this.onBoardingStartResponse);

  @override
  List<Object> get props => [onBoardingStartResponse];

  @override
  String toString() => 'MoodTrackerQuestSuccess { moodTrackerQuestion: $onBoardingStartResponse }';
}

class GetOnBoardingQuestFailed extends OnBoardingState {
  final String message;

  const GetOnBoardingQuestFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MoodTrackerQuestFailed { message: $message }';
}

/// Mood Tracker Save
class OnBoardingSaveLoading extends OnBoardingState {}

class OnBoardingSaveSuccess extends OnBoardingState {
  final OnBoardingSaveResponse onBoardingSaveResponse;

  const OnBoardingSaveSuccess(this.onBoardingSaveResponse);

  @override
  List<Object> get props => [onBoardingSaveResponse];

  @override
  String toString() => 'OnBoardingSaveSuccess { onBoardingSaveResponse: $onBoardingSaveResponse }';
}

class OnBoardingSaveFailed extends OnBoardingState {
  final String message;

  const OnBoardingSaveFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'OnBoardingSaveFailed { message: $message }';
}
