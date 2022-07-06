import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit_details_feeling.dart';
import 'package:habido_app/models/user_habit_feeling_pie_chart_feeling.dart';
import 'package:habido_app/models/user_habit_plan_count.dart';
import 'package:habido_app/ui/habit_new/habit_detail/delete_button_widget.dart';
import 'package:habido_app/ui/habit_new/habit_detail/performance_widget.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitDetailWithFeelingRoute extends StatefulWidget {
  final int? userHabitId;
  final String? name;
  final bool? isCompleted;

  const HabitDetailWithFeelingRoute({
    Key? key,
    this.userHabitId,
    this.name,
    this.isCompleted,
  }) : super(key: key);

  @override
  State<HabitDetailWithFeelingRoute> createState() => _HabitDetailWithFeelingRouteState();
}

class _HabitDetailWithFeelingRouteState extends State<HabitDetailWithFeelingRoute> {
  UserHabitPlanCount? _userHabitPlanCount;

  // Total count
  int? _totalCount;

  // Graph
  List<UserHabitFeelingPieChartFeeling>? _feelings;

  // Feeling Details Latest List
  List<UserHabitDetailsFeeling>? _userHabitDetailsFeelingList;

  @override
  void initState() {
    super.initState();
    BlocManager.userHabitBloc.add(GetUserHabitPlanCountEvent(widget.userHabitId!));
    BlocManager.userHabitBloc.add(GetHabitFeelingChartDataEvent(widget.userHabitId!));
    BlocManager.userHabitBloc.add(GetUserHabitDetailsFeelingLatestEvent(widget.userHabitId!));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
    if (state is GetUserHabitPlanCountSuccess) {
      _userHabitPlanCount = state.userHabitPlanCount;
    } else if (state is GetUserHabitPlanCountFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is HabitFeelingPieChartSuccess) {
      _totalCount = state.totalCount;
      _feelings = state.feelings;
    } else if (state is HabitFeelingPieChartFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is GetFeelingDetailsLatestSuccess) {
      _userHabitDetailsFeelingList = state.userHabitDetailsFeelingList.take(3).toList();
    } else if (state is GetFeelingDetailsLatestFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, UserHabitState state) {
    return CustomScaffold(
      appBarTitle: widget.name,
      child: SingleChildScrollView(
        padding: SizeHelper.screenPadding,
        child: Column(
          children: [
            SizedBox(height: 18.0),

            CustomText(
              LocaleKeys.execution,
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
            ),

            SizedBox(height: 15.0),

            /// Performance Info
            _userHabitPlanCount != null
                ? PerformanceWidget(
                    totalPlans: _userHabitPlanCount!.totalPlans,
                    completedPlans: _userHabitPlanCount!.completedPlans,
                    skipPlans: _userHabitPlanCount!.skipPlans,
                    uncompletedPlans: _userHabitPlanCount!.uncompletedPlans,
                  )
                : Container(),

            SizedBox(height: 15.0),

            /// Feeling Chart & Info
            (_feelings != null && _totalCount != null && _totalCount! > 0) ? _feelingInfo() : Container(),

            SizedBox(height: 15.0),

            /// Title - (Note)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  LocaleKeys.note,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
                NoSplashContainer(
                  child: InkWell(
                    onTap: () {
                      _navigateToFeelingNotesRoute();
                    },
                    child: CustomText(
                      LocaleKeys.seeAllNote,
                      fontSize: 10.0,
                      color: customColors.primary,
                      margin: EdgeInsets.only(right: 23.0),
                      padding: EdgeInsets.all(5.0),
                      underlined: true,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.0),

            /// Feeling Details 3
            if (_userHabitDetailsFeelingList != null && _userHabitDetailsFeelingList!.isNotEmpty)
              for (int i = 0; i < _userHabitDetailsFeelingList!.length; i++) _noteItem(_userHabitDetailsFeelingList![i]),

            SizedBox(height: 20.0),

            /// Delete Btn
            Align(
              alignment: Alignment.topRight,
              child: DeleteButtonWidget(
                onDelete: () {
                  BlocManager.userHabitBloc.add(DeleteUserHabitEvent(widget.userHabitId!));
                },
              ),
            ),
          ],
        ),
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
        return LocaleKeys.pleaseSelectEmoji;
    }
  }

  _getColor(int index) {
    switch (index) {
      case 1:
        return "FA6C51";
      case 2:
        return "FDCD56";
      case 3:
        return "73B0F4";
      case 4:
        return "61DDBC";
      case 5:
        return "2AB08C";
      default:
        return "2AB08C";
    }
  }

  Widget _noteItem(feelingDetails) {
    return Container(
      height: 64.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        color: customColors.greyBackground,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: [
          /// Date
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                Func.toRomboMonth(Func.getMonthFromDateStr(feelingDetails!.date!)),
                color: customColors.greyText,
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
              ),
              CustomText(
                Func.getDayFromDateStr(feelingDetails!.date!),
                color: customColors.greyText,
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
              ),
            ],
          ),

          SizedBox(width: 13.0),

          /// Vertical Line
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: VerticalDivider(
              width: 1,
              color: customColors.greyText,
            ),
          ),

          Expanded(
            child: Column(children: [
              SizedBox(height: 7.0),

              Row(
                children: [
                  /// Feeling emoji
                  Container(
                    height: 20,
                    width: 20,
                    padding: EdgeInsets.all(2.0),
                    margin: EdgeInsets.only(left: 11.5),
                    decoration: BoxDecoration(
                      color: customColors.whiteBackground,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: SvgPicture.asset(_getAsset(feelingDetails!.value!)),
                  ),

                  SizedBox(width: 6.0),

                  /// Feeling name
                  Expanded(
                    child: CustomText(
                      _getText(feelingDetails!.value!),
                      fontWeight: FontWeight.w500,
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),

              /// Note
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 14.5, bottom: 10.0),
                  child: CustomText(
                    feelingDetails!.note,
                    fontSize: 11.0,
                    maxLines: 2,
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget _feelingInfo() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
        color: customColors.whiteBackground, //whiteBackground
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              /// Chart
              _feelingPieChart(),

              Center(
                child: Column(
                  children: [
                    /// Нийт
                    CustomText(
                      LocaleKeys.total,
                      alignment: Alignment.center,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      color: customColors.primary,
                    ),

                    /// Total Count
                    CustomText(
                      Func.toStr(_totalCount),
                      alignment: Alignment.center,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(width: 15),

          // Feelings
          Expanded(
            child: Column(
              children: [for (var el in _feelings!) _feelingItem(el)],
            ),
          )
        ],
      ),
    );
  }

  Widget _feelingPieChart() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.25,
      width: MediaQuery.of(context).size.width * 0.25,
      child: Container(
        child: PieChart(
          PieChartData(
            sections: [
              for (var el in _feelings!) _pieChartData(el),
            ],
          ),
        ),
      ),
    );
  }

  PieChartSectionData _pieChartData(UserHabitFeelingPieChartFeeling _habitFeelingPieChartFeeling) {
    double _percentage = Func.toDouble(_habitFeelingPieChartFeeling.count) * 100 / Func.toDouble(_totalCount);
    return PieChartSectionData(
      radius: 12,
      color: HexColor.fromHex(_getColor(_habitFeelingPieChartFeeling.index!)),
      value: Func.toDouble(_percentage),
      showTitle: false,
    );
  }

  Widget _feelingItem(UserHabitFeelingPieChartFeeling feeling) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          /// Image
          SvgPicture.asset(
            _getAsset(feeling.count!),
            height: 14,
            width: 14,
            color: HexColor.fromHex(_getColor(feeling.index!)),
          ),

          SizedBox(width: 9.0),

          /// Feeling
          Expanded(
            child: CustomText(
              feeling.name,
              fontSize: 10,
            ),
          ),

          SizedBox(width: 9.0),

          /// Count
          CustomText(
            '${feeling.count}',
            fontSize: 10,
          ),
        ],
      ),
    );
  }

  _navigateToFeelingNotesRoute() {
    Navigator.pushNamed(context, Routes.feelingNotes, arguments: {
      'userHabitId': widget.userHabitId,
    });
  }
}
