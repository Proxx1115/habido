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

import 'package:habido_app/models/habit_goal_settings.dart';

class GoalHelper {
  static bool visibleSlider(HabitGoalSettings habitGoalSettings) {
    bool res = false;

    switch (habitGoalSettings.toolType) {
      case ToolTypes.Minute:
      case ToolTypes.Count:
      case ToolTypes.Hour:
      case ToolTypes.Amount:
        if (habitGoalSettings.goalMin != null && habitGoalSettings.goalMax != null) res = true;
        break;
      case ToolTypes.Feeling:
      case ToolTypes.Satisfaction:
      case ToolTypes.Music:
      case ToolTypes.Animation:
      default:
        res = false;
    }

    return res;
  }
}

class ToolTypes {
  static const String Minute = 'Minute';
  static const String Count = 'Count';
  static const String Hour = 'Hour';
  static const String Feeling = 'Feeling';
  static const String Satisfaction = 'Satisfaction';
  static const String Amount = 'Amount';
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
  static const String Amount = '₮';

  /// Emoji
  static const String Emoji = 'emoji';

  /// Music
  static const String Music = 'link';
}
