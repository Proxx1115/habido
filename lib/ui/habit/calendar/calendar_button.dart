import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

class CalendarButton extends StatefulWidget {
  const CalendarButton({Key? key}) : super(key: key);

  @override
  _CalendarButtonState createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.dashboardBloc,
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: _blocListener,
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Badge(
              badgeContent: CustomText('${globals.calendarBadgeCount}', color: customColors.whiteText, fontSize: 13.0),
              badgeColor: customColors.primary,
              showBadge: globals.calendarBadgeCount > 0,
              child: ButtonStadium(
                asset: Assets.calendar,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.calendar);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, DashboardState state) {
    if (state is RefreshDashboardUserHabitsSuccess) {
      globals.calendarBadgeCount = state.todayUserHabits?.length ?? 0;
    }
  }
}
