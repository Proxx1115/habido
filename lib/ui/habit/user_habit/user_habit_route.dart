import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/dashboard_bloc.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/plan.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_reminders.dart';
import 'package:habido_app/ui/habit/user_habit/plan_terms/plan_term_helper.dart';
import 'package:habido_app/ui/habit/user_habit/plan_terms/plan_terms_widget.dart';
import 'package:habido_app/ui/habit/user_habit/reminder/reminder_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/date_picker.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/slider/custom_slider.dart';
import 'package:habido_app/widgets/slider/slider_bloc.dart';
import 'package:habido_app/widgets/switch.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'reminder/reminder_widget.dart';

class UserHabitRoute extends StatefulWidget {
  final String? title;
  final Habit? habit; // UserHabit, habit 2-ын нэг нь заавал утгатай байх ёстой
  final UserHabit? userHabit;

  const UserHabitRoute({
    Key? key,
    this.title,
    this.habit,
    this.userHabit,
  }) : super(key: key);

  @override
  _UserHabitRouteState createState() => _UserHabitRouteState();
}

class _UserHabitRouteState extends State<UserHabitRoute> {
  // UI
  late Color _primaryColor;
  late Color _backgroundColor;

  // Data
  late Habit _habit;

  // Name
  final _nameController = TextEditingController();

  // Plan
  String _selectedPlanTerm = PlanTerm.Daily;
  List<Plan> _planList = [];

  // Goal
  bool _visibleGoal = false;

  // bool _goalSwitchValue = false;
  SliderBloc? _sliderBloc;
  String? _sliderTitle;
  String? _sliderQuantity;

  // Start, end date
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Reminder
  final _reminderBloc = ReminderBloc();

  // Tip
  String? _tip;

  // Delete button
  bool _visibleDeleteButton = false;

  @override
  void initState() {
    if (widget.userHabit?.habit != null || widget.habit != null) {
      // Habit
      if (widget.userHabit?.habit != null) {
        _habit = widget.userHabit!.habit!;
      } else if (widget.habit != null) {
        _habit = widget.habit!;
      }

      // Color
      _primaryColor = Func.isNotEmpty(_habit.color) ? HexColor.fromHex(_habit.color!) : customColors.primary;
      _backgroundColor = Func.isNotEmpty(_habit.backgroundColor)
          ? HexColor.fromHex(_habit.backgroundColor!)
          : customColors.primaryBackground;

      // Name
      _nameController.text = _habit.name ?? '';

      // Plan term
      if (widget.userHabit != null) {
        _selectedPlanTerm = widget.userHabit!.planTerm ?? PlanTerm.Daily;
        _planList = widget.userHabit!.planDays ?? [];
      }

      // Goal
      _initGoal();

      // Tip
      _tip = _habit.note;

      // Button delete
      _visibleDeleteButton = (widget.userHabit != null);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: widget.title != null ? widget.title : LocaleKeys.habit,
      child: (widget.userHabit != null || widget.habit != null)
          ? SingleChildScrollView(
              padding: SizeHelper.paddingScreen,
              child: BlocProvider.value(
                value: BlocManager.userHabitBloc,
                child: BlocListener<UserHabitBloc, UserHabitState>(
                  listener: _blocListener,
                  child: BlocBuilder<UserHabitBloc, UserHabitState>(builder: (context, state) {
                    return Column(
                      children: [
                        /// Нэр
                        _nameTextField(),

                        /// Plan terms
                        _planTermsWidget(),

                        /// Зорилго
                        _goalWidget(),

                        /// Эхлэх огноо
                        _startDatePicker(),

                        /// Дуусах огноо
                        _endDatePicker(),

                        /// Сануулах
                        _reminder(),

                        /// Зөвлөмж
                        _tipWidget(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Button delete
                            _buttonDelete(),

                            /// Button save
                            Expanded(
                              child: _buttonSave(),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            )
          : Container(),
    );
  }

  void _blocListener(BuildContext context, UserHabitState state) {
    if (state is GoalSwitchChangedState) {
      // _goalSwitchValue = state.value;
    } else if (state is InsertUserHabitSuccess) {
      showCustomDialog(
        context,
        isDismissible: false,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.success,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            BlocManager.dashboardBloc.add(RefreshDashboardUserHabits());
            Navigator.popUntil(context, ModalRoute.withName(Routes.home));
          },
        ),
      );
    } else if (state is InsertUserHabitFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    }
  }

  void _initGoal() {
    // Goal
    String? goalValue;

    if (_habit.goalSettings != null && _habit.goalSettings!.toolType != null) {
      // Slider
      if (_habit.goalSettings!.goalRequired ?? false) {
        _visibleGoal = true;

        _sliderBloc = SliderBloc(
          minValue: Func.toDouble(_habit.goalSettings!.goalMin),
          maxValue: Func.toDouble(_habit.goalSettings!.goalMax),
          value: (Func.toDouble(_habit.goalSettings!.goalMax) - Func.toDouble(_habit.goalSettings!.goalMin)) / 2,
          step: Func.toDouble(_habit.goalSettings!.goalStep),
        );

        _sliderTitle = _habit.goalSettings!.goalName;
        _sliderQuantity = _habit.goalSettings!.toolUnit;
      }
    }
  }

  Widget _nameTextField() {
    return CustomTextField(
      controller: _nameController,
      maxLength: 30,
    );
  }

  Widget _planTermsWidget() {
    return PlanTermsWidget(
      primaryColor: _primaryColor,
      planTerm: _selectedPlanTerm,
      onPlanTermChanged: (term) {
        _selectedPlanTerm = term;
      },
      planList: _planList,
      onPlanListChanged: (list) {
        _planList = list;
      },
    );
  }

  Widget _goalWidget() {
    return _visibleGoal
        ? StadiumContainer(
            margin: EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                /// Switch
                // CustomSwitch(
                //   margin: EdgeInsets.fromLTRB(15.0, 0.0, 5.0, 0.0),
                //   leadingAsset: Assets.trophy,
                //   leadingAssetColor: _primaryColor,
                //   activeText: LocaleKeys.goal,
                //   activeColor: _primaryColor,
                //   onChanged: (value) {
                //     BlocManager.userHabitBloc.add(GoalSwitchChangedEvent(value));
                //   },
                // ),

                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(Assets.trophy, color: _primaryColor),
                      SizedBox(width: 15.0),
                      Expanded(
                        child: CustomText(
                          LocaleKeys.goal,
                        ),
                      ),
                    ],
                  ),
                ),

                // if (_goalSwitchValue)
                HorizontalLine(margin: EdgeInsets.symmetric(horizontal: 15.0)),

                /// Slider
                if ( //_goalSwitchValue &&
                _sliderBloc != null)
                  CustomSlider(
                    sliderBloc: _sliderBloc!,
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    primaryColor: _primaryColor,
                    title: _sliderTitle,
                    quantityText: _sliderQuantity,
                    visibleButtons: true,
                  ),
              ],
            ),
          )
        : Container();
  }

  Widget _startDatePicker() {
    return CustomDatePicker(
      hintText: LocaleKeys.startDate,
      margin: EdgeInsets.only(top: 15.0),
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      onSelectedDate: (date) {
        print(date);
        _selectedStartDate = date;
      },
    );
  }

  Widget _endDatePicker() {
    return CustomDatePicker(
      hintText: LocaleKeys.endDate,
      margin: EdgeInsets.only(top: 15.0),
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      onSelectedDate: (date) {
        print(date);
        _selectedEndDate = date;
      },
    );
  }

  Widget _reminder() {
    return ReminderWidget(
      reminderBloc: _reminderBloc,
      margin: EdgeInsets.only(top: 15.0),
      primaryColor: _primaryColor,
    );
  }

  Widget _tipWidget() {
    return (_tip != null)
        ? InfoContainer(
            margin: EdgeInsets.only(top: 15.0),
            title: LocaleKeys.tip,
            body: _tip!,
          )
        : Container();
  }

  Widget _buttonDelete() {
    return !_visibleDeleteButton
        ? ButtonStadium(
            style: ButtonStadiumStyle.Primary,
            asset: Assets.trash,
            iconColor: customColors.iconRed,
            margin: EdgeInsets.only(top: 15.0),
            onPressed: () {
              // todo test
            },
          )
        : Container();
  }

  Widget _buttonSave() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      text: LocaleKeys.save,
      margin: EdgeInsets.only(top: 15.0),
      backgroundColor: _primaryColor,
      onPressed: _onPressedButtonSave,
    );
  }

  _onPressedButtonSave() {
    var userHabit = UserHabit();
    // if (widget.userHabit != null) {
    //   // Update
    //   userHabit.userHabitId = widget.userHabit!.userHabitId;
    // }

    userHabit.userHabitId = widget.userHabit?.userHabitId ?? 0;

    // Habit settings
    userHabit.habitId = _habit.habitId;
    // userHabit.habit =

    // Name
    userHabit.name = _nameController.text;

    // Plan days
    if (_planList.isNotEmpty) {
      userHabit.planDays = [];
      for (var el in _planList) {
        if (el.isSelected ?? false) userHabit.planDays!.add(el);
      }
    }

    // HabitGoalSettings
    userHabit.planTerm = _selectedPlanTerm;
    if (_sliderBloc != null) {
      userHabit.goalValue = Func.toStr(_sliderBloc!.value);
    }

    // Start, end date
    userHabit.startDate = Func.dateTimeToDateStr(_selectedStartDate);
    userHabit.endDate = Func.dateTimeToDateStr(_selectedEndDate);

    // Reminder
    if (_reminderBloc.switchValue && _reminderBloc.timeOfDayList.isNotEmpty) {
      userHabit.userHabitReminders = [];
      for (var el in _reminderBloc.timeOfDayList) {
        userHabit.userHabitReminders!.add(UserHabitReminders()..time = el.hour * 60 + el.minute);
      }
    }

    // Note
    userHabit.userNote = '';

    BlocManager.userHabitBloc.add(InsertUserHabitEvent(userHabit));

    // List<Plan>? plans;

    // var request = UserHabit()
    //   // ..userHabitId = 0
    //   // ..userId = 1
    //   ..habitId = widget.habit.habitId
    //   ..name = 'Явган алхах'
    //   ..startDate = '' //everyday
    //   ..endDate = '' //everyday
    //   ..isReminder = true
    //   ..repeatName = PlanTerm.Daily //'Daily' //'Weekly', 'Monthly'
    //   ..hasGoal = false
    //   ..goalValue = ''
    //   ..note = ''
    //   ..userNote = ''
    //   ..status = ''
    //   ..userHabitReminders = [
    //     UserHabitReminders()
    //       // ..reminderId;
    //       // ..userHabitId;
    //       ..time = 1 // minutaar
    //   ]
    //   ..plans = [
    // monthly
    // Plans()
    //   ..planDate = '2021-08-27'
    //   ..term = PlanTerm.Monthly,
    // Plans()
    //   ..weekDay = '2021-08-27'
    //   ..term = PlanTerm.Monthly,
    //
    // // weekly
    // Plans()
    //   ..weekDay = WeekDays.Mon
    //   ..term = PlanTerm.Weekly,
    // Plans()
    //   ..weekDay = WeekDays.Fri
    //   ..term = PlanTerm.Week,

    //everyday null
    // ];
  }
}
