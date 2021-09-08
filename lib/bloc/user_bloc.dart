import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/rank.dart';
import 'package:habido_app/models/user_data.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInit());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GetUserData) {
      yield* _mapGetUserDataToState();
    } else if (event is GetRankList) {
      yield* _mapGetRankListToState();
    } else if (event is NavigateRankEvent) {
      yield* _mapNavigateRankToState(event);
    }
  }

  Stream<UserState> _mapGetUserDataToState() async* {
    try {
      var res = await ApiManager.getUserData();
      if (res.code == ResponseCode.Success) {
      } else {
        yield UserDataFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield UserDataFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserState> _mapGetRankListToState() async* {
    try {
      var res = await ApiManager.rankList();
      if (res.code == ResponseCode.Success) {
        yield RankListSuccess(res.rankList ?? []);
      } else {
        yield UserDataFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield RankListFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserState> _mapNavigateRankToState(NavigateRankEvent event) async* {
    yield NavigateRankState(event.index);
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserData extends UserEvent {}

class GetRankList extends UserEvent {}

class NavigateRankEvent extends UserEvent {
  final int index;

  const NavigateRankEvent(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'NavigateRank { index: $index }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInit extends UserState {}

class UserLoading extends UserState {}

class UserDataSuccess extends UserState {
  final UserData userData;

  const UserDataSuccess(this.userData);

  @override
  List<Object> get props => [userData];

  @override
  String toString() => 'UserDataSuccess { userData: $userData }';
}

class UserDataFailed extends UserState {
  final String message;

  const UserDataFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'UserDataFailed { message: $message }';
}

class RankListSuccess extends UserState {
  final List<Rank> rankList;

  const RankListSuccess(this.rankList);

  @override
  List<Object> get props => [rankList];

  @override
  String toString() => 'RankListSuccess { userData: $rankList }';
}

class RankListFailed extends UserState {
  final String message;

  const RankListFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'RankListFailed { message: $message }';
}

class NavigateRankState extends UserState {
  final int index;

  const NavigateRankState(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'NavigateRankState { index: $index }';
}
