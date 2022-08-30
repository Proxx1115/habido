import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/completed_habit.dart';
import 'package:habido_app/ui/habit_new/empty_habit_widget.dart';
import 'package:habido_app/ui/habit_new/habit_helper.dart';
import 'package:habido_app/ui/habit_new/habit_item_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart' as cupertino;

class CompletedHabitList extends StatefulWidget {
  const CompletedHabitList({Key? key}) : super(key: key);

  @override
  State<CompletedHabitList> createState() => _CompletedHabitListState();
}

class _CompletedHabitListState extends State<CompletedHabitList> {
  List<CompletedHabit>? _completedHabitList;

  // Refresh
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final SlidableController _controller = SlidableController();

  @override
  void initState() {
    super.initState();
    BlocManager.userHabitBloc.add(GetCompletedHabitFirstEvent());
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
            child: _completedHabitList != null
                ? _completedHabitList!.length != 0
                    ? ListView.builder(
                        itemBuilder: (context, index) => HabitItemWidget(
                          data: _completedHabitList![index],
                          isActiveHabit: false,
                          onTap: () {
                            _navigateToHabitDetailRoute(context, _completedHabitList![index]);
                          },
                        ),
                        // itemExtent: 90.0,

                        itemCount: _completedHabitList!.length,
                      )
                    : EmptyHabitWidget(Assets.emptyman, LocaleKeys.completedHabitEmpty)
                : Container(),
          );
        }),
      ),
    );
  }

  void _blocListener(BuildContext context, UserHabitState state) {
    if (state is GetCompletedHabitFirstSuccess) {
      _completedHabitList = state.completedHabitList;
    } else if (state is GetCompletedHabitFirstFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is GetCompletedHabitThenSuccess) {
      _completedHabitList = state.completedHabitList;
    } else if (state is GetCompletedHabitThenFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  _navigateToHabitDetailRoute(BuildContext context, CompletedHabit habitData) {
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
        },
      );
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _completedHabitList = [];
    BlocManager.userHabitBloc.add(GetCompletedHabitFirstEvent());

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor ytwork fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (_completedHabitList != null && _completedHabitList!.isNotEmpty) {
      BlocManager.userHabitBloc.add(GetCompletedHabitThenEvent(_completedHabitList!.last.userHabitId ?? 0));
    }

    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }
}
