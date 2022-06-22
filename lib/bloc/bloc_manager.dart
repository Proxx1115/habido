import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/all_habit_bloc.dart';
import 'package:habido_app/bloc/home_new_bloc.dart';
import 'package:habido_app/bloc/main_bloc.dart';
import 'package:habido_app/bloc/notification_bloc.dart';
import 'package:habido_app/bloc/param_bloc.dart';
import 'package:habido_app/bloc/achievements_bloc.dart';
import 'package:habido_app/bloc/psy_test_dashboard_bloc.dart';
import 'package:habido_app/bloc/psy_test_main_bloc.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/ui/content_v2/content_bloc_v2.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_bloc_v2/psy_test_bloc_v2.dart';
import 'auth_bloc.dart';
import 'calendar_bloc.dart';
import 'chat_bloc.dart';
import 'home_bloc.dart';
import 'user_bloc.dart';

class BlocManager {
  static final mainBloc = MainBloc();
  static final authBloc = AuthBloc();
  static final userBloc = UserBloc();
  static final paramBloc = ParamBloc();
  static final chatBloc = ChatBloc();
  static final homeBloc = HomeBloc();
  static final psyTestMainBloc = PsyTestMainBloc();
  static final psyTestDashboardBloc = PsyTestDashBoardBloc();
  static final dashboardBloc = DashboardBloc();
  static final calendarBloc = CalendarBloc();
  static final notifBloc = NotificationBloc();
  static final achievementBloc = AchievementBloc();
  static final userHabitBloc = UserHabitBloc();
  static final contentBlocV2 = ContentBlocV2();
  static final psyTestBlocV2 = TestsBlocV2();
  static final homeNewBloc = HomeNewBloc();
  static final allHabitBloc = AllHabitBloc();

  static void dispose() {
    mainBloc.close();
    authBloc.close();
    userBloc.close();
    paramBloc.close();
    chatBloc.close();
    homeBloc.close();
    psyTestMainBloc.close();
    psyTestDashboardBloc.close();
    dashboardBloc.close();
    calendarBloc.close();
    notifBloc.close();
    achievementBloc.close();
    userHabitBloc.close();
    psyTestBlocV2.close();
    homeNewBloc.close();
    allHabitBloc.close();
    contentBlocV2.close();
  }
}

/// Custom [BlocObserver] which observes all bloc and cubit instances.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final MainBloc mainBloc;

  LifecycleEventHandler(this.mainBloc);

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        onPaused();
        break;
      case AppLifecycleState.resumed:
        onResume();
        break;
    }
  }

  void onResume() {}

  void onResumeDone(bool done) {}

  void onPaused() {}
}
