import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc() : super(HabitInit());

  @override
  Stream<HabitState> mapEventToState(HabitEvent event) async* {
    // if (event is GetHabitCategoriesEvent) {
    //   yield* _mapGetHabitCategoriesEventToState();
    // }
  }

  // Stream<HabitState> _mapGetHabitCategoriesEventToState() async* {
  //   try {
  //     yield HabitLoading();
  //
  //     var res = await ApiManager.habitCategories();
  //     if (res.code == ResponseCode.Success && res.habitCategoryList != null && res.habitCategoryList!.length > 0) {
  //       yield HabitCategoriesSuccess(res.habitCategoryList!);
  //     } else {
  //       yield HabitCategoriesFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
  //     }
  //   } catch (e) {
  //     yield HabitCategoriesFailed(LocaleKeys.errorOccurred);
  //   }
  // }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

// class GetHabitCategoriesEvent extends HabitEvent {}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

class HabitInit extends HabitState {}

class HabitLoading extends HabitState {}

// class HabitCategoriesVoid extends HabitState {}
//
// class HabitCategoriesSuccess extends HabitState {
//   final List<HabitCategory> habitCategoryList;
//
//   const HabitCategoriesSuccess(this.habitCategoryList);
//
//   @override
//   List<Object> get props => [habitCategoryList];
//
//   @override
//   String toString() => 'HabitCategoriesSuccess { habitCategoryList: $habitCategoryList }';
// }
//
// class HabitCategoriesFailed extends HabitState {
//   final String message;
//
//   const HabitCategoriesFailed(this.message);
//
//   @override
//   List<Object> get props => [message];
//
//   @override
//   String toString() => 'HabitCategoriesFailed { message: $message }';
// }
