import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_bloc/flutter_bloc.dart';
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

class SatisfactionNoteListRoute extends StatefulWidget {
  final int? userHabitId;
  const SatisfactionNoteListRoute({Key? key, this.userHabitId}) : super(key: key);

  @override
  State<SatisfactionNoteListRoute> createState() => _SatisfactionNoteListRouteState();
}

class _SatisfactionNoteListRouteState extends State<SatisfactionNoteListRoute> {
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
      appBarTitle: "VFFDFAA", // LocaleKeys.note,
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
      margin: EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        color: customColors.whiteBackground,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Column(children: [
        /// Top section
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          child: Column(
            children: [
              CustomText(
                '${feelingDetails.value!}/10 ${_getText(feelingDetails.value!)}',
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
              ),

              SizedBox(height: 10),

              /// Note
              CustomText(
                feelingDetails.note,
                fontSize: 11.0,
                maxLines: 4,
              ),
            ],
          ),
        ),

        /// Middle section - Image
        CachedNetworkImage(
          imageUrl: feelingDetails.photo!,
          // placeholder: (context, url) => CustomLoader(context, size: 20.0),
          placeholder: (context, url) => Container(),
          errorWidget: (context, url, error) => Container(),
          fit: BoxFit.fill,
        ),

        /// Bottom section - DateTime
        CustomText(
          Func.toDateStr(
              DateTime.parse(
                feelingDetails.date!,
              ),
              dateFormat: 'yyyy-MM-dd, hh:mm'),
          fontSize: 11.0,
          color: customColors.greyText,
          margin: EdgeInsets.fromLTRB(25.0, 12.0, 0.0, 20.0),
        ),
      ]),
    );
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
        return LocaleKeys.pleaseSelectEmoji;
    }
  }
}
