import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/custom_habit_settings_response.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

class HabitCategoryBloc extends Bloc<HabitCategoryEvent, HabitCategoryState> {
  HabitCategoryBloc() : super(HabitCategoryInit());

  @override
  Stream<HabitCategoryState> mapEventToState(HabitCategoryEvent event) async* {
    if (event is GetHabitCategoriesEvent) {
      yield* _mapGetHabitCategoriesEventToState();
    } else if (event is HabitCategoryShowcaseEvent) {
      yield* _mapHabitCategoryShowcaseEventState(event);
    } else if (event is GetCustomHabitSettingsEvent) {
      yield* _mapGetCustomHabitSettingsEventState(event);
    }
  }

  Stream<HabitCategoryState> _mapGetHabitCategoriesEventToState() async* {
    try {
      yield HabitCategoriesLoading();

      var res = await ApiManager.habitCategories();
      if (res.code == ResponseCode.Success && res.habitCategoryList != null && res.habitCategoryList!.length > 0) {
        yield HabitCategoriesSuccess(res.habitCategoryList!);
      } else {
        yield HabitCategoriesFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield HabitCategoriesFailed(LocaleKeys.errorOccurred);
    }
  }

  Stream<HabitCategoryState> _mapHabitCategoryShowcaseEventState(HabitCategoryShowcaseEvent event) async* {
    if (!SharedPref.getShowcaseHasShown(event.showcaseKeyName)) {
      List<GlobalKey> keyList = ShowcaseKey.getKeysByName(event.showcaseKeyName);
      if (keyList.isNotEmpty) {
        yield HabitCategoryShowcaseState(keyList);
        SharedPref.setShowcaseHasShown(event.showcaseKeyName, true);
      }
    }
  }

  Stream<HabitCategoryState> _mapGetCustomHabitSettingsEventState(GetCustomHabitSettingsEvent event) async* {
    try {
      yield HabitCategoriesLoading();

      var res = await ApiManager.dynamicHabitSettings();
      if (res.code == ResponseCode.Success) {
        var customHabit = Habit()
          ..habitId = 0
          ..categoryId = event.habitCategory.categoryId
          ..name = ''
          ..contentId = 0
          ..questionId = 0
          ..tip = ''
          ..color = event.habitCategory.color
          ..backgroundColor = event.habitCategory.backgroundColor
          ..photo = ''
          ..goalSettings = null;

        yield CustomHabitSettingsSuccess(customHabit, res);
      } else {
        yield CustomHabitSettingsFailed(Func.isNotEmpty(res.message) ? res.message! : LocaleKeys.noData);
      }
    } catch (e) {
      yield CustomHabitSettingsFailed(LocaleKeys.errorOccurred);
    }
  }
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC EVENTS
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitCategoryEvent extends Equatable {
  const HabitCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetHabitCategoriesEvent extends HabitCategoryEvent {}

class HabitCategoryShowcaseEvent extends HabitCategoryEvent {
  final String showcaseKeyName;

  const HabitCategoryShowcaseEvent(this.showcaseKeyName);

  @override
  List<Object> get props => [showcaseKeyName];

  @override
  String toString() => 'HabitCategoryShowcaseEvent { showcaseKeyNameList: $showcaseKeyName }';
}

class GetCustomHabitSettingsEvent extends HabitCategoryEvent {
  final HabitCategory habitCategory;

  const GetCustomHabitSettingsEvent(this.habitCategory);

  @override
  List<Object> get props => [habitCategory];

  @override
  String toString() => 'GetCustomHabitSettingsEvent { habitCategory: $habitCategory }';
}

/// ---------------------------------------------------------------------------------------------------------------------------------------------------
/// BLOC STATES
/// ---------------------------------------------------------------------------------------------------------------------------------------------------

abstract class HabitCategoryState extends Equatable {
  const HabitCategoryState();

  @override
  List<Object> get props => [];
}

class HabitCategoryInit extends HabitCategoryState {}

class HabitCategoriesLoading extends HabitCategoryState {}

class HabitCategoriesVoid extends HabitCategoryState {}

class HabitCategoriesSuccess extends HabitCategoryState {
  final List<HabitCategory> habitCategoryList;

  const HabitCategoriesSuccess(this.habitCategoryList);

  @override
  List<Object> get props => [habitCategoryList];

  @override
  String toString() => 'HabitCategoriesSuccess { habitCategoryList: $habitCategoryList }';
}

class HabitCategoriesFailed extends HabitCategoryState {
  final String message;

  const HabitCategoriesFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'HabitCategoriesFailed { message: $message }';
}

class HabitCategoryShowcaseState extends HabitCategoryState {
  final List<GlobalKey> showcaseKeyList;

  const HabitCategoryShowcaseState(this.showcaseKeyList);

  @override
  List<Object> get props => [showcaseKeyList];

  @override
  String toString() => 'HabitCategoryShowcaseState { showcaseKeyList: $showcaseKeyList }';
}

class CustomHabitSettingsSuccess extends HabitCategoryState {
  final Habit customHabit;
  final CustomHabitSettingsResponse customHabitSettings;

  const CustomHabitSettingsSuccess(this.customHabit, this.customHabitSettings);

  @override
  List<Object> get props => [customHabitSettings];

  @override
  String toString() =>
      'DynamicHabitSettingsSuccess { habit: $customHabit, dynamicHabitSettings: $customHabitSettings }';
}

class CustomHabitSettingsFailed extends HabitCategoryState {
  final String message;

  const CustomHabitSettingsFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'CustomHabitSettingsFailed { message: $message }';
}
