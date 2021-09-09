import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(UserHabitInit());

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is RefreshDashboardUserHabits) {
      yield* _mapRefreshDashboardUserHabitsToState();
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
              todayUserHabits: todayUserHabits, tomorrowUserHabits: tomorrowUserHabits);
        } else {
          yield RefreshDashboardUserHabitsFailed(LocaleKeys.noData);
        }
      } else {
        yield RefreshDashboardUserHabitsFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield RefreshDashboardUserHabitsFailed(LocaleKeys.errorOccurred);
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

class GetUserHabitByDate extends DashboardEvent {
  final String date;

  const GetUserHabitByDate(this.date);

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'GetUserHabitByDate { date: $date }';
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
  String toString() =>
      'RefreshDashboardUserHabitsSuccess { todayUserHabits: $todayUserHabits, tomorrowUserHabits: $tomorrowUserHabits }';
}

class RefreshDashboardUserHabitsFailed extends DashboardState {
  final String message;

  const RefreshDashboardUserHabitsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'RefreshDashboardUserHabitsFailed { message: $message }';
}
