import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/mood_tracker_monthly_stat_response.dart';
import 'package:habido_app/models/mood_tracker_latest.dart';
import 'package:habido_app/models/mood_tracker_latest_response.dart';
import 'package:habido_app/models/mood_tracker_monthly_reason_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

class PerformanceBloc extends Bloc<PerformanceEvent, PerformanceState> {
  PerformanceBloc() : super(PerformanceInit());

  @override
  Stream<PerformanceState> mapEventToState(PerformanceEvent event) async* {
    if (event is GetMonthlyReasonEvent) {
      yield* _mapGetMonthlyReasonEventToState(event);
    } else if (event is GetMoodTrackerLatestEvent) {
      yield* _mapGetMoodTrackerLatestEventToState();
    } else if (event is GetMoodTrackerThenEvent) {
      yield* _mapGetMoodTrackerThenToState(event);
    } else if (event is GetMonthlyStatEvent) {
      yield* _mapGetMonthlyStatEventToState(event);
    }
  }

  Stream<PerformanceState> _mapGetMonthlyReasonEventToState(GetMonthlyReasonEvent event) async* {
    try {
      yield MoodMonthlyReasonLoading();

      var res = await ApiManager.monthlyReason(event.year, event.month);
      print("Monthly Reason2:${res.negativeReasons} ${res.positiveReasons} ${res.totalMoodCount}");
      if (res.code == ResponseCode.Success) {
        yield MoodMonthlyReasonSuccess(res);
      } else {
        yield MoodMonthlyReasonEmpty();
      }
    } catch (e) {
      yield ModdMonthlyReasonFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<PerformanceState> _mapGetMoodTrackerLatestEventToState() async* {
    try {
      yield MoodTrackerLatestLoading();

      var res = await ApiManager.moodTrackerLatest();
      if (res.code == ResponseCode.Success) {
        yield MoodTrackerLatestSuccess(res.moodTracker!);
      } else {
        yield MoodTrackerLatestEmpty();
      }
    } catch (e) {
      yield ModdTrackerLatestFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<PerformanceState> _mapGetMoodTrackerThenToState(GetMoodTrackerThenEvent event) async* {
    try {
      yield MoodTrackerThenLoading();

      var res = await ApiManager.moodTrackerThen(event.userFeelingId);
      if (res.code == ResponseCode.Success) {
        yield MoodTrackerThenSuccess(res.moodTracker!);
      } else {
        yield ModdTrackerThenFailed(LocaleKeys.errorOccurred);
      }
    } catch (e) {
      yield ModdTrackerThenFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<PerformanceState> _mapGetMonthlyStatEventToState(GetMonthlyStatEvent event) async* {
    try {
      yield MoodMonthlyStatLoading();
      print("Monthly Stat1:");
      var res = await ApiManager.moodTrackerMonthlyStat(event.year, event.month);
      print("Monthly Stat2:${res}");
      if (res.code == ResponseCode.Success) {
        yield MoodMonthlyStatSuccess(res);
      } else {
        yield MoodMonthlyStatEmpty();
      }
    } catch (e) {
      yield ModdMonthlyStatFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// BLOC EVENTS
abstract class PerformanceEvent extends Equatable {
  const PerformanceEvent();

  @override
  List<Object> get props => [];
}

class GetMonthlyReasonEvent extends PerformanceEvent {
  final int year;
  final int month;

  const GetMonthlyReasonEvent(this.year, this.month);

  @override
  List<Object> get props => [year, month];

  @override
  String toString() => 'GetMonthlyReasonEvent { year & month: $year $month }';
}

class GetMoodTrackerLatestEvent extends PerformanceEvent {}

class GetMoodTrackerThenEvent extends PerformanceEvent {
  final int userFeelingId;

  const GetMoodTrackerThenEvent(this.userFeelingId);

  @override
  List<Object> get props => [userFeelingId];

  @override
  String toString() => 'GetMoodTrackerThenEvent { userFeelingId: $userFeelingId }';
}

class GetMonthlyStatEvent extends PerformanceEvent {
  final int year;
  final int month;

  const GetMonthlyStatEvent(this.year, this.month);

  @override
  List<Object> get props => [year, month];

  @override
  String toString() => 'GetMonthlyStatEvent { year & month: $year $month }';
}

/// BLOC STATES
abstract class PerformanceState extends Equatable {
  const PerformanceState();

  @override
  List<Object> get props => [];
}

class PerformanceInit extends PerformanceState {}

/// MOOD MONTHLY REASON STATES

class MoodMonthlyReasonLoading extends PerformanceState {}

class MoodMonthlyReasonEmpty extends PerformanceState {}

class MoodMonthlyReasonSuccess extends PerformanceState {
  final MoodTrackerMonthlyReasonResponse specificMoodTrackerReasonResponse;

  const MoodMonthlyReasonSuccess(
    this.specificMoodTrackerReasonResponse,
  );

  @override
  List<Object> get props => [specificMoodTrackerReasonResponse];

  @override
  String toString() => 'ContentListSuccess { contentList: $specificMoodTrackerReasonResponse}';
}

class ModdMonthlyReasonFailed extends PerformanceState {
  final String message;

  const ModdMonthlyReasonFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}

/// MOOD TRACKER LATEST STATES

class MoodTrackerLatestLoading extends PerformanceState {}

class MoodTrackerLatestEmpty extends PerformanceState {}

class MoodTrackerLatestSuccess extends PerformanceState {
  final List<MoodTrackerLatest> moodTracker;

  const MoodTrackerLatestSuccess(
    this.moodTracker,
  );

  @override
  List<Object> get props => [moodTracker];

  @override
  String toString() => 'MoodTrackerLatestSuccess { moodTracker: $moodTracker}';
}

class ModdTrackerLatestFailed extends PerformanceState {
  final String message;

  const ModdTrackerLatestFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}

/// MOOD TRACKER THEN STATES

class MoodTrackerThenLoading extends PerformanceState {}

class MoodTrackerThenEmpty extends PerformanceState {}

class MoodTrackerThenSuccess extends PerformanceState {
  final List<MoodTrackerLatest> moodTracker;

  const MoodTrackerThenSuccess(
    this.moodTracker,
  );

  @override
  List<Object> get props => [moodTracker];

  @override
  String toString() => 'MoodTrackerThenSuccess { moodTracker: $moodTracker}';
}

class ModdTrackerThenFailed extends PerformanceState {
  final String message;

  const ModdTrackerThenFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}

/// MOOD MONTHLY STAT STATES

class MoodMonthlyStatLoading extends PerformanceState {}

class MoodMonthlyStatEmpty extends PerformanceState {}

class MoodMonthlyStatSuccess extends PerformanceState {
  final MoodTrackerMonthlyStatResponse calendarMonthDaysResponse;

  const MoodMonthlyStatSuccess(
    this.calendarMonthDaysResponse,
  );

  @override
  List<Object> get props => [calendarMonthDaysResponse];

  @override
  String toString() => 'MoodMonthlyStatSuccess { calendarMonthDaysResponse: $calendarMonthDaysResponse}';
}

class ModdMonthlyStatFailed extends PerformanceState {
  final String message;

  const ModdMonthlyStatFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}
