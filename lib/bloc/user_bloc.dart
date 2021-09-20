import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/rank.dart';
import 'package:habido_app/models/update_profile_picture_request.dart';
import 'package:habido_app/models/update_user_data_request.dart';
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
    if (event is GetUserDataEvent) {
      yield* _mapGetUserDataEventToState();
    } else if (event is GetRankList) {
      yield* _mapGetRankListToState();
    } else if (event is NavigateRankEvent) {
      yield* _mapNavigateRankToState(event);
    } else if (event is UpdateProfilePictureEvent) {
      yield* _mapUpdateProfilePictureEventToState(event);
    } else if (event is UpdateUserDataEvent) {
      yield* _mapUpdateUserDataEventToState(event);
    }
  }

  Stream<UserState> _mapGetUserDataEventToState() async* {
    try {
      var res = await ApiManager.getUserData();
      if (res.code == ResponseCode.Success) {
        yield UserDataSuccess(res);
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

  Stream<UserState> _mapUpdateProfilePictureEventToState(UpdateProfilePictureEvent event) async* {
    try {
      var res = await ApiManager.updateProfilePic(event.request);
      if (res.code == ResponseCode.Success) {
        yield UpdateProfilePictureSuccess();
      } else {
        yield UpdateProfilePictureFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield UpdateProfilePictureFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserState> _mapUpdateUserDataEventToState(UpdateUserDataEvent event) async* {
    try {
      var res = await ApiManager.updateUserData(event.request);
      if (res.code == ResponseCode.Success) {
        yield UpdateUserDataSuccess();
      } else {
        yield UpdateUserDataFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield UpdateUserDataFailed(LocaleKeys.errorOccurred);
    }
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

class GetUserDataEvent extends UserEvent {}

class GetRankList extends UserEvent {}

class NavigateRankEvent extends UserEvent {
  final int index;

  const NavigateRankEvent(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'NavigateRank { index: $index }';
}

class UpdateProfilePictureEvent extends UserEvent {
  final UpdateProfilePictureRequest request;

  const UpdateProfilePictureEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'UpdateProfilePictureEvent { request: $request }';
}

class UpdateUserDataEvent extends UserEvent {
  final UpdateUserDataRequest request;

  const UpdateUserDataEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'UpdateUserDataEvent { request: $request }';
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

class UpdateProfilePictureSuccess extends UserState {}

class UpdateProfilePictureFailed extends UserState {
  final String message;

  const UpdateProfilePictureFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'UpdateProfilePictureFailed { message: $message }';
}

class UpdateUserDataSuccess extends UserState {}

class UpdateUserDataFailed extends UserState {
  final String message;

  const UpdateUserDataFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'UpdateUserDataFailed { message: $message }';
}
