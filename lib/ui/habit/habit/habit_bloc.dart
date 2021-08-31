import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit_category.dart';
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
    }
  }

  Stream<HabitState> _mapReminderSwitchChangedEventEventToState(GoalSwitchChangedEvent event) async* {
    yield GoalSwitchChangedState(event.value);
    yield HabitVoid();
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
