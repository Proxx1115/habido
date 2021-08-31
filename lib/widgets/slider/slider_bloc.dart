import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  final double minValue;
  final double maxValue;
  double value;
  double step;

  SliderBloc({
    required this.minValue,
    required this.maxValue,
    required this.value,
    this.step = 1.0,
  }) : super(SliderInit());

  @override
  Stream<SliderState> mapEventToState(SliderEvent event) async* {
    if (event is SliderChangedEvent) {
      yield* _mapSliderChangedEventToState(event);
    } else if (event is SliderIncreaseEvent) {
      yield* _mapSliderIncreaseEventToState(event);
    } else if (event is SliderDecreaseEvent) {
      yield* _mapSliderDecreaseEventToState(event);
    }
  }

  Stream<SliderState> _mapSliderChangedEventToState(SliderChangedEvent event) async* {
    value = event.value;
    yield SliderChangedState(event.value);
    yield SliderVoid();
  }

  Stream<SliderState> _mapSliderIncreaseEventToState(SliderIncreaseEvent event) async* {
    value = event.value + step;
    yield SliderChangedState(event.value);
    yield SliderVoid();
  }

  Stream<SliderState> _mapSliderDecreaseEventToState(SliderDecreaseEvent event) async* {
    value = event.value - step;
    yield SliderChangedState(event.value);
    yield SliderVoid();
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class SliderEvent extends Equatable {
  const SliderEvent();

  @override
  List<Object> get props => [];
}

class SliderChangedEvent extends SliderEvent {
  final double value;

  const SliderChangedEvent(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'SliderChangedEvent { value: $value }';
}

class SliderIncreaseEvent extends SliderEvent {
  final double value;

  const SliderIncreaseEvent(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'SliderIncreaseEvent { value: $value }';
}

class SliderDecreaseEvent extends SliderEvent {
  final double value;

  const SliderDecreaseEvent(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'SliderDecreaseEvent { value: $value }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class SliderState extends Equatable {
  const SliderState();

  @override
  List<Object> get props => [];
}

class SliderInit extends SliderState {}

class SliderVoid extends SliderState {}

class SliderChangedState extends SliderState {
  final double value;

  const SliderChangedState(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'SliderChangedState { value: $value }';
}
