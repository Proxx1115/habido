import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/dictionary.dart';
import 'package:habido_app/models/get_dict_request.dart';
import 'package:habido_app/models/rank.dart';
import 'package:habido_app/models/update_profile_picture_request.dart';
import 'package:habido_app/models/update_user_data_request.dart';
import 'package:habido_app/models/user_data.dart';
import 'package:habido_app/models/user_device.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';

import 'bloc_manager.dart';

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
    } else if (event is GetUserDeviceEvent) {
      yield* _mapGetUserDeviceEventToState(event);
    } else if (event is UpdateUserDeviceEvent) {
      yield* _mapUpdateUserDeviceEventToState(event);
    } else if (event is GetEmploymentDict) {
      yield* _mapGetEmploymentDictState();
    } else if (event is GetAddressDict) {
      yield* _mapGetAddressDictAddress();
    }
  }

  Stream<UserState> _mapGetUserDataEventToState() async* {
    try {
      yield UserLoading();

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

  Stream<UserState> _mapGetEmploymentDictState() async* {
    try {
      yield UserLoading();

      var res = await ApiManager.getDictEmployment();
      if (res.code == ResponseCode.Success) {
        yield EmploymentDictSuccess(res.dictList ?? []);
      } else {
        print("resFailed::::::::::${res}");
        yield EmploymentDictFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield UserDataFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserState> _mapGetAddressDictAddress() async* {
    try {
      yield UserLoading();

      var res = await ApiManager.getDictAddress();
      if (res.code == ResponseCode.Success) {
        yield AddressDictSuccess(res.dictList ?? []);
      } else {
        print("resFailed::::::::::${res}");
        yield AddressDictFailed(ApiHelper.getFailedMessage(res.message));
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

  Stream<UserState> _mapUpdateProfilePictureEventToState(
      UpdateProfilePictureEvent event) async* {
    try {
      var res = await ApiManager.updateProfilePic(event.request);
      if (res.code == ResponseCode.Success) {
        BlocManager.userBloc.add(GetUserDataEvent());
        yield UpdateProfilePictureSuccess();
      } else {
        yield UpdateProfilePictureFailed(
            ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield UpdateProfilePictureFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserState> _mapUpdateUserDataEventToState(
      UpdateUserDataEvent event) async* {
    try {
      yield UserLoading();

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

  Stream<UserState> _mapGetUserDeviceEventToState(
      GetUserDeviceEvent event) async* {
    try {
      yield UserLoading();

      var res = await ApiManager.getUserDevice(event.deviceId);
      if (res.code == ResponseCode.Success) {
        yield GetUserDeviceSuccess(res);
      } else {
        yield GetUserDeviceFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield GetUserDeviceFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserState> _mapTableDictEventToState(GetUserDeviceEvent event) async* {
    try {
      yield UserLoading();

      var res = await ApiManager.getUserDevice(event.deviceId);
      if (res.code == ResponseCode.Success) {
        yield GetUserDeviceSuccess(res);
      } else {
        yield GetUserDeviceFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield GetUserDeviceFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserState> _mapUpdateUserDeviceEventToState(
      UpdateUserDeviceEvent event) async* {
    try {
      yield UserLoading();

      var res = await ApiManager.updateUserDevice(event.userDevice);
      if (res.code == ResponseCode.Success) {
        yield UpdateUserDeviceSuccess();
      } else {
        yield UpdateUserDeviceFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield UpdateUserDeviceFailed(LocaleKeys.errorOccurred);
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

class GetEmploymentDict extends UserEvent {}

class GetAddressDict extends UserEvent {}

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

class GetUserDeviceEvent extends UserEvent {
  final String deviceId;

  const GetUserDeviceEvent(this.deviceId);

  @override
  List<Object> get props => [deviceId];

  @override
  String toString() => 'GetUserDeviceEvent { deviceId: $deviceId }';
}

class GetTableDict extends UserEvent {
  final String dict;

  const GetTableDict(this.dict);

  @override
  List<Object> get props => [dict];

  @override
  String toString() => 'GetUserDeviceEvent { deviceId: $dict }';
}

class UpdateUserDeviceEvent extends UserEvent {
  final UserDevice userDevice;

  const UpdateUserDeviceEvent(this.userDevice);

  @override
  List<Object> get props => [userDevice];

  @override
  String toString() => 'UpdateUserDeviceEvent { userDevice: $userDevice }';
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

class EmploymentDictSuccess extends UserState {
  final List<DictData> dictData;

  const EmploymentDictSuccess(this.dictData);

  @override
  List<Object> get props => [dictData];

  @override
  String toString() => 'UserDataSuccess { userData: $dictData }';
}

class EmploymentDictFailed extends UserState {
  final String message;

  const EmploymentDictFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'UserDataFailed { message: $message }';
}

class AddressDictSuccess extends UserState {
  final List<DictData> dictData;

  const AddressDictSuccess(this.dictData);

  @override
  List<Object> get props => [dictData];

  @override
  String toString() => 'UserDataSuccess { userData: $dictData }';
}

class AddressDictFailed extends UserState {
  final String message;

  const AddressDictFailed(this.message);

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

class GetUserDeviceSuccess extends UserState {
  final UserDevice userDevice;

  const GetUserDeviceSuccess(this.userDevice);

  @override
  List<Object> get props => [userDevice];

  @override
  String toString() => 'GetUserDeviceSuccess { userDevice: $userDevice }';
}

class GetUserDeviceFailed extends UserState {
  final String message;

  const GetUserDeviceFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetUserDeviceFailed { message: $message }';
}

class UpdateUserDeviceSuccess extends UserState {}

class UpdateUserDeviceFailed extends UserState {
  final String message;

  const UpdateUserDeviceFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'UpdateUserDeviceFailed { message: $message }';
}
