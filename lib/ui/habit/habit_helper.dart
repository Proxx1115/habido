import 'package:flutter/material.dart';
import 'package:habido_app/models/habit_goal_settings.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';

class HabitHelper {
  static String? getProgressRoute(HabitGoalSettings habitGoalSettings) {
    switch (habitGoalSettings.toolType) {
      case ToolTypes.Minute:
      case ToolTypes.Hour:
        return Routes.habitTimer;
      case ToolTypes.Count:
        return Routes.habitWater; // todo test count-iig drink water esehiig odoohondoo yalgahgui
      case ToolTypes.Income:
      case ToolTypes.Expense:
        return Routes.habitTimer;
      case ToolTypes.Feeling:
        return Routes.habitFeeling;
      case ToolTypes.Satisfaction:
        return Routes.habitSatisfaction;
      case ToolTypes.Music:
      case ToolTypes.Animation:
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

// static bool visibleGoalSlider(HabitGoalSettings habitGoalSettings) {
//   bool res = false;
//
//   if(habitGoalSettings)
//
//   switch (habitGoalSettings.toolType) {
//     case ToolTypes.Minute:
//     case ToolTypes.Count:
//     case ToolTypes.Hour:
//     case ToolTypes.Income:
//     case ToolTypes.Expense:
//     case ToolTypes.Music:
//     case ToolTypes.Animation:
//       if (Func.toInt(habitGoalSettings.goalMin) >= 0 && Func.toInt(habitGoalSettings.goalMax) > 0) res = true;
//       break;
//     case ToolTypes.Feeling:
//     case ToolTypes.Satisfaction:
//     default:
//       res = false;
//   }
//
//   return res;
// }

}

//1	Хугацаа	0	60	Minute	минут
//2	Хэмжээ	0	12	Count	Аяга
//3	Хугацаа	0	96	Hour	цаг
//4	Feeling	1	5	Feeling	emoji
//5	Satisfaction	1	10	Satisfaction	camera
//6	Төгрөг	0	1000000000	Amount	₮
//7	Music	0	1000000000	Music	https://www.youtube.com/watch?v=0tdnAH58rEw=AniMelody%E2%80%93AnimeMusic
//8	Animation	0	1000000000	Animation	Tree animation
//10	Creativity	0	100	Animation	Creativity
//9	Animation	0	100	Animation	Breathing animation

/// Хэмжигдэхүүн
class ToolTypes {
  static const String Minute = 'Minute';
  static const String Hour = 'Hour';
  static const String Count = 'Count';
  static const String Feeling = 'Feeling';
  static const String Satisfaction = 'Satisfaction';
  static const String Income = 'Income';
  static const String Expense = 'Expense';
  static const String Music = 'Music';
  static const String Animation = 'Animation';
}

class ToolContents {
  /// Animation
  static const String BreathingAnimation = 'Breathing animation';
  static const String TreeAnimation = 'Tree animation';
  static const String Creativity = 'Creativity';

  /// Time
  static const String Minute = 'минут';
  static const String Hour = 'цаг';

  /// Quantity, count
  static const String Cup = 'Аяга';

  /// Camera
  static const String Camera = 'camera';

  /// Amount
  static const String Income = '₮';
  static const String Expense = '₮';

  /// Emoji
  static const String Emoji = 'emoji';

  /// Music
  static const String Music = 'link';
}
