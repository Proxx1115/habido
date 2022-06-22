import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    if (event is GetAdviceVideoEvent) {
      yield* _mapGetAdviceVideoEventToState();
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
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HomeNewEvent extends Equatable {
  const HomeNewEvent();

  @override
  List<Object> get props => [];
}

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
