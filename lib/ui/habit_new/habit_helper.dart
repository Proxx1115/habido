import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/models/habit_goal_settings.dart';
import 'package:habido_app/models/habit_progress_response.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/combobox/combo_helper.dart';

class HabitHelper {
  static String? getProgressRoute(Habit habit) {
    HabitGoalSettings? habitGoalSettings = habit.goalSettings;

    switch (habitGoalSettings?.toolType) {
      case ToolType.Minute:
      case ToolType.Hour:
        if (habitGoalSettings?.toolContent?.animation == ToolContentAnimation.BreathingAnimation) {
          return Routes.habitBreath;
        } else if (habitGoalSettings?.toolContent?.animation == ToolContentAnimation.TreeAnimation) {
          return Routes.habitTree;
        } else {
          return Routes.habitTimer;
        }
      case ToolType.Count:
        return Routes.habitWater; // count-iig drink water esehiig odoohondoo yalgahgui
      case ToolType.Income: // todo check this out
      case ToolType.Expense:
        return Routes.habitFinance;
      case ToolType.Feeling:
        if (habit.questionId != null) {
          return Routes.habitFeelingAnswer;
        } else {
          return Routes.habitFeeling;
        }
      case ToolType.Satisfaction:
        return Routes.habitSatisfaction;
      default:
        return Routes.habitTimer;
    }
  }

  static String? getDetailRoute(String toolType) {
    //  HabitGoalSettings? habitGoalSettings = habit.goalSettings;

    switch (toolType) {
      case ToolType.Minute:
      case ToolType.Hour:
        return Routes.habitDetailWithMinute;
      case ToolType.Count:
        return Routes.habitDetailWithCount; // count-iig drink water esehiig odoohondoo yalgahgui
      case ToolType.Income:
        return Routes.habitDetailWithIncome;
      case ToolType.Expense:
        return Routes.habitDetailWithExpense;
      case ToolType.Feeling:
        return Routes.habitDetailWithFeeling;
      case ToolType.Satisfaction:
        return Routes.habitDetailWithSatisfaction;
      default:
        return "";
    }
  }

  static Color getPrimaryColor(String? colorCode) {
    var res = customColors.primary;
    try {
      if (Func.isNotEmpty(colorCode)) {
        res = HexColor.fromHex(colorCode!);
      }
    } catch (e) {
      print(e);
    }

    return res;
  }

  static Color getBackgroundColor(String? colorCode) {
    var res = customColors.primaryBackground;
    try {
      if (Func.isNotEmpty(colorCode)) {
        res = HexColor.fromHex(colorCode!);
      }
    } catch (e) {
      print(e);
    }

    return res;
  }

  static Color getPrimaryColor1(UserHabit userHabit) {
    return userHabit.habit?.color != null ? HexColor.fromHex(userHabit.habit!.color!) : customColors.primary;
  }

  // static Color getPrimaryColor2(Habit habit) {
  //   return habit.color != null ? HexColor.fromHex(habit.color!) : customColors.primary;
  // }

  static Color getPrimaryColor3(HabitCategory habitCategory) {
    return habitCategory.color != null ? HexColor.fromHex(habitCategory.color!) : customColors.primary;
  }

  static Color getBackgroundColor1(UserHabit userHabit) {
    return userHabit.habit?.backgroundColor != null ? HexColor.fromHex(userHabit.habit!.backgroundColor!) : customColors.primaryBackground;
  }

  static Color getBackgroundColor2(Habit habit) {
    return habit.backgroundColor != null ? HexColor.fromHex(habit.backgroundColor!) : customColors.primaryBackground;
  }

  static Color getBackgroundColor3(HabitCategory habitCategory) {
    return habitCategory.backgroundColor != null ? HexColor.fromHex(habitCategory.backgroundColor!) : customColors.primaryBackground;
  }

  static List<ComboItem>? getGoalSettingsComboList(List<HabitGoalSettings>? goalSettingsList) {
    var list = <ComboItem>[];
    try {
      if (goalSettingsList != null) {
        list = List.generate(
          goalSettingsList.length,
          (index) => ComboItem(txt: goalSettingsList[index].goalName ?? '', val: goalSettingsList[index]),
        );
      }
    } catch (e) {
      print(e);
    }

    return list;
  }

  static ComboItem? getGoalSettingsComboItem(HabitGoalSettings? goalSettings) {
    return goalSettings != null ? ComboItem(txt: goalSettings.goalName ?? '', val: goalSettings) : null;
  }
}

class UserHabitHelper {
  static String isPleasing(int value) {
    if (value > 5) {
      // todo check condition Tushig
      return LocaleKeys.pleasing;
    } else {
      return LocaleKeys.notPleasing;
    }
  }
}

/// Хэмжигдэхүүн
class ToolType {
  static const String Minute = 'Minute';
  static const String Hour = 'Hour';
  static const String Count = 'Count';
  static const String Feeling = 'Feeling';
  static const String Satisfaction = 'Satisfaction';
  static const String Income = 'Income';
  static const String Expense = 'Expense';
}

class ToolUnit {
  static const String Minute = 'минут';
  static const String Hour = 'цаг';
  static const String Cup = 'аяга';
  static const String Emoji = 'emoji'; // 1-5
  static const String MNT = '₮';
}

class ToolContentAnimation {
  static const String TreeAnimation = 'TreeAnimation';
  static const String BreathingAnimation = 'BreathingAnimation';
}
