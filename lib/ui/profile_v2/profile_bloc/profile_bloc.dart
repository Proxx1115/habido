import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/mood_tracker_monthly_reason_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInit());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetMonthlyReasonEvent) {
      yield* _mapGetMonthlyReasonEventToState(event);
    }
  }

  Stream<ProfileState> _mapGetMonthlyReasonEventToState(GetMonthlyReasonEvent event) async* {
    try {
      yield MoodMonthlyReasonLoading();

      var res = await ApiManager.monthlyReason(event.year, event.month);
      print("Monthly Reason:${res.negativeReasons} ${res.positiveReasons} ${res.totalMoodCount}");
      if (res.code == ResponseCode.Success) {
        yield MoodMonthlyReasonSuccess(res);
      } else {
        yield MoodMonthlyReasonEmpty();
      }
    } catch (e) {
      yield ModdMonthlyReasonFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// BLOC EVENTS
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetMonthlyReasonEvent extends ProfileEvent {
  final int year;
  final int month;

  const GetMonthlyReasonEvent(this.year, this.month);

  @override
  List<Object> get props => [year, month];

  @override
  String toString() => 'GetMonthlyReasonEvent { year & month: $year $month }';
}

/// BLOC STATES
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInit extends ProfileState {}

/// MOOD MONTHLY REASON STATES

class MoodMonthlyReasonLoading extends ProfileState {}

class MoodMonthlyReasonEmpty extends ProfileState {}

class MoodMonthlyReasonSuccess extends ProfileState {
  final MoodTrackerMonthlyReasonResponse specificMoodTrackerReasonResponse;

  const MoodMonthlyReasonSuccess(
    this.specificMoodTrackerReasonResponse,
  );

  @override
  List<Object> get props => [specificMoodTrackerReasonResponse];

  @override
  String toString() => 'ContentListSuccess { contentList: $specificMoodTrackerReasonResponse}';
}

class ModdMonthlyReasonFailed extends ProfileState {
  final String message;

  const ModdMonthlyReasonFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ContentListFailed { message: $message }';
}
