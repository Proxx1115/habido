import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc() : super(HabitInit());

  @override
  Stream<HabitState> mapEventToState(HabitEvent event) async* {
    if (event is GoalSwitchChangedEvent) {
      yield* _mapReminderSwitchChangedEventEventToState(event);
    } else if (event is InsertUserHabitEvent) {
      yield* _mapInsertUserHabitEventToState(event);
    }
  }

  Stream<HabitState> _mapReminderSwitchChangedEventEventToState(GoalSwitchChangedEvent event) async* {
    yield GoalSwitchChangedState(event.value);
    yield HabitVoid();
  }

  Stream<HabitState> _mapInsertUserHabitEventToState(InsertUserHabitEvent event) async* {
    try {
      yield HabitLoading();

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
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

class ChangePlanTermEvent extends HabitEvent {
  final String planTerm;

  const ChangePlanTermEvent(this.planTerm);

  @override
  List<Object> get props => [planTerm];

  @override
  String toString() => 'ChangePlanTermEvent { planTerm: $planTerm }';
}

class GoalSwitchChangedEvent extends HabitEvent {
  final bool value;

  const GoalSwitchChangedEvent(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'GoalSwitchChangedEvent { value: $value }';
}

class InsertUserHabitEvent extends HabitEvent {
  final UserHabit userHabit;

  const InsertUserHabitEvent(this.userHabit);

  @override
  List<Object> get props => [userHabit];

  @override
  String toString() => 'InsertUserHabitEvent { userHabit: $userHabit }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

class HabitInit extends HabitState {}

class HabitLoading extends HabitState {}

class HabitVoid extends HabitState {}

class PlanTermChangedState extends HabitState {
  final String planTerm;

  const PlanTermChangedState(this.planTerm);

  @override
  List<Object> get props => [planTerm];

  @override
  String toString() => 'PlanTermChangedState { planTerm: $planTerm }';
}

class GoalSwitchChangedState extends HabitState {
  final bool value;

  const GoalSwitchChangedState(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'GoalSwitchChangedState { value: $value }';
}

class InsertUserHabitSuccess extends HabitState {}

class InsertUserHabitFailed extends HabitState {
  final String message;

  const InsertUserHabitFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'InsertUserHabitFailed { messages: $message }';
}
