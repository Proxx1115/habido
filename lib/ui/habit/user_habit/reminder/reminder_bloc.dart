import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  bool switchValue = false;
  List<TimeOfDay> timeOfDayList = [];

  ReminderBloc() : super(ReminderInit());

  @override
  Stream<ReminderState> mapEventToState(ReminderEvent event) async* {
    if (event is ReminderSwitchChangedEvent) {
      yield* _mapReminderSwitchChangedEventEventToState(event);
    } else if (event is AddReminderEvent) {
      yield* _mapAddReminderEventToState(event);
    } else if (event is RemoveReminderEvent) {
      yield* _mapRemoveReminderEventToState(event);
    }
  }

  Stream<ReminderState> _mapReminderSwitchChangedEventEventToState(ReminderSwitchChangedEvent event) async* {
    switchValue = event.value;
    yield ReminderSwitchChangedState(switchValue);
    yield ReminderVoid();
  }

  Stream<ReminderState> _mapAddReminderEventToState(AddReminderEvent event) async* {
    if (!timeOfDayList.contains(event.timeOfDay)) timeOfDayList.add(event.timeOfDay);
    // todo sort
    yield AddReminderSuccessState();
    yield ReminderVoid();
  }

  Stream<ReminderState> _mapRemoveReminderEventToState(RemoveReminderEvent event) async* {
    timeOfDayList.remove(event.timeOfDay);
    yield RemoveReminderSuccessState();
    yield ReminderVoid();
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

class ReminderSwitchChangedEvent extends ReminderEvent {
  final bool value;

  const ReminderSwitchChangedEvent(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'SwitchChangedEvent { value: $value }';
}

class AddReminderEvent extends ReminderEvent {
  final TimeOfDay timeOfDay;

  const AddReminderEvent(this.timeOfDay);

  @override
  List<Object> get props => [timeOfDay];

  @override
  String toString() => 'AddReminderEvent { timeOfDay: $timeOfDay }';
}

class RemoveReminderEvent extends ReminderEvent {
  final TimeOfDay timeOfDay;

  const RemoveReminderEvent(this.timeOfDay);

  @override
  List<Object> get props => [timeOfDay];

  @override
  String toString() => 'RemoveReminderEvent { timeOfDay: $timeOfDay }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object> get props => [];
}

class ReminderInit extends ReminderState {}

class ReminderVoid extends ReminderState {}

class ReminderSwitchChangedState extends ReminderState {
  final bool value;

  const ReminderSwitchChangedState(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'SwitchChangedState { value: $value }';
}

class AddReminderSuccessState extends ReminderState {}

class RemoveReminderSuccessState extends ReminderState {}
