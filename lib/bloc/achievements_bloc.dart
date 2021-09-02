import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/achievements_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  AchievementBloc() : super(AchievementInit());

  @override
  Stream<AchievementState> mapEventToState(AchievementEvent event) async* {
    if (event is GetAchievementsEvent) {
      yield* _mapGetAchievementsEventToState();
    }
  }

  Stream<AchievementState> _mapGetAchievementsEventToState() async* {
    try {
      yield AchievementLoading();

      var res = await ApiManager.achievements();
      if (res.code == ResponseCode.Success) {
        yield AchievementsSuccess(res);
      } else {
        yield AchievementsFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield AchievementsFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class AchievementEvent extends Equatable {
  const AchievementEvent();

  @override
  List<Object> get props => [];
}

class GetAchievementsEvent extends AchievementEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class AchievementState extends Equatable {
  const AchievementState();

  @override
  List<Object> get props => [];
}

class AchievementInit extends AchievementState {}

class AchievementLoading extends AchievementState {}

class AchievementsSuccess extends AchievementState {
  final AchievementsResponse response;

  const AchievementsSuccess(this.response);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'AchievementsResponse { response: $response }';
}

class AchievementsFailed extends AchievementState {
  final String message;

  const AchievementsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AchievementsFailed { message: $message }';
}
