import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class DatePickerBloc extends Bloc<DatePickerEvent, DatePickerState> {
  DatePickerBloc() : super(DatePickerInit());

  @override
  Stream<DatePickerState> mapEventToState(DatePickerEvent event) async* {
    if (event is DatePickedEvent) {
      yield* _mapDatePickedEventToState(event);
    }
  }

  Stream<DatePickerState> _mapDatePickedEventToState(DatePickedEvent event) async* {
    yield DatePickedState(event.pickedDate);
    yield DatePickerDefault();
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class DatePickerEvent extends Equatable {
  const DatePickerEvent();

  @override
  List<Object> get props => [];
}

class DatePickedEvent extends DatePickerEvent {
  final DateTime pickedDate;

  const DatePickedEvent(this.pickedDate);

  @override
  List<Object> get props => [pickedDate];

  @override
  String toString() => 'DatePickedEvent { pickedDate: $pickedDate }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class DatePickerState extends Equatable {
  const DatePickerState();

  @override
  List<Object> get props => [];
}

class DatePickerInit extends DatePickerState {}

class DatePickerDefault extends DatePickerState {}

class DatePickedState extends DatePickerState {
  final DateTime pickedDate;

  const DatePickedState(this.pickedDate);

  @override
  List<Object> get props => [pickedDate];

  @override
  String toString() => 'DatePickedState { pickedDate: $pickedDate }';
}
