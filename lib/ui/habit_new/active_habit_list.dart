import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/active_habit.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit_new/habit_item_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart' as cupertino;

class ActiveHabitList extends StatefulWidget {
  const ActiveHabitList({Key? key}) : super(key: key);

  @override
  State<ActiveHabitList> createState() => _ActiveHabitListState();
}

class _ActiveHabitListState extends State<ActiveHabitList> {
  List<ActiveHabit> _activeHabitList = [];

  // Refresh
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final SlidableController _controller = SlidableController();

  @override
  void initState() {
    super.initState();
    BlocManager.userHabitBloc.add(GetActiveHabitFirstEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.userHabitBloc,
      child: BlocListener<UserHabitBloc, UserHabitState>(
        listener: _blocListener,
        child: BlocBuilder<UserHabitBloc, UserHabitState>(builder: (context, state) {
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
              itemBuilder: (context, index) => HabitItemWidget(
                data: _activeHabitList[index],
                isActiveHabit: true,
                onTap: () {
                  _navigateToHabitDetailRoute(context, _activeHabitList[index]);
                },
              ),
              // itemExtent: 90.0,

              itemCount: _activeHabitList.length,
            ),
          );
        }),
      ),
    );
  }

  void _blocListener(BuildContext context, UserHabitState state) {
    if (state is GetActiveHabitFirstSuccess) {
      _activeHabitList = state.activeHabitList;
      print('asdsadas ${state.activeHabitList}');
    } else if (state is GetActiveHabitFirstFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is GetActiveHabitThenSuccess) {
      _activeHabitList.addAll(state.activeHabitList);
    } else if (state is GetActiveHabitThenFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _navigateToHabitDetailRoute(BuildContext context, ActiveHabit habitData) {
    // Navigate
    // if (habitData.goalType != null) {
    String? route = HabitHelper.getDetailRoute(habitData.goalType!);
    if (route != null) {
      Navigator.pushNamed(
        context,
        route,
        arguments: {
          'userHabitId': habitData.userHabitId,
          'name': habitData.name,
          'isActive': true,
        },
      );
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    _activeHabitList = [];
    BlocManager.userHabitBloc.add(GetActiveHabitFirstEvent());

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    // _notifList.add((_notifList.length + 1).toString());

    if (_activeHabitList.isNotEmpty) {
      BlocManager.userHabitBloc.add(GetActiveHabitThenEvent(_activeHabitList.last.habitId ?? 0));
    }

    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }
}
