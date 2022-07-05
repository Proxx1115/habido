import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit_details_feeling.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeelingNoteListRoute extends StatefulWidget {
  final int? userHabitId;
  const FeelingNoteListRoute({Key? key, this.userHabitId}) : super(key: key);

  @override
  State<FeelingNoteListRoute> createState() => _FeelingNoteListRouteState();
}

class _FeelingNoteListRouteState extends State<FeelingNoteListRoute> {
  // Feeling Details Latest List
  List<UserHabitDetailsFeeling>? _userHabitDetailsFeelingList;

// Refresh
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    BlocManager.userHabitBloc.add(GetUserHabitDetailsFeelingLatestEvent(widget.userHabitId!));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.note,
      child: BlocProvider.value(
        value: BlocManager.userHabitBloc,
        child: BlocListener<UserHabitBloc, UserHabitState>(
          listener: _blocListener,
          child: BlocBuilder<UserHabitBloc, UserHabitState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  _blocListener(BuildContext context, UserHabitState state) {
    if (state is GetFeelingDetailsLatestSuccess) {
      _userHabitDetailsFeelingList = state.userHabitDetailsFeelingList.take(3).toList();
    } else if (state is GetFeelingDetailsLatestFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, UserHabitState state) {
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
      child: ListView.builder(
        itemBuilder: (context, index) => Container(),
        // _listItem(index),
        // itemExtent: 90.0,

        itemCount: _userHabitDetailsFeelingList!.length,
      ),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    _userHabitDetailsFeelingList = [];
    BlocManager.userHabitBloc.add(GetUserHabitDetailsFeelingLatestEvent(widget.userHabitId!));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    // _notifList.add((_notifList.length + 1).toString());

    if (_userHabitDetailsFeelingList!.isNotEmpty) {
      // BlocManager.notifBloc.add(GetNextNotifsEvent(_notifList.last.notifId ?? 0));
    }

    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }
}
