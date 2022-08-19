import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit_details_feeling.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
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
      padding: EdgeInsets.fromLTRB(SizeHelper.padding, 30.0, SizeHelper.padding, SizeHelper.padding),
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
      _userHabitDetailsFeelingList = state.userHabitDetailsFeelingList;
    } else if (state is GetFeelingDetailsLatestFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is GetFeelingDetailsThenSuccess) {
      _userHabitDetailsFeelingList!.addAll(state.userHabitDetailsFeelingList);
    } else if (state is GetFeelingDetailsThenFailed) {
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
      child: _userHabitDetailsFeelingList != null
          ? ListView.builder(
              itemBuilder: (context, index) => _listItem(index),
              // itemExtent: 90.0,

              itemCount: _userHabitDetailsFeelingList!.length,
            )
          : Container(),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    // _userHabitDetailsFeelingList = [];
    BlocManager.userHabitBloc.add(GetUserHabitDetailsFeelingLatestEvent(widget.userHabitId!));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    // _notifList.add((_notifList.length + 1).toString());

    if (_userHabitDetailsFeelingList!.isNotEmpty) {
      BlocManager.userHabitBloc.add(GetUserHabitDetailsFeelingNextEvent(widget.userHabitId!, _userHabitDetailsFeelingList!.last.planId ?? 0));
    }

    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }

  Widget _listItem(int index) {
    final feelingDetails = _userHabitDetailsFeelingList![index];
    return Container(
      height: 130.0,
      padding: EdgeInsets.fromLTRB(16.0, 12.0, 13.0, 10.0),
      margin: EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: customColors.whiteBackground,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Row(
        children: [
          /// Date
          Container(
            // color: Colors.teal,
            // decoration: BoxDecoration(
            //   color: customColors.greyBackground,
            //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
            // ),
            child: Column(
              children: [
                CustomText(
                  Func.toRomboMonth(Func.getMonthFromDateStr(feelingDetails.date!)),
                  color: customColors.greyText,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
                CustomText(
                  Func.getDayFromDateStr(feelingDetails.date!),
                  color: customColors.greyText,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0,
                ),
              ],
            ),
          ),

          SizedBox(width: 19.0),

          Expanded(
            child: Column(children: [
              Container(
                // color: Colors.teal,
                child: Row(
                  children: [
                    /// Feeling emoji
                    Container(
                      height: 20,
                      width: 20,
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: customColors.whiteBackground,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: SvgPicture.asset(_getAsset(feelingDetails.value!)),
                    ),

                    SizedBox(width: 6.0),

                    /// Feeling name
                    Expanded(
                      child: CustomText(
                        _getText(feelingDetails.value!),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                      ),
                    ),

                    CustomText(
                      Func.toTimeStr(feelingDetails.date!),
                      fontSize: 11.0,
                      color: customColors.greyText,
                    ),
                  ],
                ),
              ),

              Container(
                // color: Colors.red,
                child: CustomDivider(
                  margin: EdgeInsets.symmetric(vertical: 6.0),
                ),
              ),

              /// Note
              Expanded(
                child: Container(
                  // color: Colors.amber,
                  child: CustomText(
                    feelingDetails.note,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    alignment: Alignment.topLeft,
                    maxLines: 100,
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  _getAsset(int index) {
    switch (index) {
      case 1:
        return Assets.sad_emoji;
      case 2:
        return Assets.unpleasant_emoji;
      case 3:
        return Assets.unknown_emoji;
      case 4:
        return Assets.calm_emoji;
      case 5:
        return Assets.happy_emoji;
      default:
        return Assets.sad_emoji;
    }
  }

  String _getText(int index) {
    switch (index) {
      case 1:
        return LocaleKeys.recapDayEmoji1;
      case 2:
        return LocaleKeys.recapDayEmoji2;
      case 3:
        return LocaleKeys.recapDayEmoji3;
      case 4:
        return LocaleKeys.recapDayEmoji4;
      case 5:
        return LocaleKeys.recapDayEmoji5;
      default:
        return LocaleKeys.howIsYourFeeling;
    }
  }
}
