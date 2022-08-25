import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/notification_bloc.dart';
import 'package:habido_app/models/notif.dart';
import 'package:habido_app/models/notif_list_response.dart';
import 'package:habido_app/models/notif_list_with_date.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationRouteNew extends StatefulWidget {
  const NotificationRouteNew({Key? key}) : super(key: key);

  @override
  _NotificationRouteNewState createState() => _NotificationRouteNewState();
}

class _NotificationRouteNewState extends State<NotificationRouteNew> {
  // Data
  List<Notif> _notifList = [];
  List<NotifListWithDate>? _notifListWithDate;

  // Refresh
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final SlidableController _controller = SlidableController();

  @override
  void initState() {
    BlocManager.notifBloc.add(GetLastNotifEvent());
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
                  header: ClassicHeader(
                    refreshStyle: RefreshStyle.Follow,
                    idleText: '',
                    idleIcon: Icon(Icons.expand_more, color: Colors.grey),
                    releaseText: "",
                    refreshingText: "",
                    completeText: "",
//            completeIcon: null,
                  ),
                  // header: WaterDropHeader(
                  //
                  // ),

                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Container(); // pull up load
                      } else if (mode == LoadStatus.loading) {
                        body = cupertino.CupertinoActivityIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Container(); // Load Failed! Click retry!
                      } else if (mode == LoadStatus.canLoading) {
                        body = Container(); // release to load more
                      } else {
                        body = Container(); // No more Data
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          // SizedBox(height: 20.0,),
                          if (_notifListWithDate != null)
                            for (var el in _notifListWithDate!)
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    SizeHelper.padding,
                                    SizeHelper.padding,
                                    SizeHelper.padding,
                                    0.0),
                                child: Column(
                                  children: [
                                    CustomText(
                                      // DateFormat().format(el.date),
                                      Func.toDateStr(Func.toDate(el.date)),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      // el.notifList != null
                                      //     ? el.notifList![0].title
                                      //     : '',
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    el.notifList != null
                                        ? SizedBox(
                                            height: 70.0 * el.notifList!.length,
                                            child: ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: el.notifList!.length,
                                              itemBuilder: (context, index) {
                                                return _list(
                                                  el.notifList![index],
                                                  index,
                                                  el.notifList!.length,
                                                  index == 0,
                                                  index == el.notifList!.length,
                                                );
                                              },
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                  )
                  // child: ListView.builder(
                  //   itemBuilder: (context, index) => _listItem(index),
                  //   // itemExtent: 90.0,

                  //   itemCount: _notifList.length,

                  );
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, NotificationState state) {
    if (state is ReadAllNotifSuccess) {
      BlocManager.notifBloc.add(GetUnreadNotifCount(true));
    } else if (state is GetLastNotifSuccess) {
      _notifListWithDate = state.notifListWithDate;
    } else if (state is GetOldNotifsSuccess) {
      _notifListWithDate!.addAll(state.notifListWithDate);
    } else if (state is ReadAllNotifFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _list(Notif data, int index, int length, bool isborderTop,
      bool isborderBottom) {
    return MoveInAnimation(
      delay: Func.toDouble(index * 0.2),
      child: Dismissible(
        key: Key(data.notifId.toString()),
        onDismissed: (direction) {
          // Remove the item from the data source.
          setState(() {
            _notifList.removeAt(index);
          });
          // BlocManager.notifBloc.add(DeleteNotifEvent(data.notifId ?? 0));
        },
        child: ListItemContainer(
          borderRadius: _border(index, length),
          // isborderTop || isborderBottom
          //     ? isborderTop
          // ? BorderRadius.only(
          //     topLeft: Radius.circular(15.0),
          //     topRight: Radius.circular(15.0))
          //         : BorderRadius.only(
          //             bottomRight: Radius.circular(15.0),
          //             bottomLeft: Radius.circular(15.0))
          // : BorderRadius.all(Radius.circular(0.0)),
          height: 70.0,
          leadingImageUrl: data.photo,
          leadingColor: HexColor.fromHex(ColorCodes.primary),
          leadingBackgroundColor: HexColor.fromHex(data.color ?? '#F4F6F8'),
          // suffixAsset: Assets.arrow_forward,
          // suffixColor: customColors.primary,
          title: data.title ?? '',
          body: data.body,
          date: data.createdAt,
          // date: Func.toTimeStr(data.createdAt),
          onPressed: () {
            print(data.createdAt);
            showCustomDialog(
              context,
              child: CustomDialogBody(
                buttonText: LocaleKeys.ok,
                child: Column(
                  children: [
                    /// Image
                    if (Func.isNotEmpty(data.photo))
                      Container(
                        margin: EdgeInsets.only(right: 15.0),
                        padding: EdgeInsets.all(10.0),
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeHelper.borderRadius)),
                          color: customColors.greyBackground,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: data.photo!,
                          placeholder: (context, url) => Container(),
                          //CustomLoader(),
                          errorWidget: (context, url, error) => Container(),
                          height: 40.0,
                          // width: 40.0,
                          fit: BoxFit.fitHeight,
                        ),
                      ),

                    /// Title
                    CustomText(
                      data.title,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      fontWeight: FontWeight.w500,
                    ),

                    // Body
                    CustomText(
                      data.body,
                      margin: EdgeInsets.only(bottom: 30.0),
                      maxLines: 10,
                      color: customColors.greyText,
                    ),
                  ],
                ),
                onPressedButton: () {
                  print(data.photo);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    _notifList = [];
    BlocManager.notifBloc.add(GetFirstNotifsEvent());

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    // _notifList.add((_notifList.length + 1).toString());

    if (_notifList.isNotEmpty) {
      BlocManager.notifBloc
          .add(GetNextNotifsEvent(_notifList.last.notifId ?? 0));
    }

    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }
}

_border(int index, int length) {
  if (index == length) {
    BorderRadius.all(Radius.circular(15.0));
  } else if (index == 0 && length != 0) {
    BorderRadius.only(
        topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0));
  } else if (index != 0 && length == 0) {
    BorderRadius.only(
        bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0));
  } else {
    BorderRadius.all(Radius.circular(0.0));
  }
}
