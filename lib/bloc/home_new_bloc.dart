import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/mood_tracker.dart';
import 'package:habido_app/models/mood_tracker_last.dart';
import 'package:habido_app/models/tip.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HomeNewBloc extends Bloc<HomeNewEvent, HomeNewState> {
  HomeNewBloc() : super(AdviceVideoInit());

  @override
  Stream<HomeNewState> mapEventToState(HomeNewEvent event) async* {
    if (event is GetMoodTrackerEvent) {
      yield* _mapGetMoodTrackerEventToState();
    } else if (event is GetAdviceVideoEvent) {
      yield* _mapGetAdviceVideoEventToState();
    } else if (event is GetTipEvent) {
      yield* _mapGetTipEventToState();
    }
  }

  Stream<HomeNewState> _mapGetMoodTrackerEventToState() async* {
    try {
      yield MoodTrackerLoading();

      var res = await ApiManager.getMoodTracker();
      print('@@@@@@@@@@@GetMoodTrackerEvent>>>>>>>>>> ${res.moodTrackerList}');

      if (res.code == ResponseCode.Success) {
        yield MoodTrackerSuccess(res.moodTrackerList!);
      } else {
        yield MoodTrackerFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield MoodTrackerFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<HomeNewState> _mapGetAdviceVideoEventToState() async* {
    try {
      yield AdviceVideoLoading();

      var res = await ApiManager.getAdviceVideo();
      if (res.code == ResponseCode.Success) {
        yield AdviceVideoSuccess(res.title!, res.video!);
      } else {
        yield AdviceVideoFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield AdviceVideoFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<HomeNewState> _mapGetTipEventToState() async* {
    try {
      yield AdviceVideoLoading();

      var res = await ApiManager.getTips();
      if (res.code == ResponseCode.Success) {
        print("lalargichi");
        yield TipSuccess(res.tipList!);
      } else {
        yield TipFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield TipFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HomeNewEvent extends Equatable {
  const HomeNewEvent();

  @override
  List<Object> get props => [];
}

class GetMoodTrackerEvent extends HomeNewEvent {}

class GetMoodTrackerLastEvent extends HomeNewEvent {}

class GetTipEvent extends HomeNewEvent {}

class GetAdviceVideoEvent extends HomeNewEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HomeNewState extends Equatable {
  const HomeNewState();

  @override
  List<Object> get props => [];
}

class AdviceVideoInit extends HomeNewState {}

class AdviceVideoLoading extends HomeNewState {}

class MoodTrackerLoading extends HomeNewState {}

class MoodTrackerLastLoading extends HomeNewState {}

class AdviceVideoSuccess extends HomeNewState {
  final String title;
  final String video;

  const AdviceVideoSuccess(this.title, this.video);

  @override
  List<Object> get props => [title, video];

  @override
  String toString() => 'AdviceVideoSuccess { title: $title, video: $video }';
}

class AdviceVideoFailed extends HomeNewState {
  final String message;

  const AdviceVideoFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AdviceVideoFailed { message: $message }';
}

class TipSuccess extends HomeNewState {
  final List<Tip> tipList;

  const TipSuccess(this.tipList);

  @override
  List<Object> get props => [tipList];

  @override
  String toString() => 'TipSuccess { tipList: $tipList }';
}

class TipFailed extends HomeNewState {
  final String message;

  const TipFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'TipFailed { message: $message }';
}

class MoodTrackerSuccess extends HomeNewState {
  final List<MoodTracker> moodTrackerList;

  const MoodTrackerSuccess(this.moodTrackerList);

  @override
  List<Object> get props => [moodTrackerList];

  @override
  String toString() => 'MoodTrackerSuccess { moodTrackerList: $moodTrackerList }';
}

class MoodTrackerFailed extends HomeNewState {
  final String message;

  const MoodTrackerFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MoodTrackerFailed { message: $message }';
}
