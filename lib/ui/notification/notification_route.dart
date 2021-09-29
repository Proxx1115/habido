import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/notification_bloc.dart';
import 'package:habido_app/models/notif.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationRoute extends StatefulWidget {
  const NotificationRoute({Key? key}) : super(key: key);

  @override
  _NotificationRouteState createState() => _NotificationRouteState();
}

class _NotificationRouteState extends State<NotificationRoute> {
  // Data
  List<Notif> _notifList = [];

  // Refresh
  RefreshController _refreshController = RefreshController(initialRefresh: false);

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
      child: BlocProvider.value(
        value: BlocManager.notifBloc,
        child: BlocListener<NotificationBloc, NotificationState>(
          listener: _blocListener,
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("pull up load");
                    } else if (mode == LoadStatus.loading) {
                      body = cupertino.CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = Text("Load Failed!Click retry!");
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text("release to load more");
                    } else {
                      body = Text("No more Data");
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },

                  // builder: (BuildContext context, LoadStatus mode) {
                  //   Widget body;
                  //   if (mode == LoadStatus.idle) {
                  //     body = Text("pull up load");
                  //   } else if (mode == LoadStatus.loading) {
                  //     body = CupertinoActivityIndicator();
                  //   } else if (mode == LoadStatus.failed) {
                  //     body = Text("Load Failed!Click retry!");
                  //   } else if (mode == LoadStatus.canLoading) {
                  //     body = Text("release to load more");
                  //   } else {
                  //     body = Text("No more Data");
                  //   }
                  //   return Container(
                  //     height: 55.0,
                  //     child: Center(child: body),
                  //   );
                  // },
                  //
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  itemBuilder: (context, index) => ListItemContainer(
                    margin: EdgeInsets.only(bottom: 10.0),
                    height: 70.0,
                    leadingImageUrl: _notifList[index].photo,
                    leadingBackgroundColor: HexColor.fromHex(_notifList[index].color ?? '#F4F6F8'),
                    title: _notifList[index].title ?? '',
                    body: _notifList[index].body,
                    onPressed: () {
                      // Navigator.pushNamed(context, Routes.psyIntro, arguments: {
                      //   'psyTest': el,
                      // });
                    },
                  ),
                  itemExtent: 100.0,
                  itemCount: _notifList.length,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, NotificationState state) {
    if (state is GetFirstNotifsSuccess) {
      _notifList = state.notifList;
    } else if (state is GetNextNotifsSuccess) {
      _notifList.addAll(state.notifList);
    } else if (state is ReadAllNotifSuccess) {
      BlocManager.notifBloc.add(GetUnreadNotifCount(true));
    } else if (state is ReadAllNotifFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    // _notifList.add((_notifList.length + 1).toString());

    if (_notifList.isNotEmpty) {
      BlocManager.notifBloc.add(GetNextNotifsEvent(_notifList.last.notifId ?? 0));
    }

    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }
}
