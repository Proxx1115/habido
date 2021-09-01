import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/psy_tests_response.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HabitProgressBloc extends Bloc<HabitProgressEvent, HabitProgressState> {
  HabitProgressBloc() : super(HabitProgressInit());

  @override
  Stream<HabitProgressState> mapEventToState(HabitProgressEvent event) async* {
    if (event is SaveUserHabitProgressEvent) {
      yield* _mapGetHabitsEventToState(event);
    }
  }

  Stream<HabitProgressState> _mapGetHabitsEventToState(SaveUserHabitProgressEvent event) async* {
    try {
      yield HabitProgressLoading();

      var res = await ApiManager.saveUserHabitProgress(event.request);
      if (res.code == ResponseCode.Success) {
        yield SaveUserHabitProgressSuccess();
      } else {
        yield SaveUserHabitProgressFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield SaveUserHabitProgressFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitProgressEvent extends Equatable {
  const HabitProgressEvent();

  @override
  List<Object> get props => [];
}

class SaveUserHabitProgressEvent extends HabitProgressEvent {
  final SaveUserHabitProgressRequest request;

  const SaveUserHabitProgressEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SaveUserHabitProgressEvent { request: $request }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitProgressState extends Equatable {
  const HabitProgressState();

  @override
  List<Object> get props => [];
}

class HabitProgressInit extends HabitProgressState {}

class HabitProgressLoading extends HabitProgressState {}

class SaveUserHabitProgressSuccess extends HabitProgressState {}

class SaveUserHabitProgressFailed extends HabitProgressState {
  final String message;

  const SaveUserHabitProgressFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SaveUserHabitProgressFailed { message: $message }';
}
