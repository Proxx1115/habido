import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/models/user_habit_details_feeling.dart';
import 'package:habido_app/models/user_habit_details_satisfaction.dart';
import 'package:habido_app/models/user_habit_plan_count.dart';
import 'package:habido_app/ui/habit_new/habit_detail/delete_button_widget.dart';
import 'package:habido_app/ui/habit_new/habit_detail/no_habit_graph_widget.dart';
import 'package:habido_app/ui/habit_new/habit_detail/performance_widget.dart';
import 'package:habido_app/ui/habit_new/habit_helper.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitDetailWithSatisfactionRoute extends StatefulWidget {
  final int? userHabitId;
  final String? name;
  final bool? isActive;

  const HabitDetailWithSatisfactionRoute({
    Key? key,
    this.userHabitId,
    this.name,
    this.isActive = false,
  }) : super(key: key);

  @override
  State<HabitDetailWithSatisfactionRoute> createState() => _HabitDetailWithSatisfactionRouteState();
}

class _HabitDetailWithSatisfactionRouteState extends State<HabitDetailWithSatisfactionRoute> {
  UserHabitPlanCount? _userHabitPlanCount;

  // Graph
  List<UserHabitDetailsSatisfaction>? _userHabitDetailsSatisfactionList;

  // Feeling Details Latest List
  List<UserHabitDetailsFeeling>? _userHabitDetailsFeelingList;

  @override
  void initState() {
    super.initState();
    BlocManager.userHabitBloc.add(GetUserHabitPlanCountEvent(widget.userHabitId!));
    BlocManager.userHabitBloc.add(GetUserHabitDetailsSatisfactionEvent(widget.userHabitId!));
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
    } else if (state is GetFeelingDetailsSatisfactionSuccess) {
      _userHabitDetailsSatisfactionList = state.userHabitDetailsSatisfactionList;
    } else if (state is GetFeelingDetailsSatisfactionFailed) {
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
    } else if (state is DeleteUserHabitSuccess) {
      showCustomDialog(
        context,
        isDismissible: false,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.success,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.popUntil(context, ModalRoute.withName(Routes.home_new));
          },
        ),
      );
    } else if (state is DeleteUserHabitFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
        ),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, UserHabitState state) {
    return CustomScaffold(
      appBarTitle: widget.name,
      child: SingleChildScrollView(
        padding: SizeHelper.screenPadding,
        child: (_userHabitPlanCount != null)
            ? Column(
                children: [
                  SizedBox(height: 18.0),
                  CustomText(
                    LocaleKeys.execution,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                  ),
                  SizedBox(height: 15.0),
                  PerformanceWidget(
                    totalPlans: _userHabitPlanCount!.totalPlans,
                    completedPlans: _userHabitPlanCount!.completedPlans,
                    skipPlans: _userHabitPlanCount!.skipPlans,
                    uncompletedPlans: _userHabitPlanCount!.uncompletedPlans,
                  ),
                  SizedBox(height: 15.0),
                  _satisfactionHistoryGraph(),
                  SizedBox(height: 15.0),

                  if (_userHabitDetailsFeelingList != null && _userHabitDetailsFeelingList!.isNotEmpty)
                    Column(
                      children: [
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
                                  _navigateToSatisfactionNotesRoute();
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

                        /// Satisfaction Details Latest List

                        for (int i = 0; i < _userHabitDetailsFeelingList!.length; i++) _noteItem(_userHabitDetailsFeelingList![i]),
                        SizedBox(height: 20.0),
                      ],
                    ),

                  /// Delete Btn
                  // if (widget.isActive!)
                  //   Align(
                  //     alignment: Alignment.topRight,
                  //     child: DeleteButtonWidget(
                  //       onDelete: () {
                  //         BlocManager.userHabitBloc.add(DeleteUserHabitEvent(widget.userHabitId!));
                  //       },
                  //     ),
                  //   ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _satisfactionHistoryGraph() {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        NoHabitGraph(),
      ],
    );
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

          SizedBox(width: 14.5),

          Expanded(
            child: Column(children: [
              SizedBox(height: 7.0),

              Row(
                children: [
                  CustomText(
                    '${feelingDetails!.value}/10 ',
                    fontWeight: FontWeight.w500,
                    fontSize: 11.0,
                  ),

                  /// Feeling name
                  CustomText(
                    UserHabitHelper.isPleasing(feelingDetails!.value),
                    fontWeight: FontWeight.w500,
                    fontSize: 11.0,
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

  _navigateToSatisfactionNotesRoute() {
    Navigator.pushNamed(context, Routes.satisfactionNotes, arguments: {
      'userHabitId': widget.userHabitId,
    });
  }
}
