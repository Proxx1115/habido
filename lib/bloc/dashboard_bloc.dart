import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit_template.dart';
import 'package:habido_app/models/skip_user_habit_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/showcase_helper.dart';

import 'bloc_manager.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(UserHabitInit());

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is RefreshDashboardUserHabits) {
      yield* _mapRefreshDashboardUserHabitsToState();
    } else if (event is SkipUserHabitEvent) {
      yield* _mapSkipUserHabitEventToState(event);
    } else if (event is GetUserHabitByDateEvent) {
      yield* _mapGetUserHabitByDateEventToState(event);
    } else if (event is GetHabitTemplateListEvent) {
      yield* _mapGetHabitTemplateListEventToState(event);
    }
  }

  Stream<DashboardState> _mapRefreshDashboardUserHabitsToState() async* {
    try {
      yield DashboardUserHabitsLoading();

      var today = DateTime.now();
      var tomorrow = DateTime.now().add(Duration(days: 1));

      var res = await ApiManager.userHabitsByDates(Func.toDateStr(today), Func.toDateStr(tomorrow));
      if (res.code == ResponseCode.Success) {
        if (res.userHabitsByDateList != null && res.userHabitsByDateList!.isNotEmpty) {
          List<UserHabit>? todayUserHabits;
          List<UserHabit>? tomorrowUserHabits;

          for (var el in res.userHabitsByDateList!) {
            if (el.date != null && el.userHabits != null && el.userHabits!.isNotEmpty) {
              if (Func.isSameDay(Func.toDate(el.date!), today)) {
                todayUserHabits = el.userHabits!;
              } else if (Func.isSameDay(Func.toDate(el.date!), tomorrow)) {
                tomorrowUserHabits = el.userHabits!;
              }
            }
          }

          yield RefreshDashboardUserHabitsSuccess(
            todayUserHabits: todayUserHabits,
            tomorrowUserHabits: tomorrowUserHabits,
          );
        } else {
          yield RefreshDashboardUserHabitsSuccess(todayUserHabits: [], tomorrowUserHabits: []);
        }
      } else {
        yield RefreshDashboardUserHabitsFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield RefreshDashboardUserHabitsFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<DashboardState> _mapSkipUserHabitEventToState(SkipUserHabitEvent event) async* {
    try {
      yield DashboardUserHabitsLoading();

      var res = await ApiManager.skipUserHabit(event.skipUserHabitRequest);
      if (res.code == ResponseCode.Success) {
        // Refresh dashboard
        BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());
        BlocManager.dashboardBloc.add(GetUserHabitByDateEvent(DateTime.now().toString()));

        yield SkipUserHabitSuccess();
      } else {
        yield SkipUserHabitFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield SkipUserHabitFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<DashboardState> _mapGetUserHabitByDateEventToState(GetUserHabitByDateEvent event) async* {
    try {
      yield DashboardUserHabitsLoading();

      var res = await ApiManager.userHabitsByDate(event.date);
      if (res.code == ResponseCode.Success) {
        // Refresh dashboard
        yield GetUserHabitByDateSuccess(userHabits: res.userHabitList);
      } else {
        yield GetUserHabitByDateFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield GetUserHabitByDateFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<DashboardState> _mapGetHabitTemplateListEventToState(GetHabitTemplateListEvent event) async* {
    try {
      yield DashboardUserHabitsLoading();

      var res = await ApiManager.dashboardHabitTemplates();
      if (res.code == ResponseCode.Success) {
        // Refresh dashboard
        yield GetHabitTemplateListSuccess(habitTemplates: res.habitTemplateList);
      } else {
        yield GetHabitTemplateListFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield GetUserHabitByDateFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class RefreshDashboardUserHabits extends DashboardEvent {}

class GetUserHabitByDateEvent extends DashboardEvent {
  final String date;

  const GetUserHabitByDateEvent(this.date);

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'GetUserHabitByDate { date: $date }';
}

class GetHabitTemplateListEvent extends DashboardEvent {}

class SkipUserHabitEvent extends DashboardEvent {
  final SkipUserHabitRequest skipUserHabitRequest;

  const SkipUserHabitEvent(this.skipUserHabitRequest);

  @override
  List<Object> get props => [skipUserHabitRequest];

  @override
  String toString() => 'SkipUserHabitEvent { skipUserHabitRequest: $skipUserHabitRequest }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class UserHabitInit extends DashboardState {}

class UserHabitLoading extends DashboardState {}

class UserHabitDefault extends DashboardState {}

class DashboardUserHabitsLoading extends DashboardState {}

class RefreshDashboardUserHabitsSuccess extends DashboardState {
  final List<UserHabit>? todayUserHabits;
  final List<UserHabit>? tomorrowUserHabits;

  const RefreshDashboardUserHabitsSuccess({this.todayUserHabits, this.tomorrowUserHabits});

  @override
  List<Object> get props => [todayUserHabits ?? [], tomorrowUserHabits ?? []];

  @override
  String toString() => 'RefreshDashboardUserHabitsSuccess { todayUserHabits: $todayUserHabits, tomorrowUserHabits: $tomorrowUserHabits }';
}

class GetUserHabitByDateSuccess extends DashboardState {
  final List<UserHabit>? userHabits;

  const GetUserHabitByDateSuccess({this.userHabits});

  @override
  List<Object> get props => [userHabits ?? []];

  @override
  String toString() => 'GetUserHabitByDateSuccess { userHabits: $userHabits}';
}

class GetUserHabitByDateFailed extends DashboardState {
  final String message;

  const GetUserHabitByDateFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetUserHabitByDateFailed { message: $message }';
}

class GetHabitTemplateListSuccess extends DashboardState {
  final List<HabitTemplate>? habitTemplates;

  const GetHabitTemplateListSuccess({this.habitTemplates});

  @override
  List<Object> get props => [habitTemplates ?? []];

  @override
  String toString() => 'GetHabitTemplateListSuccess { habitTemplates: $habitTemplates}';
}

class GetHabitTemplateListFailed extends DashboardState {
  final String message;

  const GetHabitTemplateListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetHabitTemplateListFailed { message: $message }';
}

class RefreshDashboardUserHabitsFailed extends DashboardState {
  final String message;

  const RefreshDashboardUserHabitsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'RefreshDashboardUserHabitsFailed { message: $message }';
}

class SkipUserHabitSuccess extends DashboardState {}

class SkipUserHabitFailed extends DashboardState {
  final String message;

  const SkipUserHabitFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SkipUserHabitFailed { message: $message }';
}
