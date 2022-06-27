import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/mood_tracker_answer.dart';
import 'package:habido_app/models/mood_tracker_question.dart';
import 'package:habido_app/models/mood_tracker_save_request.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class MoodTrackerBloc extends Bloc<MoodTrackerEvent, MoodTrackerState> {
  MoodTrackerBloc() : super(MoodTrackerQuestInit());

  @override
  Stream<MoodTrackerState> mapEventToState(MoodTrackerEvent event) async* {
    if (event is GetMoodTrackerQuestEvent) {
      yield* _mapGetMoodTrackerQuestEventToState();
    } else if (event is SaveMoodTrackerEvent) {
      yield* _mapSaveMoodTrackerEventToState(event);
    }
  }

  Stream<MoodTrackerState> _mapGetMoodTrackerQuestEventToState() async* {
    try {
      yield MoodTrackerQuestLoading();

      MoodTrackerQuestionResponse res = await ApiManager.getMoodTrackerQuestion();
      if (res.code == ResponseCode.Success) {
        yield MoodTrackerQuestSuccess(res);
      } else {
        yield MoodTrackerQuestFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield MoodTrackerQuestFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<MoodTrackerState> _mapSaveMoodTrackerEventToState(SaveMoodTrackerEvent event) async* {
    try {
      yield MoodTrackerSaveLoading();

      MoodTrackerQuestionResponse res = await ApiManager.saveMoodTracker(event.request);
      if (res.code == ResponseCode.Success) {
        yield MoodTrackerSaveSuccess(res);
      } else {
        yield MoodTrackerSaveFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield MoodTrackerSaveFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class MoodTrackerEvent extends Equatable {
  const MoodTrackerEvent();

  @override
  List<Object> get props => [];
}

class GetMoodTrackerQuestEvent extends MoodTrackerEvent {}

class SaveMoodTrackerEvent extends MoodTrackerEvent {
  final MoodTrackerSaveRequest request;

  const SaveMoodTrackerEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SaveMoodTrackerEvent { request: $request }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class MoodTrackerState extends Equatable {
  const MoodTrackerState();

  @override
  List<Object> get props => [];
}

class MoodTrackerQuestInit extends MoodTrackerState {}

class MoodTrackerQuestLoading extends MoodTrackerState {}

class MoodTrackerQuestSuccess extends MoodTrackerState {
  final MoodTrackerQuestionResponse moodTrackerQuestion;

  const MoodTrackerQuestSuccess(this.moodTrackerQuestion);

  @override
  List<Object> get props => [moodTrackerQuestion];

  @override
  String toString() => 'MoodTrackerQuestSuccess { moodTrackerQuestion: $moodTrackerQuestion }';
}

class MoodTrackerQuestFailed extends MoodTrackerState {
  final String message;

  const MoodTrackerQuestFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MoodTrackerQuestFailed { message: $message }';
}

/// Mood Tracker Save
class MoodTrackerSaveLoading extends MoodTrackerState {}

class MoodTrackerSaveSuccess extends MoodTrackerState {
  final MoodTrackerQuestionResponse moodTrackerQuestion;

  const MoodTrackerSaveSuccess(this.moodTrackerQuestion);

  @override
  List<Object> get props => [moodTrackerQuestion];

  @override
  String toString() => 'MoodTrackerSaveSuccess { moodTrackerQuestion: $moodTrackerQuestion }';
}

class MoodTrackerSaveFailed extends MoodTrackerState {
  final String message;

  const MoodTrackerSaveFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MoodTrackerSaveFailed { message: $message }';
}
