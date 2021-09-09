import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class PlanTermsBloc extends Bloc<PlanTermsEvent, PlanTermsState> {
  PlanTermsBloc() : super(PlanTermsInit());

  @override
  Stream<PlanTermsState> mapEventToState(PlanTermsEvent event) async* {
    if (event is ChangePlanTermEvent) {
      yield* _mapChangePlanTermEventToState(event);
    } else if (event is ChangeWeekDaySelectionEvent) {
      yield* _mapChangeWeekDaySelectionEventToState(event);
    } else if (event is ChangeMonthDaySelectionEvent) {
      yield* _mapMonthDaySelectionChangedStateToState(event);
    }
  }

  Stream<PlanTermsState> _mapChangePlanTermEventToState(ChangePlanTermEvent event) async* {
    yield PlanTermChangedState(event.planTerm);
  }

  Stream<PlanTermsState> _mapChangeWeekDaySelectionEventToState(ChangeWeekDaySelectionEvent event) async* {
    yield WeekDaySelectionChangedState(event.index, event.isSelected);
    yield PlanTermsVoid();
  }

  Stream<PlanTermsState> _mapMonthDaySelectionChangedStateToState(ChangeMonthDaySelectionEvent event) async* {
    yield MonthDaySelectionChangedState(event.index, event.isSelected);
    yield PlanTermsVoid();
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PlanTermsEvent extends Equatable {
  const PlanTermsEvent();

  @override
  List<Object> get props => [];
}

class ChangePlanTermEvent extends PlanTermsEvent {
  final String planTerm;

  const ChangePlanTermEvent(this.planTerm);

  @override
  List<Object> get props => [planTerm];

  @override
  String toString() => 'ChangePlanTermEvent { planTerm: $planTerm }';
}

class ChangeWeekDaySelectionEvent extends PlanTermsEvent {
  final int index;
  final bool isSelected;

  const ChangeWeekDaySelectionEvent(this.index, this.isSelected);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'ChangeWeekDaySelectionEvent { index: $index, isSelected: $isSelected }';
}

class ChangeMonthDaySelectionEvent extends PlanTermsEvent {
  final int index;
  final bool isSelected;

  const ChangeMonthDaySelectionEvent(this.index, this.isSelected);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'ChangeMonthDaySelectionEvent { index: $index, isSelected: $isSelected }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class PlanTermsState extends Equatable {
  const PlanTermsState();

  @override
  List<Object> get props => [];
}

class PlanTermsInit extends PlanTermsState {}

class PlanTermsVoid extends PlanTermsState {}

class PlanTermChangedState extends PlanTermsState {
  final String planTerm;

  const PlanTermChangedState(this.planTerm);

  @override
  List<Object> get props => [planTerm];

  @override
  String toString() => 'PlanTermChangedState { planTerm: $planTerm }';
}

class WeekDaySelectionChangedState extends PlanTermsState {
  final int index;
  final bool isSelected;

  const WeekDaySelectionChangedState(this.index, this.isSelected);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'WeekDaySelectionChangedState { index: $index, isSelected: $isSelected }';
}

class MonthDaySelectionChangedState extends PlanTermsState {
  final int index;
  final bool isSelected;

  const MonthDaySelectionChangedState(this.index, this.isSelected);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'MonthDaySelectionChangedState { index: $index, isSelected: $isSelected }';
}
