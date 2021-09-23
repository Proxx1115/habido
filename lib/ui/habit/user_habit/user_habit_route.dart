import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/models/custom_habit_settings_response.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/plan.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_reminders.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit/user_habit/plan_terms/plan_term_helper.dart';
import 'package:habido_app/ui/habit/user_habit/plan_terms/plan_terms_widget.dart';
import 'package:habido_app/ui/habit/user_habit/reminder/reminder_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/date_picker.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/slider/custom_slider.dart';
import 'package:habido_app/widgets/slider/slider_bloc.dart';
import 'package:habido_app/widgets/switch.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:showcaseview/showcaseview.dart';
import 'reminder/reminder_widget.dart';
import 'user_habit_screen.dart';

class UserHabitRoute extends StatefulWidget {
  final String? title;
  final UserHabit? userHabit; // UserHabit, habit 2-ын нэг нь заавал утгатай байх ёстой
  final Habit? habit;
  final CustomHabitSettingsResponse? customHabitSettings;

  const UserHabitRoute({
    Key? key,
    this.title,
    this.userHabit,
    this.habit,
    this.customHabitSettings,
  }) : super(key: key);

  @override
  _UserHabitRouteState createState() => _UserHabitRouteState();
}

class _UserHabitRouteState extends State<UserHabitRoute> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          return UserHabitScreen(
            title: widget.title,
            userHabit: widget.userHabit,
            habit: widget.habit,
            customHabitSettings: widget.customHabitSettings,
          );
        },
      ),
    );
  }
}
