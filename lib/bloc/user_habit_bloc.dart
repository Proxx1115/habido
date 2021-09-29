import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit_progress.dart';
import 'package:habido_app/models/habit_progress_list_by_date_request.dart';
import 'package:habido_app/models/habit_progress_list_with_date.dart';
import 'package:habido_app/models/habit_progress_response.dart';
import 'package:habido_app/models/habit_question_response.dart';
import 'package:habido_app/models/save_user_habit_progress_request.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_expense_category.dart';
import 'package:habido_app/models/user_habit_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/widgets/combobox/combo_helper.dart';
import 'bloc_manager.dart';
import 'dashboard_bloc.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class UserHabitBloc extends Bloc<UserHabitEvent, UserHabitState> {
  UserHabitBloc() : super(UserHabitInit());

  @override
  Stream<UserHabitState> mapEventToState(UserHabitEvent event) async* {
    if (event is InsertUserHabitEvent) {
      yield* _mapInsertUserHabitEventToState(event);
    } else if (event is UpdateUserHabitEvent) {
      yield* _mapUpdateUserHabitEventToState(event);
    } else if (event is DeleteUserHabitEvent) {
      yield* _mapDeleteUserHabitEventToState(event);
    } else if (event is SaveUserHabitProgressEvent) {
      yield* _mapSaveUserHabitProgressEventToState(event);
    } else if (event is GetHabitFinanceTotalAmountEvent) {
      yield* _mapGetHabitFinanceTotalAmountEventToState(event);
    } else if (event is GetHabitProgressListWithDateEvent) {
      yield* _mapGetHabitProgressListWithDateEventToState(event);
    } else if (event is GetHabitProgressListByDateEvent) {
      yield* _mapGetHabitProgressListByDateEventToState(event);
    } else if (event is AddHabitProgressEvent) {
      yield* _mapAddHabitProgressEventToState(event);
    } else if (event is UpdateHabitProgressEvent) {
      yield* _mapUpdateHabitProgressEventToState(event);
    } else if (event is DeleteHabitProgressEvent) {
      yield* _mapDeleteHabitProgressEventToState(event);
    } else if (event is GetExpenseCategoriesEvent) {
      yield* _mapGetExpenseCategoriesEventToState();
    } else if (event is GetHabitQuestionEvent) {
      yield* _mapGetHabitQuestionEventToState(event);
    } else if (event is UserHabitShowcaseEvent) {
      yield* _mapUserHabitShowcaseEventToState(event);
    }
  }

  Stream<UserHabitState> _mapInsertUserHabitEventToState(InsertUserHabitEvent event) async* {
    try {
      yield UserHabitLoading();

      var res = await ApiManager.insertUserHabit(event.userHabit);
      if (res.code == ResponseCode.Success) {
        // Refresh dashboard
        BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

        yield InsertUserHabitSuccess(res);
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
        // Refresh dashboard
        BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

        yield UpdateUserHabitSuccess(event.userHabit);
      } else {
        yield UpdateUserHabitFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield UpdateUserHabitFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapDeleteUserHabitEventToState(DeleteUserHabitEvent event) async* {
    try {
      yield UserHabitLoading();

      var res = await ApiManager.deleteUserHabit(event.userHabit.userHabitId ?? 0);
      if (res.code == ResponseCode.Success) {
        // Refresh dashboard
        BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

        yield DeleteUserHabitSuccess(event.userHabit);
      } else {
        yield DeleteUserHabitFailed(ApiHelper.getFailedMessage(res.message));
      }
    } catch (e) {
      yield DeleteUserHabitFailed(LocaleKeys.errorOccurred);
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
        // Refresh dashboard
        BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());

        if (res.rank != null) {
          // Rank ахисан
          await ApiManager.getUserData();
        }

        yield SaveUserHabitProgressSuccess(res);
      } else {
        yield SaveUserHabitProgressFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield SaveUserHabitProgressFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapGetHabitProgressListWithDateEventToState(GetHabitProgressListWithDateEvent event) async* {
    try {
      yield HabitFinanceStatementLoading();

      var res = await ApiManager.habitProgressListWithDate(event.userHabitId);
      if (res.code == ResponseCode.Success) {
        yield GetHabitProgressListWithDateSuccess(res.habitProgressListWithDate ?? []);
      } else {
        yield GetHabitProgressListWithDateFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetHabitProgressListWithDateFailed(LocaleKeys.errorOccurred);
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

  Stream<UserHabitState> _mapGetExpenseCategoriesEventToState() async* {
    try {
      yield UserHabitProgressLoading();

      var res = await ApiManager.habitExpenseCategories();
      if (res.code == ResponseCode.Success) {
        List<ComboItem> list = [];

        if (res.habitExpenseCategoryList != null && res.habitExpenseCategoryList!.isNotEmpty) {
          for (var el in res.habitExpenseCategoryList!) {
            list.add(
              ComboItem()
                ..val = el
                ..txt = el.name ?? '',
            );
          }
        }

        yield GetExpenseCategoriesSuccess(list);
      } else {
        yield GetExpenseCategoriesFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield GetExpenseCategoriesFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapGetHabitQuestionEventToState(GetHabitQuestionEvent event) async* {
    try {
      yield UserHabitProgressLoading();

      var res = await ApiManager.habitQuestions(event.questionId);
      if (res.code == ResponseCode.Success) {
        yield HabitQuestionSuccess(res);
      } else {
        yield HabitQuestionFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield HabitQuestionFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<UserHabitState> _mapUserHabitShowcaseEventToState(UserHabitShowcaseEvent event) async* {
    if (!SharedPref.getShowcaseHasShown(event.showcaseKeyName)) {
      List<GlobalKey> keyList = ShowcaseKey.getKeysByName(event.showcaseKeyName);
      if (keyList.isNotEmpty) {
        yield UserHabitShowcaseState(keyList);
        yield UserHabitDefault();
        SharedPref.setShowcaseHasShown(event.showcaseKeyName, true);
      }
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

class DeleteUserHabitEvent extends UserHabitEvent {
  final UserHabit userHabit;

  const DeleteUserHabitEvent(this.userHabit);

  @override
  List<Object> get props => [userHabit];

  @override
  String toString() => 'DeleteUserHabitEvent { userHabit: $userHabit }';
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

class GetHabitProgressListWithDateEvent extends UserHabitEvent {
  final int userHabitId;

  const GetHabitProgressListWithDateEvent(this.userHabitId);

  @override
  List<Object> get props => [userHabitId];

  @override
  String toString() => 'GetHabitProgressListEvent { userHabitId: $userHabitId }';
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

class GetExpenseCategoriesEvent extends UserHabitEvent {}

class GetHabitQuestionEvent extends UserHabitEvent {
  final int questionId;

  const GetHabitQuestionEvent(this.questionId);

  @override
  List<Object> get props => [questionId];

  @override
  String toString() => 'GetHabitQuestions { questionId: $questionId }';
}

class UserHabitShowcaseEvent extends UserHabitEvent {
  final String showcaseKeyName;

  const UserHabitShowcaseEvent(this.showcaseKeyName);

  @override
  List<Object> get props => [showcaseKeyName];

  @override
  String toString() => 'UserHabitShowcaseEvent { showcaseKeyName: $showcaseKeyName }';
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

class InsertUserHabitSuccess extends UserHabitState {
  final UserHabitResponse userHabitResponse;

  const InsertUserHabitSuccess(this.userHabitResponse);

  @override
  List<Object> get props => [userHabitResponse];

  @override
  String toString() => 'InsertUserHabitSuccess { userHabitResponse: $userHabitResponse }';
}

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

class DeleteUserHabitSuccess extends UserHabitState {
  final UserHabit userHabit;

  const DeleteUserHabitSuccess(this.userHabit);

  @override
  List<Object> get props => [userHabit];

  @override
  String toString() => 'DeleteUserHabitSuccess { userHabit: $userHabit }';
}

class DeleteUserHabitFailed extends UserHabitState {
  final String message;

  const DeleteUserHabitFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'DeleteUserHabitFailed { message: $message }';
}

class UserHabitProgressLoading extends UserHabitState {}

class HabitFinanceStatementLoading extends UserHabitState {}

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

class GetHabitProgressListWithDateSuccess extends UserHabitState {
  final List<HabitProgressListWithDate> habitProgressListWithDate;

  const GetHabitProgressListWithDateSuccess(this.habitProgressListWithDate);

  @override
  List<Object> get props => [habitProgressListWithDate];

  @override
  String toString() => 'GetHabitProgressListSuccess { habitProgressList: $habitProgressListWithDate }';
}

class GetHabitProgressListWithDateFailed extends UserHabitState {
  final String message;

  const GetHabitProgressListWithDateFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetHabitProgressListFailed { message: $message }';
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

class GetExpenseCategoriesSuccess extends UserHabitState {
  final List<ComboItem> habitExpenseCategoryList;

  const GetExpenseCategoriesSuccess(this.habitExpenseCategoryList);

  @override
  List<Object> get props => [habitExpenseCategoryList];

  @override
  String toString() => 'GetExpenseCategoriesSuccess { habitExpenseCategoryList: $habitExpenseCategoryList }';
}

class GetExpenseCategoriesFailed extends UserHabitState {
  final String message;

  const GetExpenseCategoriesFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetExpenseCategoriesFailed { message: $message }';
}

class HabitQuestionSuccess extends UserHabitState {
  final HabitQuestionResponse habitQuestionResponse;

  const HabitQuestionSuccess(this.habitQuestionResponse);

  @override
  List<Object> get props => [habitQuestionResponse];

  @override
  String toString() => 'GetHabitQuestionsSuccess { habitQuestionResponse: $habitQuestionResponse }';
}

class HabitQuestionFailed extends UserHabitState {
  final String message;

  const HabitQuestionFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'GetHabitQuestionsFailed { message: $message }';
}

class UserHabitShowcaseState extends UserHabitState {
  final List<GlobalKey> showcaseKeyList;

  const UserHabitShowcaseState(this.showcaseKeyList);

  @override
  List<Object> get props => [showcaseKeyList];

  @override
  String toString() => 'UserHabitShowcaseState { showcaseKeyList: $showcaseKeyList }';
}
