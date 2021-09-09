import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class UserHabitBloc extends Bloc<UserHabitEvent, UserHabitState> {
  UserHabitBloc() : super(UserHabitInit());

  @override
  Stream<UserHabitState> mapEventToState(UserHabitEvent event) async* {
    if (event is GoalSwitchChangedEvent) {
      yield* _mapReminderSwitchChangedEventEventToState(event);
    } else if (event is InsertUserHabitEvent) {
      yield* _mapInsertUserHabitEventToState(event);
    } else if (event is UpdateUserHabitEvent) {
      yield* _mapUpdateUserHabitEventToState(event);
    } else if (event is SaveUserHabitProgressEvent) {
      yield* _mapSaveUserHabitProgressEventToState(event);
    }
  }

  Stream<UserHabitState> _mapReminderSwitchChangedEventEventToState(GoalSwitchChangedEvent event) async* {
    yield GoalSwitchChangedState(event.value);
    yield UserHabitDefault();
  }

  Stream<UserHabitState> _mapInsertUserHabitEventToState(InsertUserHabitEvent event) async* {
    try {
      yield UserHabitLoading();

      var res = await ApiManager.insertUserHabit(event.userHabit);
      if (res.code == ResponseCode.Success) {
        yield InsertUserHabitSuccess();
      } else {
        yield InsertUserHabitFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield InsertUserHabitFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapUpdateUserHabitEventToState(UpdateUserHabitEvent event) async* {
    try {
      yield UserHabitLoading();

      var res = await ApiManager.updateUserHabit(event.userHabit);
      if (res.code == ResponseCode.Success) {
        yield UpdateUserHabitSuccess(event.userHabit);
      } else {
        yield UpdateUserHabitFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield UpdateUserHabitFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapSaveUserHabitProgressEventToState(SaveUserHabitProgressEvent event) async* {
    try {
      yield UserHabitProgressLoading();

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

abstract class UserHabitEvent extends Equatable {
  const UserHabitEvent();

  @override
  List<Object> get props => [];
}

class ChangePlanTermEvent extends UserHabitEvent {
  final String planTerm;

  const ChangePlanTermEvent(this.planTerm);

  @override
  List<Object> get props => [planTerm];

  @override
  String toString() => 'ChangePlanTermEvent { planTerm: $planTerm }';
}

class GoalSwitchChangedEvent extends UserHabitEvent {
  final bool value;

  const GoalSwitchChangedEvent(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'GoalSwitchChangedEvent { value: $value }';
}

class InsertUserHabitEvent extends UserHabitEvent {
  final UserHabit userHabit;

  const InsertUserHabitEvent(this.userHabit);

  @override
  List<Object> get props => [userHabit];

  @override
  String toString() => 'InsertUserHabitEvent { userHabit: $userHabit }';
}

class UpdateUserHabitEvent extends UserHabitEvent {
  final UserHabit userHabit;

  const UpdateUserHabitEvent(this.userHabit);

  @override
  List<Object> get props => [userHabit];

  @override
  String toString() => 'UpdateUserHabitEvent { userHabit: $userHabit }';
}

class SaveUserHabitProgressEvent extends UserHabitEvent {
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

abstract class UserHabitState extends Equatable {
  const UserHabitState();

  @override
  List<Object> get props => [];
}

class UserHabitInit extends UserHabitState {}

class UserHabitLoading extends UserHabitState {}

class UserHabitDefault extends UserHabitState {}

class PlanTermChangedState extends UserHabitState {
  final String planTerm;

  const PlanTermChangedState(this.planTerm);

  @override
  List<Object> get props => [planTerm];

  @override
  String toString() => 'PlanTermChangedState { planTerm: $planTerm }';
}

class GoalSwitchChangedState extends UserHabitState {
  final bool value;

  const GoalSwitchChangedState(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'GoalSwitchChangedState { value: $value }';
}

class InsertUserHabitSuccess extends UserHabitState {}

class InsertUserHabitFailed extends UserHabitState {
  final String message;

  const InsertUserHabitFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'InsertUserHabitFailed { messages: $message }';
}

class UpdateUserHabitSuccess extends UserHabitState {
  final UserHabit userHabit;

  const UpdateUserHabitSuccess(this.userHabit);

  @override
  List<Object> get props => [userHabit];

  @override
  String toString() => 'UpdateUserHabitSuccess { userHabit: $userHabit }';
}

class UpdateUserHabitFailed extends UserHabitState {
  final String message;

  const UpdateUserHabitFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'UpdateUserHabitFailed { message: $message }';
}

class UserHabitProgressLoading extends UserHabitState {}

class SaveUserHabitProgressSuccess extends UserHabitState {}

class SaveUserHabitProgressFailed extends UserHabitState {
  final String message;

  const SaveUserHabitProgressFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SaveUserHabitProgressFailed { message: $message }';
}
