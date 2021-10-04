import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit_progress_log.dart';

class HabitTimerHelper {
  static void logAdd(int? userHabitId, int? addTime) {
    var progressLog = UserHabitProgressLog()
      ..userHabitId = userHabitId
      ..planLogId = 0
      ..planId = 0
      ..status = UserHabitProgressLogStatus.Add
      ..addTime = addTime
      ..spentTime = 0;

    BlocManager.userHabitBloc.add(UpdateUserHabitProgressLogEvent(progressLog));
  }

  static void logReset(int? userHabitId) {
    var progressLog = UserHabitProgressLog()
      ..userHabitId = userHabitId
      ..planLogId = 0
      ..planId = 0
      ..status = UserHabitProgressLogStatus.Reset
      ..addTime = 0
      ..spentTime = 0;

    BlocManager.userHabitBloc.add(UpdateUserHabitProgressLogEvent(progressLog));
  }

  static void logPause(int? userHabitId, int? spentTime) {
    var progressLog = UserHabitProgressLog()
      ..userHabitId = userHabitId
      ..planLogId = 0
      ..planId = 0
      ..status = UserHabitProgressLogStatus.Pause
      ..addTime = 0
      ..spentTime = spentTime;

    BlocManager.userHabitBloc.add(UpdateUserHabitProgressLogEvent(progressLog));
  }

  static void logPlay(int? userHabitId, int? spentTime) {
    var progressLog = UserHabitProgressLog()
      ..userHabitId = userHabitId
      ..planLogId = 0
      ..planId = 0
      ..status = UserHabitProgressLogStatus.Play
      ..addTime = 0
      ..spentTime = spentTime;

    BlocManager.userHabitBloc.add(UpdateUserHabitProgressLogEvent(progressLog));
  }
}
