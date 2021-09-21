import 'package:flutter/material.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/habit_goal_settings.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';

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
        // todo test count-iig drink water esehiig odoohondoo yalgahgui
        return Routes.habitWater;
      case ToolType.Income:
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

  static Color getPrimaryColor(UserHabit userHabit) {
    return userHabit.habit?.color != null ? HexColor.fromHex(userHabit.habit!.color!) : customColors.primary;
  }

  static Color getBackgroundColor(UserHabit userHabit) {
    return userHabit.habit?.backgroundColor != null
        ? HexColor.fromHex(userHabit.habit!.backgroundColor!)
        : customColors.primaryBackground;
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
