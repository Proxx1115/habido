import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/models/param_response.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInit());

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    if (event is GetCalendarEvent) {
      yield* _mapGetCalendarEventToState(event);
    } else if (event is GetCalendarDateEvent) {
      yield* _mapGetCalendarDateEventToState(event);
    }
  }

  Stream<CalendarState> _mapGetCalendarEventToState(GetCalendarEvent event) async* {
    try {
      yield CalendarLoading();

      var res = await ApiManager.calendar(event.startDate, event.endDate);
      if (res.code == ResponseCode.Success) {
        if (res.dateList != null && res.dateList!.isNotEmpty) {
          var dateList = <DateTime>[];
          for (var el in res.dateList!) {
            var tempDate = Func.toDate(el);
            if (tempDate != null) dateList.add(DateTime(tempDate.year, tempDate.month, tempDate.day));
          }

          yield CalendarSuccess(dateList);
        }
      } else {
        yield CalendarFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield CalendarFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<CalendarState> _mapGetCalendarDateEventToState(GetCalendarDateEvent event) async* {
    try {
      // yield CalendarLoading();

      var res = await ApiManager.calendarDate(event.date);
      if (res.code == ResponseCode.Success) {
        if (res.userHabitList != null && res.userHabitList!.isNotEmpty) {
          yield CalendarDateSuccess(res.userHabitList!);
        }
      } else {
        yield CalendarDateFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield CalendarDateFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class GetCalendarEvent extends CalendarEvent {
  final String startDate;
  final String endDate;

  const GetCalendarEvent(this.startDate, this.endDate);

  @override
  List<Object> get props => [startDate, endDate];

  @override
  String toString() => 'GetCalendarEvent { startDate: $startDate, endDate: $endDate }';
}

class GetCalendarDateEvent extends CalendarEvent {
  final String date;

  const GetCalendarDateEvent(this.date);

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'GetCalendarDateEvent { date: $date }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInit extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarSuccess extends CalendarState {
  final List<DateTime> dateList;

  const CalendarSuccess(this.dateList);

  @override
  List<Object> get props => [dateList];

  @override
  String toString() => 'CalendarSuccess { dateList: $dateList }';
}

class CalendarFailed extends CalendarState {
  final String message;

  const CalendarFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'CalendarFailed { message: $message }';
}

class CalendarDateSuccess extends CalendarState {
  final List<UserHabit> userHabitList;

  const CalendarDateSuccess(this.userHabitList);

  @override
  List<Object> get props => [userHabitList];

  @override
  String toString() => 'CalendarDateSuccess { userHabitList: $userHabitList }';
}

class CalendarDateFailed extends CalendarState {
  final String message;

  const CalendarDateFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'CalendarDateFailed { message: $message }';
}
