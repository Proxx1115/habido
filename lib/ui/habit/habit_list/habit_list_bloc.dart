import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/psy_tests_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HabitListBloc extends Bloc<HabitListEvent, HabitListState> {
  HabitListBloc() : super(HabitListInit());

  @override
  Stream<HabitListState> mapEventToState(HabitListEvent event) async* {
    if (event is GetHabitsEvent) {
      yield* _mapGetHabitsEventToState(event);
    }
  }

  Stream<HabitListState> _mapGetHabitsEventToState(GetHabitsEvent event) async* {
    try {
      yield HabitListLoading();

      var res = await ApiManager.habits(event.catId);
      if (res.code == ResponseCode.Success && res.habitList != null && res.habitList!.length > 0) {
        yield HabitsSuccess(res.habitList!);
      } else {
        yield HabitsFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield HabitsFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitListEvent extends Equatable {
  const HabitListEvent();

  @override
  List<Object> get props => [];
}

class GetHabitsEvent extends HabitListEvent {
  final int catId;

  const GetHabitsEvent(this.catId);

  @override
  List<Object> get props => [catId];

  @override
  String toString() => 'GetHabitsEvent { catId: $catId }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitListState extends Equatable {
  const HabitListState();

  @override
  List<Object> get props => [];
}

class HabitListInit extends HabitListState {}

class HabitListLoading extends HabitListState {}

class HabitsSuccess extends HabitListState {
  final List<Habit> habitList;

  const HabitsSuccess(this.habitList);

  @override
  List<Object> get props => [habitList];

  @override
  String toString() => 'HabitsSuccess { psyTestsResponse: $habitList }';
}

class HabitsFailed extends HabitListState {
  final String message;

  const HabitsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'HabitsFailed { message: $message }';
}
