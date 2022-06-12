import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/notification_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
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
              badgeContent: CustomText('${globals.unreadNotifCount}', color: customColors.whiteText, fontSize: 13.0),
              badgeColor: customColors.primary,
              showBadge: globals.unreadNotifCount > 0,
              child: ButtonStadium(
                size: 20,
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
      globals.unreadNotifCount = state.unreadNotifCount;
    }
  }
}
