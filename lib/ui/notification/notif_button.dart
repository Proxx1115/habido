import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/notification_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

class NotifButton extends StatefulWidget {
  const NotifButton({Key? key}) : super(key: key);

  @override
  _NotifButtonState createState() => _NotifButtonState();
}

class _NotifButtonState extends State<NotifButton> {
  int _unreadNotifCount = 0;

  @override
  void initState() {
    BlocManager.notifBloc.add(GetUnreadNotifCount(false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.notifBloc,
      child: BlocListener<NotificationBloc, NotificationState>(
        listener: _blocListener,
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            return Badge(
              badgeContent: CustomText('$_unreadNotifCount', color: customColors.whiteText, fontSize: 13.0),
              badgeColor: customColors.primary,
              showBadge: _unreadNotifCount > 0,
              child: ButtonStadium(
                asset: Assets.notification,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.notif);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, NotificationState state) {
    if (state is GetUnreadNotifCountSuccess) {
      _unreadNotifCount = state.unreadNotifCount;
    }
  }
}
