import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/notification_bloc.dart';
import 'package:habido_app/models/notif.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

class NotificationRoute extends StatefulWidget {
  const NotificationRoute({Key? key}) : super(key: key);

  @override
  _NotificationRouteState createState() => _NotificationRouteState();
}

class _NotificationRouteState extends State<NotificationRoute> {
  List<Notif>? _notifList;

  @override
  void initState() {
    BlocManager.notifBloc.add(GetFirstNotifsEvent());
    BlocManager.notifBloc.add(ReadAllNotifEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.notification,
      child: SingleChildScrollView(
        padding: SizeHelper.paddingScreen,
        child: BlocProvider.value(
          value: BlocManager.notifBloc,
          child: BlocListener<NotificationBloc, NotificationState>(
            listener: _blocListener,
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                return (_notifList != null && _notifList!.isNotEmpty)
                    ? Column(
                        children: List.generate(
                          _notifList!.length,
                          (index) => ListItemContainer(
                            margin: EdgeInsets.only(bottom: 10.0),
                            height: 70.0,
                            leadingImageUrl: _notifList![index].photo,
                            leadingBackgroundColor: HexColor.fromHex(_notifList![index].color ?? '#F4F6F8'),
                            title: _notifList![index].title ?? '',
                            body: _notifList![index].body,
                            onPressed: () {
                              // Navigator.pushNamed(context, Routes.psyIntro, arguments: {
                              //   'psyTest': el,
                              // });
                            },
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, NotificationState state) {
    if (state is GetFirstNotifsSuccess) {
      _notifList = state.notifList;
    } else if (state is GetNextNotifsSuccess) {
      _notifList?.addAll(state.notifList);
    } else if (state is ReadAllNotifSuccess) {
      BlocManager.notifBloc.add(GetUnreadNotifCount(true));
    } else if (state is ReadAllNotifFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }
}
