import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/active_habit.dart';
import 'package:habido_app/models/completed_habit.dart';
import 'package:habido_app/models/history_habit.dart';
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
    if (event is GetActiveHabitFirstEvent) {
      yield* _mapGetActiveHabitFirstToState();
    } else if (event is GetActiveHabitThenEvent) {
      yield* _mapGetActiveHabitThenToState(event);
    } else if (event is GetCompletedHabitFirstEvent) {
      yield* _mapGetCompletedHabitFirstToState();
    } else if (event is GetCompletedHabitThenEvent) {
      yield* _mapGetCompletedHabitThenToState(event);
    } else if (event is GetHistoryHabitFirstEvent) {
      yield* _mapGetHistoryHabitFirstToState();
    } else if (event is GetHistoryHabitThenEvent) {
      yield* _mapGetHistoryHabitThenToState(event);
    }
  }

  Stream<AllHabitState> _mapGetActiveHabitFirstToState() async* {
    try {
      var res = await ApiManager.getActiveHabitFirst();

      if (res.code == ResponseCode.Success) {
        yield GetActiveHabitFirstSuccess(res.activeHabitList!);
      } else {
        yield GetActiveHabitFirstFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetActiveHabitFirstFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetActiveHabitThenToState(GetActiveHabitThenEvent event) async* {
    try {
      var res = await ApiManager.getActiveHabitThen(event.userHabitId);
      if (res.code == ResponseCode.Success) {
        yield GetActiveHabitThenSuccess(res.data ?? []);
      } else {
        yield GetActiveHabitThenFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetActiveHabitThenFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetCompletedHabitFirstToState() async* {
    try {
      var res = await ApiManager.getCompletedHabitFirst();
      if (res.code == ResponseCode.Success) {
        yield GetCompletedHabitFirstSuccess(res.completedHabitList!);
      } else {
        yield GetCompletedHabitFirstFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetCompletedHabitFirstFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetCompletedHabitThenToState(GetCompletedHabitThenEvent event) async* {
    try {
      var res = await ApiManager.getCompletedHabitThen(event.userHabitId);
      if (res.code == ResponseCode.Success) {
        yield GetCompletedHabitThenSuccess(res.data ?? []);
      } else {
        yield GetCompletedHabitThenFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetCompletedHabitThenFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetHistoryHabitFirstToState() async* {
    try {
      var res = await ApiManager.getHistoryHabitFirst();
      if (res.code == ResponseCode.Success) {
        yield GetHabitHistoryFirstSuccess(res.data ?? []);
      } else {
        yield GetHabitHistoryFirstFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetHabitHistoryFirstFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<AllHabitState> _mapGetHistoryHabitThenToState(GetHistoryHabitThenEvent event) async* {
    try {
      var res = await ApiManager.getActiveHabitThen(event.userHabitId);
      if (res.code == ResponseCode.Success) {
        yield GetHistoryHabitThenSuccess(res.data ?? []);
      } else {
        yield GetHistoryHabitThenFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetHistoryHabitThenFailed(LocaleKeys.errorOccurred);
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

class GetActiveHabitFirstEvent extends AllHabitEvent {}

class GetActiveHabitThenEvent extends AllHabitEvent {
  final int userHabitId;

  const GetActiveHabitThenEvent(this.userHabitId);

  @override
  List<Object> get props => [userHabitId];

  @override
  String toString() => 'GetNextNotifsEvent { userHabitId: $userHabitId }';
}

class GetCompletedHabitFirstEvent extends AllHabitEvent {}

class GetCompletedHabitThenEvent extends AllHabitEvent {
  final int userHabitId;

  const GetCompletedHabitThenEvent(this.userHabitId);

  @override
  List<Object> get props => [userHabitId];

  @override
  String toString() => 'GetNextNotifsEvent { userHabitId: $userHabitId }';
}

class GetHistoryHabitFirstEvent extends AllHabitEvent {}

class GetHistoryHabitThenEvent extends AllHabitEvent {
  final int userHabitId;

  const GetHistoryHabitThenEvent(this.userHabitId);

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

/// Active Habits
class GetActiveHabitFirstSuccess extends AllHabitState {
  final List<ActiveHabit> activeHabitList;

  const GetActiveHabitFirstSuccess(this.activeHabitList);

  @override
  List<Object> get props => [activeHabitList];

  @override
  String toString() => 'GetActiveHabitFirstSuccess { activeHabitList: $activeHabitList }';
}

class GetActiveHabitFirstFailed extends AllHabitState {
  final String message;

  const GetActiveHabitFirstFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetActiveHabitFirstFailed { message: $message }';
}

class GetActiveHabitThenSuccess extends AllHabitState {
  final List<ActiveHabit> activeHabitList;

  const GetActiveHabitThenSuccess(this.activeHabitList);

  @override
  List<Object> get props => [activeHabitList];

  @override
  String toString() => 'GetActiveHabitThenSuccess { activeHabitList: $activeHabitList }';
}

class GetActiveHabitThenFailed extends AllHabitState {
  final String message;

  const GetActiveHabitThenFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetActiveHabitThenFailed { message: $message }';
}

/// Completed Habits
class GetCompletedHabitFirstSuccess extends AllHabitState {
  final List<CompletedHabit> completedHabitList;

  const GetCompletedHabitFirstSuccess(this.completedHabitList);

  @override
  List<Object> get props => [completedHabitList];

  @override
  String toString() => 'GetCompletedHabitFirstSuccess { completedHabitList: $completedHabitList }';
}

class GetCompletedHabitFirstFailed extends AllHabitState {
  final String message;

  const GetCompletedHabitFirstFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetCompletedHabitFirstFailed { message: $message }';
}

class GetCompletedHabitThenSuccess extends AllHabitState {
  final List<CompletedHabit> completedHabitList;

  const GetCompletedHabitThenSuccess(this.completedHabitList);

  @override
  List<Object> get props => [completedHabitList];

  @override
  String toString() => 'GetCompletedHabitThenSuccess { completedHabitList: $completedHabitList }';
}

class GetCompletedHabitThenFailed extends AllHabitState {
  final String message;

  const GetCompletedHabitThenFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetCompletedHabitThenFailed { message: $message }';
}

/// Habit History
class GetHabitHistoryFirstSuccess extends AllHabitState {
  final List<HistoryHabit> habitHistoryList;

  const GetHabitHistoryFirstSuccess(this.habitHistoryList);

  @override
  List<Object> get props => [habitHistoryList];

  @override
  String toString() => 'GetHabitHistoryFirstSuccess { habitHistoryList: $habitHistoryList }';
}

class GetHabitHistoryFirstFailed extends AllHabitState {
  final String message;

  const GetHabitHistoryFirstFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetHabitHistoryFirstFailed { message: $message }';
}

class GetHistoryHabitThenSuccess extends AllHabitState {
  final List<HistoryHabit> habitHistoryList;

  const GetHistoryHabitThenSuccess(this.habitHistoryList);

  @override
  List<Object> get props => [habitHistoryList];

  @override
  String toString() => 'GetHistoryHabitThenSuccess { habitHistoryList: $habitHistoryList }';
}

class GetHistoryHabitThenFailed extends AllHabitState {
  final String message;

  const GetHistoryHabitThenFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetHistoryHabitThenFailed { message: $message }';
}
