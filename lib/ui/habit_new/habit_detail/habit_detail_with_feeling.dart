import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit_feeling_pie_chart_feeling.dart';
import 'package:habido_app/models/user_habit_plan_count.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitDetailWithFeelingRoute extends StatefulWidget {
  final int? userHabitId;
  final String? name;
  const HabitDetailWithFeelingRoute({
    Key? key,
    this.userHabitId,
    this.name,
  }) : super(key: key);

  @override
  State<HabitDetailWithFeelingRoute> createState() => _HabitDetailWithCountRouteState();
}

class _HabitDetailWithCountRouteState extends State<HabitDetailWithFeelingRoute> {
  UserHabitPlanCount? _userHabitPlanCount;

  // Total count
  int? _totalCount;

  // Graph
  List<UserHabitFeelingPieChartFeeling>? _feelings;

  @override
  void initState() {
    super.initState();
    BlocManager.userHabitBloc.add(GetUserHabitPlanCountEvent(widget.userHabitId!));
    BlocManager.userHabitBloc.add(GetHabitFeelingChartDataEvent(widget.userHabitId!));
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
    }
  }

  Widget _blocBuilder(BuildContext context, UserHabitState state) {
    return CustomScaffold(
      appBarTitle: '${widget.name} - Feeling',
      child: Container(
        padding: SizeHelper.screenPadding,
        child: (_userHabitPlanCount != null && _feelings != null && _totalCount != null)
            ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(height: 18.0),
                CustomText(
                  LocaleKeys.execution,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                ),
                SizedBox(height: 15.0),
                _performance(),
                SizedBox(height: 15.0),
                _feelingInfo(),
              ])
            : Container(),
      ),
    );
  }

  _getAsset(String feelingName) {
    switch (feelingName) {
      case "Маш их баяртай байна":
        return Assets.happy_emoji;
      case "Тайван сайхан байна":
        return Assets.calm_emoji;
      case "Юу мэдэрч байгаагаа мэдэхгүй":
        return Assets.unknown_emoji;
      case "Тааламжгүй байна":
        return Assets.unpleasant_emoji;
      case "Гунигтай байна":
        return Assets.sad_emoji;
      default:
    }
  }

  _getColor(String feelingName) {
    switch (feelingName) {
      case "Маш их баяртай байна":
        return "2AB08C";
      case "Тайван сайхан байна":
        return "61DDBC";
      case "Юу мэдэрч байгаагаа мэдэхгүй":
        return "73B0F4";
      case "Тааламжгүй байна":
        return "FDCD56";
      case "Гунигтай байна":
        return "FA6C51";
      default:
    }
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
      color: HexColor.fromHex(_getColor(_habitFeelingPieChartFeeling.name!)),
      value: Func.toDouble(_percentage),
      title: '',
      titleStyle: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _feelingItem(feeling) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          /// Image
          SvgPicture.asset(
            _getAsset(feeling.name!),
            height: 14,
            width: 14,
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

  Widget _performance() {
    return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: 1,
                width: double.infinity,
                color: customColors.greyBackground,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 24),
                height: double.infinity,
                width: 1,
                color: customColors.greyBackground,
              ),
            ),

            /// gridview
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: GridView.count(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                childAspectRatio: 2,
                crossAxisCount: 2,
                children: [
                  _performanceItem(
                    image: Assets.calendar,
                    title: "${_userHabitPlanCount!.totalPlans}",
                    text: LocaleKeys.totalPlans,
                  ),
                  _performanceItem(
                    image: Assets.star_empty,
                    color: customColors.iconFeijoGreen,
                    title: "${_userHabitPlanCount!.completedPlans}",
                    text: LocaleKeys.completedPlans,
                  ),
                  _performanceItem(
                    image: Assets.star_half,
                    // color: customColors.iconFeijoGreen,
                    title: "${_userHabitPlanCount!.skipPlans}",
                    text: LocaleKeys.skipPlans,
                  ),
                  _performanceItem(
                    image: Assets.clear_circle,
                    title: "${_userHabitPlanCount!.uncompletedPlans}",
                    text: LocaleKeys.uncompletedPlans,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _performanceItem({required String image, required String title, required String text, Color? color}) {
    return Container(
      padding: EdgeInsets.only(left: 34.0, top: 12.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            image,
            height: 18,
            fit: BoxFit.contain,
            color: color,
          ),
          SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                title,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(width: 1),
              CustomText(
                LocaleKeys.day,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                margin: EdgeInsets.only(bottom: 1.2),
              ),
            ],
          ),
          CustomText(
            text,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
