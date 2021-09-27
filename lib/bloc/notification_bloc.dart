import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/notif.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInit());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is GetUnreadNotifCount) {
      yield* _mapGetUnreadNotifCountToState(event);
    } else if (event is GetFirstNotifsEvent) {
      yield* _mapGetFirstNotifsToState();
    } else if (event is GetNextNotifsEvent) {
      yield* _mapGetNextNotifsToState(event);
    } else if (event is ReadAllNotifEvent) {
      yield* _mapReadAllNotifEventToState();
    }
  }

  Stream<NotificationState> _mapGetUnreadNotifCountToState(GetUnreadNotifCount event) async* {
    try {
      yield NotificationLoading();

      bool forceUpdate = true;
      if (event.forceUpdate) {
        print('forceUpdate = true');
      } else {
        var lastDateTime = SharedPref.getLastNotifDateTime();
        if (lastDateTime == null) {
          print('forceUpdate = true');
        } else {
          DateTime expirationDateTime = DateTime.now().subtract(Duration(seconds: 60));
          if (lastDateTime.isBefore(expirationDateTime)) {
            print('forceUpdate = true');
          } else {
            print('forceUpdate = false');
            forceUpdate = false;
          }
        }
      }

      if (forceUpdate) {
        var res = await ApiManager.unreadNotifCount();
        if (res.code == ResponseCode.Success) {
          SharedPref.setLastNotifDateTime(DateTime.now());
          yield GetUnreadNotifCountSuccess(res.notifCount ?? 0);
        } else {
          yield GetUnreadNotifCountFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
        }
      }
    } catch (e) {
      yield GetUnreadNotifCountFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<NotificationState> _mapGetFirstNotifsToState() async* {
    try {
      yield NotificationLoading();

      var res = await ApiManager.firstNotifs();
      if (res.code == ResponseCode.Success) {
        yield GetFirstNotifsSuccess(res.notifList ?? []);
      } else {
        yield GetFirstNotifsFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetFirstNotifsFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<NotificationState> _mapGetNextNotifsToState(GetNextNotifsEvent event) async* {
    try {
      yield NotificationLoading();

      var res = await ApiManager.nextNotifs(event.notifId);
      if (res.code == ResponseCode.Success) {
        yield GetNextNotifsSuccess(res.notifList ?? []);
      } else {
        yield GetNextNotifsFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetNextNotifsFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<NotificationState> _mapReadAllNotifEventToState() async* {
    try {
      yield NotificationLoading();

      var res = await ApiManager.readAllNotif();
      if (res.code == ResponseCode.Success) {
        yield ReadAllNotifSuccess();
      } else {
        yield ReadAllNotifFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield ReadAllNotifFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetUnreadNotifCount extends NotificationEvent {
  final bool forceUpdate;

  const GetUnreadNotifCount(this.forceUpdate);

  @override
  List<Object> get props => [forceUpdate];

  @override
  String toString() => 'GetUnreadNotifCount { forceUpdate: $forceUpdate }';
}

class ReadAllNotifEvent extends NotificationEvent {}

class GetFirstNotifsEvent extends NotificationEvent {}

class GetNextNotifsEvent extends NotificationEvent {
  final int notifId;

  const GetNextNotifsEvent(this.notifId);

  @override
  List<Object> get props => [notifId];

  @override
  String toString() => 'GetNextNotifsEvent { notifId: $notifId }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInit extends NotificationState {}

class NotificationLoading extends NotificationState {}

class GetUnreadNotifCountSuccess extends NotificationState {
  final int unreadNotifCount;

  const GetUnreadNotifCountSuccess(this.unreadNotifCount);

  @override
  List<Object> get props => [unreadNotifCount];

  @override
  String toString() => 'GetUnreadNotifCountSuccess { unreadNotifCount: $unreadNotifCount }';
}

class GetUnreadNotifCountFailed extends NotificationState {
  final String message;

  const GetUnreadNotifCountFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetUnreadNotifCountFailed { message: $message }';
}

class GetFirstNotifsSuccess extends NotificationState {
  final List<Notif> notifList;

  const GetFirstNotifsSuccess(this.notifList);

  @override
  List<Object> get props => [notifList];

  @override
  String toString() => 'GetFirstNotifsSuccess { notifList: $notifList }';
}

class GetFirstNotifsFailed extends NotificationState {
  final String message;

  const GetFirstNotifsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetFirstNotifsFailed { message: $message }';
}

class GetNextNotifsSuccess extends NotificationState {
  final List<Notif> notifList;

  const GetNextNotifsSuccess(this.notifList);

  @override
  List<Object> get props => [notifList];

  @override
  String toString() => 'GetNextNotifsSuccess { notifList: $notifList }';
}

class GetNextNotifsFailed extends NotificationState {
  final String message;

  const GetNextNotifsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetNextNotifsFailed { message: $message }';
}

class ReadAllNotifSuccess extends NotificationState {}

class ReadAllNotifFailed extends NotificationState {
  final String message;

  const ReadAllNotifFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ReadAllNotifFailed { message: $message }';
}
