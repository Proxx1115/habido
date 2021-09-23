import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/psy_tests_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/showcase_helper.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HabitListBloc extends Bloc<HabitListEvent, HabitListState> {
  HabitListBloc() : super(HabitListInit());

  @override
  Stream<HabitListState> mapEventToState(HabitListEvent event) async* {
    if (event is GetHabitsEvent) {
      yield* _mapGetHabitsEventToState(event);
    } else if (event is HabitListShowcaseEvent) {
      yield* _mapHabitListShowcaseEventToState(event);
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

  Stream<HabitListState> _mapHabitListShowcaseEventToState(HabitListShowcaseEvent event) async* {
    if (!SharedPref.getShowcaseHasShown(event.showcaseKeyName)) {
      List<GlobalKey> keyList = ShowcaseKey.getKeysByName(event.showcaseKeyName);
      if (keyList.isNotEmpty) {
        yield HabitListShowcaseState(keyList);
        SharedPref.setShowcaseHasShown(event.showcaseKeyName, true);
      }
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

class HabitListShowcaseEvent extends HabitListEvent {
  final String showcaseKeyName;

  const HabitListShowcaseEvent(this.showcaseKeyName);

  @override
  List<Object> get props => [showcaseKeyName];

  @override
  String toString() => 'HabitListShowcaseEvent { showcaseKeyName: $showcaseKeyName }';
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

class HabitListShowcaseState extends HabitListState {
  final List<GlobalKey> showcaseKeyList;

  const HabitListShowcaseState(this.showcaseKeyList);

  @override
  List<Object> get props => [showcaseKeyList];

  @override
  String toString() => 'HabitListShowcaseState { showcaseKeyList: $showcaseKeyList }';
}
