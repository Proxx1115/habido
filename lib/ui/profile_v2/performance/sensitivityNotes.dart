import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/mood_tracker_latest.dart';
import 'package:habido_app/models/mood_tracker_latest_response.dart';
import 'package:habido_app/ui/profile_v2/performance/feeling_last.dart';
import 'package:habido_app/ui/profile_v2/performance/performance_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart' as cupertino;

class SensitivityNotes extends StatefulWidget {
  // Refresh
  const SensitivityNotes({Key? key}) : super(key: key);

  @override
  State<SensitivityNotes> createState() => _SensitivityNotesState();
}

class _SensitivityNotesState extends State<SensitivityNotes> {
  /// REFRESH
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  /// MOOD TRACKER LATEST
  List<MoodTrackerLatest> _moodTracker = [];

  @override
  void initState() {
    BlocManager.performanceBloc.add(GetMoodTrackerLatestEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: "Тэмдэглэл",
      child: BlocProvider.value(
        value: BlocManager.performanceBloc,
        child: BlocListener<PerformanceBloc, PerformanceState>(
          listener: _blocListener,
          child: BlocBuilder<PerformanceBloc, PerformanceState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, PerformanceState state) {
    if (state is MoodTrackerLatestSuccess) {
      _moodTracker = state.moodTracker;
      print("eminem:${state.moodTracker}");
    } else if (state is ModdTrackerLatestFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is MoodTrackerThenSuccess) {
      // print()
      _moodTracker.addAll(state.moodTracker);
    } else if (state is ModdTrackerThenFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, PerformanceState state) {
    return
        // _moodTrackerResponse != null
        //   ?
        SmartRefresher(
            enablePullDown: false,
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ListView.builder(
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: FeelingLast(
                    answerImageUrl: '${_moodTracker[index].answerImageUrl}',
                    answerText: '${_moodTracker[index].answerText!}',
                    reasons: _moodTracker[index].reasons!,
                    writtenAnswer: '${_moodTracker[index].writtenAnswer!}',
                    bottomDate: '${_moodTracker[index].date!}',
                    maxLines: 2,
                  ),
                ),
                itemCount: _moodTracker.length,
              ),
            ));
    // : Container();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    // _notifList = [];
    // BlocManager.notifBloc.add(GetFirstNotifsEvent());
    //
    // _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    // _notifList.add((_notifList.length + 1).toString());

    if (_moodTracker.isNotEmpty) {
      BlocManager.performanceBloc.add(GetMoodTrackerThenEvent(_moodTracker.last.userFeelingId ?? 0));
    }

    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }
}
