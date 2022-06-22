import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/active_habit.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class AllHabitBloc extends Bloc<AllHabitEvent, AllHabitState> {
  AllHabitBloc() : super(GetActiveHabitInit());

  @override
  Stream<AllHabitState> mapEventToState(AllHabitEvent event) async* {
    if (event is GetFirstActiveHabitsEvent) {
      yield* _mapGetFirstActiveHabitsToState();
    } else if (event is GetNextActiveHabitsEvent) {
      yield* _mapGetNextActiveHabitsToState(event);
    } else if (event is GetFirstCompletedHabitsEvent) {
      yield* _mapGetFirstCompletedHabitsToState();
    } else if (event is GetNextCompletedHabitsEvent) {
      yield* _mapGetNextCompletedHabitsToState(event);
    } else if (event is GetFirstHistoryHabitsEvent) {
      yield* _mapGetFirstHistoryHabitsToState();
    } else if (event is GetNextHistoryHabitsEvent) {
      yield* _mapGetNextHistoryHabitsToState(event);
    }
  }

  // Stream<AllHabitState> _mapGetActiveHabitEventToState() async* {
  //   try {
  //     var res = await ApiManager.getActiveHabit();
  //     if (res.code == ResponseCode.Success) {
  //       yield GetActiveHabitSuccess(res.data);
  //     } else {
  //       yield GetActiveHabitFailed(
  //           Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
  //     }
  //   } catch (e) {
  //     yield GetActiveHabitFailed(LocaleKeys.errorOccurred);
  //   }
  // }

  // Stream<AllHabitState> _mapGetCompletedEventState() async* {
  //   try {
  //     var res = await ApiManager.getCompletedHabit();
  //     if (res.code == ResponseCode.Success) {
  //       yield GetCompletedHabitSuccess(res.data);
  //     } else {
  //       yield GetCompletedHabitFailed(
  //           Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
  //     }
  //   } catch (e) {
  //     yield GetCompletedHabitFailed(LocaleKeys.errorOccurred);
  //   }
  // }

  // Stream<AllHabitState> _mapGetHistoryEventState() async* {
  //   try {
  //     var res = await ApiManager.getHistoryHabit();
  //     if (res.code == ResponseCode.Success) {
  //       yield GetHistoryHabitSuccess(res.data);
  //     } else {
  //       yield GetHistoryHabitFailed(
  //           Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
  //     }
  //   } catch (e) {
  //     yield GetHistoryHabitFailed(LocaleKeys.errorOccurred);
  //   }
  // }

  Stream<AllHabitState> _mapGetFirstActiveHabitsToState() async* {
    try {
      var res = await ApiManager.getActiveHabit();
      if (res.code == ResponseCode.Success) {
        yield GetFirstActiveHabitsSuccess(res.data ?? []);
      } else {
        yield GetFirstActiveHabitFailed(
            Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetFirstActiveHabitFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetNextActiveHabitsToState(
      GetNextActiveHabitsEvent event) async* {
    try {
      var res = await ApiManager.nextActiveHabits(event.userHabitId);
      if (res.code == ResponseCode.Success) {
        yield GetNextActiveHabitsSuccess(res.data ?? []);
      } else {
        yield GetNextActiveHabitFailed(
            Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetNextActiveHabitFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetFirstCompletedHabitsToState() async* {
    try {
      var res = await ApiManager.getCompletedHabit();
      if (res.code == ResponseCode.Success) {
        yield GetFirstCompletedHabitsSuccess(res.data ?? []);
      } else {
        yield GetFirstCompletedHabitsFailed(
            Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetFirstCompletedHabitsFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetNextCompletedHabitsToState(
      GetNextCompletedHabitsEvent event) async* {
    try {
      var res = await ApiManager.nextCompletedHabits(event.userHabitId);
      if (res.code == ResponseCode.Success) {
        yield GetNextCompletedHabitsSuccess(res.data ?? []);
      } else {
        yield GetNextCompletedHabitsFailed(
            Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetNextCompletedHabitsFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetFirstHistoryHabitsToState() async* {
    try {
      var res = await ApiManager.getHistoryHabit();
      if (res.code == ResponseCode.Success) {
        yield GetFirstHistoryHabitsSuccess(res.data ?? []);
      } else {
        yield GetFirstHistoryHabitsFailed(
            Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetFirstHistoryHabitsFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetNextHistoryHabitsToState(
      GetNextHistoryHabitsEvent event) async* {
    try {
      var res = await ApiManager.nextActiveHabits(event.userHabitId);
      if (res.code == ResponseCode.Success) {
        yield GetNextHistoryHabitsSuccess(res.data ?? []);
      } else {
        yield GetNextHistoryHabitsFailed(
            Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetNextHistoryHabitsFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class AllHabitEvent extends Equatable {
  const AllHabitEvent();

  @override
  List<Object> get props => [];
}

class GetFirstActiveHabitsEvent extends AllHabitEvent {}

class GetNextActiveHabitsEvent extends AllHabitEvent {
  final int userHabitId;

  const GetNextActiveHabitsEvent(this.userHabitId);

  @override
  List<Object> get props => [userHabitId];

  @override
  String toString() => 'GetNextNotifsEvent { userHabitId: $userHabitId }';
}

class GetFirstCompletedHabitsEvent extends AllHabitEvent {}

class GetNextCompletedHabitsEvent extends AllHabitEvent {
  final int userHabitId;

  const GetNextCompletedHabitsEvent(this.userHabitId);

  @override
  List<Object> get props => [userHabitId];

  @override
  String toString() => 'GetNextNotifsEvent { userHabitId: $userHabitId }';
}

class GetFirstHistoryHabitsEvent extends AllHabitEvent {}

class GetNextHistoryHabitsEvent extends AllHabitEvent {
  final int userHabitId;

  const GetNextHistoryHabitsEvent(this.userHabitId);

  @override
  List<Object> get props => [userHabitId];

  @override
  String toString() => 'GetNextNotifsEvent { userHabitId: $userHabitId }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class AllHabitState extends Equatable {
  const AllHabitState();

  @override
  List<Object> get props => [];
}

class GetActiveHabitInit extends AllHabitState {}

class GetFirstActiveHabitsSuccess extends AllHabitState {
  final List<ActiveHabit> activeHabitList;

  const GetFirstActiveHabitsSuccess(this.activeHabitList);

  @override
  List<Object> get props => [activeHabitList];

  @override
  String toString() =>
      'GetFirstActiveHabitsSuccess { activeHabitList: $activeHabitList }';
}

class GetFirstActiveHabitFailed extends AllHabitState {
  final String message;

  const GetFirstActiveHabitFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetFirstNotifsFailed { message: $message }';
}

class GetNextActiveHabitsSuccess extends AllHabitState {
  final List<ActiveHabit> activeHabitList;

  const GetNextActiveHabitsSuccess(this.activeHabitList);

  @override
  List<Object> get props => [activeHabitList];

  @override
  String toString() =>
      'GetNextActiveHabitsSuccess { activeHabitList: $activeHabitList }';
}

class GetNextActiveHabitFailed extends AllHabitState {
  final String message;

  const GetNextActiveHabitFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetNextActiveHabitFailed { message: $message }';
}

class GetFirstCompletedHabitsSuccess extends AllHabitState {
  final List<ActiveHabit> completedHabitList;

  const GetFirstCompletedHabitsSuccess(this.completedHabitList);

  @override
  List<Object> get props => [completedHabitList];

  @override
  String toString() =>
      'GetFirstCompletedHabitsSuccess { completedHabitList: $completedHabitList }';
}

class GetFirstCompletedHabitsFailed extends AllHabitState {
  final String message;

  const GetFirstCompletedHabitsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetFirstcompletedHabitsFailed { message: $message }';
}

class GetNextCompletedHabitsSuccess extends AllHabitState {
  final List<ActiveHabit> completedHabitList;

  const GetNextCompletedHabitsSuccess(this.completedHabitList);

  @override
  List<Object> get props => [completedHabitList];

  @override
  String toString() =>
      'GetNextCompletedHabitsSuccess { completedHabitList: $completedHabitList }';
}

class GetNextCompletedHabitsFailed extends AllHabitState {
  final String message;

  const GetNextCompletedHabitsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetNextCompletedHabitsFailed { message: $message }';
}

class GetFirstHistoryHabitsSuccess extends AllHabitState {
  final List<ActiveHabit> historyHabitList;

  const GetFirstHistoryHabitsSuccess(this.historyHabitList);

  @override
  List<Object> get props => [historyHabitList];

  @override
  String toString() =>
      'GetFirstHistoryHabitsSuccess { historyHabitList: $historyHabitList }';
}

class GetFirstHistoryHabitsFailed extends AllHabitState {
  final String message;

  const GetFirstHistoryHabitsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetFirstHistoryHabitsFailed { message: $message }';
}

class GetNextHistoryHabitsSuccess extends AllHabitState {
  final List<ActiveHabit> historyHabitList;

  const GetNextHistoryHabitsSuccess(this.historyHabitList);

  @override
  List<Object> get props => [historyHabitList];

  @override
  String toString() =>
      'GetNextHistoryHabitsSuccess { historyHabitList: $historyHabitList }';
}

class GetNextHistoryHabitsFailed extends AllHabitState {
  final String message;

  const GetNextHistoryHabitsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetNextHistoryHabitsFailed { message: $message }';
}
