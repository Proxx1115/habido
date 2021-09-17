import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/habit_progress_list_by_date_request.dart';
import 'package:habido_app/models/habit_progress_response.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_expense_category.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class UserHabitBloc extends Bloc<UserHabitEvent, UserHabitState> {
  UserHabitBloc() : super(UserHabitInit());

  @override
  Stream<UserHabitState> mapEventToState(UserHabitEvent event) async* {
    if (event is GoalSwitchChangedEvent) {
      yield* _mapReminderSwitchChangedEventEventToState(event);
    } else if (event is InsertUserHabitEvent) {
      yield* _mapInsertUserHabitEventToState(event);
    } else if (event is UpdateUserHabitEvent) {
      yield* _mapUpdateUserHabitEventToState(event);
    } else if (event is SaveUserHabitProgressEvent) {
      yield* _mapSaveUserHabitProgressEventToState(event);
    } else if (event is GetHabitFinanceTotalAmountEvent) {
      yield* _mapGetHabitFinanceTotalAmountEventToState(event);
    } else if (event is GetHabitProgressListByDateEvent) {
      yield* _mapGetHabitProgressListByDateEventToState(event);
    } else if (event is AddHabitProgressEvent) {
      yield* _mapAddHabitProgressEventToState(event);
    } else if (event is UpdateHabitProgressEvent) {
      yield* _mapUpdateHabitProgressEventToState(event);
    } else if (event is DeleteHabitProgressEvent) {
      yield* _mapDeleteHabitProgressEventToState(event);
    }
  }

  Stream<UserHabitState> _mapReminderSwitchChangedEventEventToState(GoalSwitchChangedEvent event) async* {
    yield GoalSwitchChangedState(event.value);
    yield UserHabitDefault();
  }

  Stream<UserHabitState> _mapInsertUserHabitEventToState(InsertUserHabitEvent event) async* {
    try {
      yield UserHabitLoading();

      var res = await ApiManager.insertUserHabit(event.userHabit);
      if (res.code == ResponseCode.Success) {
        yield InsertUserHabitSuccess();
      } else {
        yield InsertUserHabitFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield InsertUserHabitFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapUpdateUserHabitEventToState(UpdateUserHabitEvent event) async* {
    try {
      yield UserHabitLoading();

      var res = await ApiManager.updateUserHabit(event.userHabit);
      if (res.code == ResponseCode.Success) {
        yield UpdateUserHabitSuccess(event.userHabit);
      } else {
        yield UpdateUserHabitFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield UpdateUserHabitFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapGetHabitFinanceTotalAmountEventToState(GetHabitFinanceTotalAmountEvent event) async* {
    try {
      yield UserHabitProgressLoading();

      var res = await ApiManager.habitFinanceTotalAmount(event.userHabitId);
      if (res.code == ResponseCode.Success) {
        yield HabitFinanceTotalAmountSuccess(Func.toDouble(res.totalAmount), res.expenseCategories ?? []);
      } else {
        yield HabitFinanceTotalAmountFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield HabitFinanceTotalAmountFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapSaveUserHabitProgressEventToState(SaveUserHabitProgressEvent event) async* {
    try {
      yield UserHabitProgressLoading();

      var res = await ApiManager.saveUserHabitProgress(event.request);
      if (res.code == ResponseCode.Success) {
        yield SaveUserHabitProgressSuccess(res);
      } else {
        yield SaveUserHabitProgressFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield SaveUserHabitProgressFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapGetHabitProgressListByDateEventToState(GetHabitProgressListByDateEvent event) async* {
    try {
      yield UserHabitProgressLoading();

      var res = await ApiManager.habitProgressListByDate(event.request);
      if (res.code == ResponseCode.Success) {
        yield GetHabitProgressListByDateSuccess(res.habitProgressList ?? []);
      } else {
        yield GetHabitProgressListByDateFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetHabitProgressListByDateFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapAddHabitProgressEventToState(AddHabitProgressEvent event) async* {
    try {
      yield UserHabitProgressLoading();

      var res = await ApiManager.addHabitProgress(event.habitProgress);
      if (res.code == ResponseCode.Success) {
        yield AddHabitProgressSuccess();
      } else {
        yield AddHabitProgressFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield AddHabitProgressFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapUpdateHabitProgressEventToState(UpdateHabitProgressEvent event) async* {
    try {
      yield UserHabitProgressLoading();

      var res = await ApiManager.updateHabitProgress(event.habitProgress);
      if (res.code == ResponseCode.Success) {
        yield UpdateHabitProgressSuccess();
      } else {
        yield UpdateHabitProgressFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield UpdateHabitProgressFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapDeleteHabitProgressEventToState(DeleteHabitProgressEvent event) async* {
    try {
      yield UserHabitProgressLoading();

      var res = await ApiManager.deleteHabitProgress(event.progressId);
      if (res.code == ResponseCode.Success) {
        yield DeleteHabitProgressSuccess();
      } else {
        yield DeleteHabitProgressFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield DeleteHabitProgressFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class UserHabitEvent extends Equatable {
  const UserHabitEvent();

  @override
  List<Object> get props => [];
}

class ChangePlanTermEvent extends UserHabitEvent {
  final String planTerm;

  const ChangePlanTermEvent(this.planTerm);

  @override
  List<Object> get props => [planTerm];

  @override
  String toString() => 'ChangePlanTermEvent { planTerm: $planTerm }';
}

class GoalSwitchChangedEvent extends UserHabitEvent {
  final bool value;

  const GoalSwitchChangedEvent(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'GoalSwitchChangedEvent { value: $value }';
}

class InsertUserHabitEvent extends UserHabitEvent {
  final UserHabit userHabit;

  const InsertUserHabitEvent(this.userHabit);

  @override
  List<Object> get props => [userHabit];

  @override
  String toString() => 'InsertUserHabitEvent { userHabit: $userHabit }';
}

class UpdateUserHabitEvent extends UserHabitEvent {
  final UserHabit userHabit;

  const UpdateUserHabitEvent(this.userHabit);

  @override
  List<Object> get props => [userHabit];

  @override
  String toString() => 'UpdateUserHabitEvent { userHabit: $userHabit }';
}

class SaveUserHabitProgressEvent extends UserHabitEvent {
  final SaveUserHabitProgressRequest request;

  const SaveUserHabitProgressEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'SaveUserHabitProgressEvent { request: $request }';
}

class GetHabitFinanceTotalAmountEvent extends UserHabitEvent {
  final int userHabitId;

  const GetHabitFinanceTotalAmountEvent(this.userHabitId);

  @override
  List<Object> get props => [userHabitId];

  @override
  String toString() => 'GetHabitFinanceTotalAmountEvent { userHabitId: $userHabitId }';
}

class GetHabitProgressListByDateEvent extends UserHabitEvent {
  final HabitProgressListByDateRequest request;

  const GetHabitProgressListByDateEvent(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'GetHabitProgressListByDateEvent { request: $request }';
}

class AddHabitProgressEvent extends UserHabitEvent {
  final HabitProgress habitProgress;

  const AddHabitProgressEvent(this.habitProgress);

  @override
  List<Object> get props => [habitProgress];

  @override
  String toString() => 'AddHabitProgressEvent { habitProgress: $habitProgress }';
}

class UpdateHabitProgressEvent extends UserHabitEvent {
  final HabitProgress habitProgress;

  const UpdateHabitProgressEvent(this.habitProgress);

  @override
  List<Object> get props => [habitProgress];

  @override
  String toString() => 'UpdateHabitProgressEvent { habitProgress: $habitProgress }';
}

class DeleteHabitProgressEvent extends UserHabitEvent {
  final int progressId;

  const DeleteHabitProgressEvent(this.progressId);

  @override
  List<Object> get props => [progressId];

  @override
  String toString() => 'DeleteHabitProgressEvent { progressId: $progressId }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class UserHabitState extends Equatable {
  const UserHabitState();

  @override
  List<Object> get props => [];
}

class UserHabitInit extends UserHabitState {}

class UserHabitLoading extends UserHabitState {}

class UserHabitDefault extends UserHabitState {}

class PlanTermChangedState extends UserHabitState {
  final String planTerm;

  const PlanTermChangedState(this.planTerm);

  @override
  List<Object> get props => [planTerm];

  @override
  String toString() => 'PlanTermChangedState { planTerm: $planTerm }';
}

class GoalSwitchChangedState extends UserHabitState {
  final bool value;

  const GoalSwitchChangedState(this.value);

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'GoalSwitchChangedState { value: $value }';
}

class InsertUserHabitSuccess extends UserHabitState {}

class InsertUserHabitFailed extends UserHabitState {
  final String message;

  const InsertUserHabitFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'InsertUserHabitFailed { messages: $message }';
}

class UpdateUserHabitSuccess extends UserHabitState {
  final UserHabit userHabit;

  const UpdateUserHabitSuccess(this.userHabit);

  @override
  List<Object> get props => [userHabit];

  @override
  String toString() => 'UpdateUserHabitSuccess { userHabit: $userHabit }';
}

class UpdateUserHabitFailed extends UserHabitState {
  final String message;

  const UpdateUserHabitFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'UpdateUserHabitFailed { message: $message }';
}

class UserHabitProgressLoading extends UserHabitState {}

class SaveUserHabitProgressSuccess extends UserHabitState {
  final HabitProgressResponse habitProgressResponse;

  const SaveUserHabitProgressSuccess(this.habitProgressResponse);

  @override
  List<Object> get props => [habitProgressResponse];

  @override
  String toString() => 'SaveUserHabitProgressSuccess { habitProgressResponse: $habitProgressResponse }';
}

class SaveUserHabitProgressFailed extends UserHabitState {
  final String message;

  const SaveUserHabitProgressFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SaveUserHabitProgressFailed { message: $message }';
}

class GetHabitProgressListByDateSuccess extends UserHabitState {
  final List<HabitProgress> habitProgressList;

  const GetHabitProgressListByDateSuccess(this.habitProgressList);

  @override
  List<Object> get props => [habitProgressList];

  @override
  String toString() => 'GetHabitProgressListByDateSuccess { habitProgressList: $habitProgressList }';
}

class GetHabitProgressListByDateFailed extends UserHabitState {
  final String message;

  const GetHabitProgressListByDateFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetHabitProgressListByDateFailed { message: $message }';
}

class HabitFinanceTotalAmountSuccess extends UserHabitState {
  final double totalAmount;
  final List<UserHabitExpenseCategory> expenseCategories;

  const HabitFinanceTotalAmountSuccess(this.totalAmount, this.expenseCategories);

  @override
  List<Object> get props => [totalAmount, expenseCategories];

  @override
  String toString() =>
      'HabitFinanceTotalAmountSuccess { totalAmount: $totalAmount, expenseCategories: $expenseCategories }';
}

class HabitFinanceTotalAmountFailed extends UserHabitState {
  final String message;

  const HabitFinanceTotalAmountFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'HabitFinanceTotalAmountFailed { message: $message }';
}

class AddHabitProgressSuccess extends UserHabitState {}

class AddHabitProgressFailed extends UserHabitState {
  final String message;

  const AddHabitProgressFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddHabitProgressFailed { message: $message }';
}

class UpdateHabitProgressSuccess extends UserHabitState {}

class UpdateHabitProgressFailed extends UserHabitState {
  final String message;

  const UpdateHabitProgressFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddHabitProgressFailed { message: $message }';
}

class DeleteHabitProgressSuccess extends UserHabitState {}

class DeleteHabitProgressFailed extends UserHabitState {
  final String message;

  const DeleteHabitProgressFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'DeleteHabitProgressFailed { message: $message }';
}
