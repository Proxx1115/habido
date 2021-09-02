import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/notification_bloc.dart';
import 'package:habido_app/models/notif.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class NotifRoute extends StatefulWidget {
  const NotifRoute({Key? key}) : super(key: key);

  @override
  _NotifRouteState createState() => _NotifRouteState();
}

class _NotifRouteState extends State<NotifRoute> {
  List<Notif>? _notifList;

  @override
  void initState() {
    BlocManager.notifBloc.add(GetFirstNotifsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.notification,
      body: SingleChildScrollView(
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
                        (index) => CustomText(_notifList![index].title),
                      ),
                    )
                  : Container();
            },
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocManager.notifBloc.add(GetNextNotifsEvent(_notifList!.last.notifId ?? 0));
        },
      ),
    );
  }

  void _blocListener(BuildContext context, NotificationState state) {
    if (state is GetFirstNotifsSuccess) {
      _notifList = state.notifList;
    } else if (state is GetNextNotifsSuccess) {
      _notifList?.addAll(state.notifList);
    }
  }
}
