import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/custom_habit_settings_response.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/habit_goal_settings.dart';
import 'package:habido_app/models/habit_template.dart';
import 'package:habido_app/models/plan.dart';
import 'package:habido_app/ui/content/content_card.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit/user_habit/custom_icon_picker.dart';
import 'package:habido_app/ui/habit/user_habit/reminder/reminder_widget_v2.dart';
import 'package:habido_app/ui/habit_new/habit_detail/delete_button_widget.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/screen_mode.dart';
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
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/combobox/combo_helper.dart';
import 'package:habido_app/widgets/combobox/combobox.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/date_picker/date_picker_bloc.dart';
import 'package:habido_app/widgets/date_picker/date_picker_v2.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/slider/custom_slider.dart';
import 'package:habido_app/widgets/slider/slider_bloc.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:showcaseview/showcaseview.dart';

class UserHabitScreenV2 extends StatefulWidget {
  final int habitId;
  final String screenMode;
  final UserHabit? userHabit;
  final Habit? habit;
  final HabitTemplate? habitTemplate;
  final CustomHabitSettingsResponse? customHabitSettings;
  final String? title;

  const UserHabitScreenV2({
    Key? key,
    required this.habitId,
    required this.screenMode,
    this.userHabit,
    this.habit,
    this.customHabitSettings,
    this.title,
    this.habitTemplate,
  }) : super(key: key);

  @override
  _UserHabitScreenV2State createState() => _UserHabitScreenV2State();
}

class _UserHabitScreenV2State extends State<UserHabitScreenV2> {
  // Main
  late String _screenMode;
  Habit? _habit;
  UserHabit? _userHabit;
  HabitTemplate? _habitTemplate;

  // Name
  final _nameController = TextEditingController();

  // Color
  List<CustomHabitColor>? _colorList;
  String? _primaryColorCode;
  String? _backgroundColorCode;

  // Icon
  List<CustomHabitIcon>? _iconList;
  CustomHabitIcon? _icon;

  // Plan
  late List<Plan> _planList;
  late String _planTerm;

  // Goal
  List<HabitGoalSettings>? _goalSettingsList;
  HabitGoalSettings? _goalSettings;
  bool _visibleGoal = false;
  bool _visibleGoalMeasure = false;
  SliderBloc? _goalSliderBloc;

  // Start, end date
  DateTime? _startDate;
  final _startDatePickerBloc = DatePickerBloc();
  DateTime? _endDate;
  final _endDatePickerBloc = DatePickerBloc();

  // Reminder
  final _reminderBloc = ReminderBloc();

  // Tip
  String? _tip;

  // Button
  bool _firstPress = true;

  @override
  void initState() {
    if (widget.habitId > 0 && widget.habit == null) {
      BlocManager.userHabitBloc.add(GetHabitEvent(widget.habitId));
    } else {
      _initScreen(habit: widget.habit!);
    }

    // /// Showcase

    super.initState();
  }

  _initScreen({Habit? habit}) {
    /// Screen mode
    _screenMode = widget.screenMode;

    if (habit != null) _habit = habit;

    /// User habit
    _userHabit = widget.userHabit;

    /// Habit Template
    _habitTemplate = widget.habitTemplate;

    /// Name
    _nameController.text = _habit!.name ?? '';

    /// Color
    _colorList = widget.customHabitSettings?.colorList;
    switch (_screenMode) {
      case ScreenMode.New:
      case ScreenMode.HabitTemplate:
      case ScreenMode.Edit:
        // _primaryColorCode = _habit!.color;
        // _backgroundColorCode = _habit!.backgroundColor;
        break;
      case ScreenMode.CustomNew:
        _primaryColorCode = _colorList?.first.primaryColor;
        _backgroundColorCode = _colorList?.first.backgroundColor;
        break;
      case ScreenMode.CustomEdit:
        // _primaryColorCode = _habit!.color;
        // _backgroundColorCode = _habit!.backgroundColor;
        break;
    }

    // Icon
    _iconList = widget.customHabitSettings?.iconList;
    switch (_screenMode) {
      case ScreenMode.New:
      case ScreenMode.Edit:
      case ScreenMode.HabitTemplate:
        break;
      case ScreenMode.CustomNew:
        if (Func.isNotEmpty(_iconList?.first.link)) {
          _icon = CustomHabitIcon()..link = _iconList?.first.link;
        }
        break;
      case ScreenMode.CustomEdit:
        if (Func.isNotEmpty(_habit!.photo)) {
          _icon = CustomHabitIcon()..link = _habit!.photo;
        }
        break;
    }

    /// Plan term
    switch (_screenMode) {
      case ScreenMode.Edit:
        _planTerm = _userHabit!.planTerm ?? PlanTerm.getInitialPlanTerm(_habit!.planTerms);
        _planList = _userHabit!.planDays ?? [];
        break;
      case ScreenMode.CustomEdit:
        _planTerm = _userHabit!.planTerm ?? PlanTerm.Daily;
        _planList = _userHabit!.planDays ?? [];
        break;
      case ScreenMode.New:
        _planTerm = PlanTerm.getInitialPlanTerm(_habit!.planTerms);
        _planList = [];
        break;
      case ScreenMode.HabitTemplate:
        _planTerm = _habitTemplate!.planTerm ?? PlanTerm.getInitialPlanTerm(_habit!.planTerms);
        _planList = _habitTemplate!.planDays ?? [];
        print("palan list $_planList");
        break;
      case ScreenMode.CustomNew:
      default:
        _planTerm = PlanTerm.Daily;
        _planList = [];
        break;
    }

    /// Goal
    _goalSettingsList = widget.customHabitSettings?.goalSettingsList;

    switch (_screenMode) {
      case ScreenMode.New:
      case ScreenMode.HabitTemplate:
        _goalSettings = _habit!.goalSettings;
        _visibleGoalMeasure = true;
        break;
      case ScreenMode.Edit:
        _goalSettings = _userHabit?.habit?.goalSettings;
        break;
      case ScreenMode.CustomNew:
        _goalSettings = _goalSettingsList?.first;
        _visibleGoalMeasure = true;
        break;
      case ScreenMode.CustomEdit:
        _goalSettings = _userHabit?.habit?.goalSettings;
        _visibleGoalMeasure = true;
        break;
    }

    // Slider
    if (_goalSettings != null && (_goalSettings!.goalRequired ?? false)) {
      // Value
      late double value;
      switch (_screenMode) {
        case ScreenMode.Edit:
        case ScreenMode.CustomEdit:
          value = Func.toDouble(_userHabit!.goalValue);
          break;
        case ScreenMode.HabitTemplate:
          value = Func.toDouble(_habitTemplate!.goalValue);
          break;
        case ScreenMode.New:
        case ScreenMode.CustomNew:
        default:
          value = Func.toDouble(_goalSettings!.goalMax) / 2;
          break;
      }

      _goalSliderBloc = SliderBloc(
        minValue: Func.toDouble(_goalSettings!.goalMin),
        maxValue: Func.toDouble(_goalSettings!.goalMax),
        value: value,
        step: Func.toDouble(_goalSettings!.goalStep),
      );
    }

    /// Start date, end date
    switch (_screenMode) {
      case ScreenMode.Edit:
      case ScreenMode.CustomEdit:
        _startDate = Func.toDate(_userHabit!.startDate ?? '');
        _endDate = Func.toDate(_userHabit!.endDate ?? '');
        break;
      case ScreenMode.HabitTemplate:
        _startDate = DateTime.now();
        print('durationst ${_habitTemplate!.duration}');
        _endDate = DateTime.now().add(new Duration(days: _habitTemplate!.duration ?? 0));
        break;
      case ScreenMode.New:
      case ScreenMode.CustomNew:
      default:
        break;
    }

    /// Reminder
    switch (_screenMode) {
      case ScreenMode.Edit:
      case ScreenMode.CustomEdit:
        if (_userHabit!.userHabitReminders != null && _userHabit!.userHabitReminders!.isNotEmpty) {
          _reminderBloc.switchValue = true;
          _reminderBloc.timeOfDayList = [];
          for (var el in _userHabit!.userHabitReminders!) {
            _reminderBloc.timeOfDayList.add(TimeOfDay(
              hour: Func.toInt(el.time) ~/ 60,
              minute: Func.toInt(el.time) % 60,
            ));
          }
        }
        break;
      case ScreenMode.HabitTemplate:
        if (_habitTemplate!.templateReminders != null && _habitTemplate!.templateReminders!.isNotEmpty) {
          _reminderBloc.switchValue = true;
          _reminderBloc.timeOfDayList = [];
          for (var el in _habitTemplate!.templateReminders!) {
            _reminderBloc.timeOfDayList.add(TimeOfDay(
              hour: Func.toInt(el.time) ~/ 60,
              minute: Func.toInt(el.time) % 60,
            ));
          }
        }
        break;
      case ScreenMode.New:
      case ScreenMode.CustomNew:
      default:
        break;
    }

    /// Tip
    _tip = _habit!.tip;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: widget.title != null ? widget.title : LocaleKeys.showcaseAddHabit,
      backgroundColor: HabitHelper.getBackgroundColor(_backgroundColorCode),
      child: BlocProvider.value(
        value: BlocManager.userHabitBloc,
        child: BlocListener<UserHabitBloc, UserHabitState>(
          listener: _blocListener,
          child: BlocBuilder<UserHabitBloc, UserHabitState>(builder: (context, state) {
            return _habit != null
                ? Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Column(
                                  children: [
                                    /// Нэр
                                    _nameTextField(),

                                    /// Зөвлөмж
                                    _tipWidget(),

                                    /// Дүрс сонгох
                                    _iconPicker(),

                                    /// Plan terms
                                    _planTermsWidget(),

                                    /// Зорилго
                                    _goalWidget(),

                                    SizedBox(height: 15.0),

                                    Container(
                                      width: double.infinity,
                                      height: 50.0,
                                      child: Row(
                                        children: [
                                          /// Эхлэх огноо
                                          Expanded(child: _startDatePicker()),

                                          SizedBox(
                                            width: 15,
                                          ),

                                          /// Дуусах огноо
                                          Expanded(child: _endDatePicker()),
                                        ],
                                      ),
                                    ),

                                    _reminder(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// Buttons
                      Container(
                        margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, SizeHelper.marginBottom),
                        child: Row(
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
                      ),
                    ],
                  )
                : Container();
          }),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserHabitState state) {
    if (state is InsertUserHabitSuccess) {
      showCustomDialog(
        context,
        isDismissible: false,
        child: CustomDialogBody(
          asset: Assets.success,
          text: Func.isNotEmpty(state.userHabitResponse.message) ? state.userHabitResponse.message : LocaleKeys.success,
          buttonText: LocaleKeys.thanksHabiDo,
          primaryColor: ConstantColors.createHabitColor,
          child: state.userHabitResponse.content != null
              ? Column(
                  children: [
                    ContentCardOnHabitCreation(
                      margin: EdgeInsets.only(bottom: 30.0),
                      content: state.userHabitResponse.content!,
                      callback: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(Routes.home_new, ModalRoute.withName('/'), arguments: {'initialIndex': 0});
                      },
                    ),
                  ],
                )
              : null,
          onPressedButton: () {
            Navigator.of(context).pushNamedAndRemoveUntil(Routes.home_new, (Route<dynamic> route) => false, arguments: {'initialIndex': 0});
          },
        ),
      );
    } else if (state is UpdateUserHabitSuccess || state is DeleteUserHabitSuccess) {
      showCustomDialog(
        context,
        isDismissible: false,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.success,
          buttonText: LocaleKeys.ok,
          primaryColor: ConstantColors.createHabitColor,
          onPressedButton: () {
            Navigator.popUntil(context, ModalRoute.withName(Routes.home_new));
          },
        ),
      );
    } else if (state is InsertUserHabitFailed || state is UpdateUserHabitFailed || state is DeleteUserHabitFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: LocaleKeys.failed,
          buttonText: LocaleKeys.ok,
          primaryColor: ConstantColors.createHabitColor,
        ),
      );
    } else if (state is UserHabitShowcaseState) {
      ShowCaseWidget.of(context)?.startShowCase(state.showcaseKeyList);
    } else if (state is GetHabitSuccess) {
      _habit = state.habit;
      print("statiin habit ${_habit!.color}");
      _initScreen(habit: state.habit);
    }
  }

  Widget _iconPicker() {
    switch (_screenMode) {
      case ScreenMode.CustomNew:
      case ScreenMode.CustomEdit:
        return CustomIconPicker(
          iconList: _iconList ?? [],
          selectedIcon: _icon,
          margin: EdgeInsets.only(top: 15.0),
          primaryColor: HabitHelper.getPrimaryColor(_primaryColorCode),
          onIconSelected: (value) {
            setState(() {
              _icon = value;
            });
          },
        );
      case ScreenMode.New:
      case ScreenMode.Edit:
      default:
        return Container();
    }
  }

  Widget _reminder() {
    return ReminderWidgetV2(
      reminderBloc: _reminderBloc,
      margin: EdgeInsets.only(top: 15.0),
      primaryColor: ConstantColors.createHabitColor,
    );
  }

  Widget _nameTextField() {
    return CustomTextField(
      controller: _nameController,
      hintText: LocaleKeys.habitName,
      maxLength: 30,
      suffixAsset: Assets.editTextField,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5), topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
      margin: EdgeInsets.only(top: 15.0),
    );
  }

  Widget _planTermsWidget() {
    return PlanTermsWidget(
      primaryColor: ConstantColors.athensGrey,
      habitPlanTerms: _habit!.planTerms,
      initialPlanTerm: _planTerm,
      onPlanTermChanged: (term) {
        _planTerm = term;
      },
      planList: _planList,
      onPlanListChanged: (list) {
        _planList = list;
      },
    );
  }

  Widget _startDatePicker() {
    return CustomDatePickerV2(
      bloc: _startDatePickerBloc,
      hintText: LocaleKeys.startDate,
      margin: EdgeInsets.only(left: 18.0),
      firstDate: DateTime.now(),
      initialDate: _startDate,
      primaryColor: ConstantColors.createHabitColor,
      callback: (date) {
        _startDate = date;

        if (_startDate != null && Func.isBeforeDate(_endDate, _startDate)) {
          _endDatePickerBloc.add(DatePickedEvent(date!));
        }
      },
    );
  }

  Widget _endDatePicker() {
    return CustomDatePickerV2(
      bloc: _endDatePickerBloc,
      hintText: LocaleKeys.endDate,
      margin: EdgeInsets.only(left: 18.0),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2, 12, 31),
      initialDate: _endDate,
      primaryColor: ConstantColors.createHabitColor,
      callback: (date) {
        _endDate = date;

        if (_endDate != null && Func.isBeforeDate(_endDate, _startDate)) {
          _startDatePickerBloc.add(DatePickedEvent(_endDate!));
        }
      },
    );
  }

  Widget _tipWidget() {
    return (Func.isNotEmpty(_tip))
        ? InfoContainerNoTitle(
            margin: EdgeInsets.only(top: 15.0),
            body: _tip!,
          )
        : Container();
  }

  Widget _buttonSave() {
    return CustomButton(
      style: (_screenMode == ScreenMode.CustomEdit || _screenMode == ScreenMode.Edit) ? CustomButtonStyle.secondary : CustomButtonStyle.primary,
      text: LocaleKeys.save,
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
      backgroundColor: ConstantColors.createHabitColor,
      onPressed: _onPressedButtonSave,
    );
  }

  _onPressedButtonSave() {
    if (!_validateForm()) return;

    switch (_screenMode) {
      case ScreenMode.New:

        /// New
        var userHabit = UserHabit();
        userHabit.userHabitId = 0;
        userHabit.isDynamicHabit = false;

        // Habit settings
        userHabit.habitId = _habit!.habitId;

        // Name
        userHabit.name = _nameController.text;

        // Plan
        userHabit.planTerm = _planTerm;

        if (_planList.isNotEmpty) {
          userHabit.planDays = [];
          for (var el in _planList) {
            if (el.isSelected ?? false) userHabit.planDays!.add(el);
          }
        }

        // Start, end date
        userHabit.startDate = Func.dateTimeToDateStr(_startDate);
        userHabit.endDate = Func.dateTimeToDateStr(_endDate);

        // Goal
        if (_goalSettings?.goalRequired ?? false) {
          print("goal nemsen");
          userHabit.goalValue = Func.toStr(_goalSliderBloc?.value);
        }

        // Reminder
        if (_reminderBloc.switchValue && _reminderBloc.timeOfDayList.isNotEmpty) {
          userHabit.userHabitReminders = [];
          for (var el in _reminderBloc.timeOfDayList) {
            userHabit.userHabitReminders!.add(UserHabitReminders()..time = el.hour * 60 + el.minute);
          }
        } else {
          userHabit.userHabitReminders = null;
        }

        // Note
        userHabit.userNote = '';

        BlocManager.userHabitBloc.add(InsertUserHabitEvent(userHabit));
        break;

      case ScreenMode.HabitTemplate:

        /// New
        var userHabit = UserHabit();
        userHabit.userHabitId = 0;
        userHabit.isDynamicHabit = false;

        // Habit settings
        userHabit.habitId = _habit!.habitId;

        // Name
        userHabit.name = _nameController.text;

        // Plan
        userHabit.planTerm = _planTerm;

        if (_planList.isNotEmpty) {
          userHabit.planDays = [];
          for (var el in _planList) {
            print("orjeenuu ${el.day}");
            userHabit.planDays!.add(el);
          }
        }

        // Goal
        if (_goalSettings?.goalRequired ?? false) {
          print("goal nemsen");
          userHabit.goalValue = Func.toStr(_goalSliderBloc?.value);
        }

        // Start, end date
        userHabit.startDate = Func.dateTimeToDateStr(_startDate);
        userHabit.endDate = Func.dateTimeToDateStr(_endDate);

        // Reminder
        if (_reminderBloc.switchValue && _reminderBloc.timeOfDayList.isNotEmpty) {
          userHabit.userHabitReminders = [];
          for (var el in _reminderBloc.timeOfDayList) {
            userHabit.userHabitReminders!.add(UserHabitReminders()..time = el.hour * 60 + el.minute);
          }
        } else {
          userHabit.userHabitReminders = null;
        }

        // Note
        userHabit.userNote = '';

        BlocManager.userHabitBloc.add(InsertUserHabitEvent(userHabit));
        break;
      case ScreenMode.Edit:

        /// Edit
        var userHabit = _userHabit!;
        userHabit.isDynamicHabit = false;

        // Name
        userHabit.name = _nameController.text;

        // Plan
        userHabit.planTerm = _planTerm;

        if (_planList.isNotEmpty) {
          userHabit.planDays = [];
          for (var el in _planList) {
            if (el.isSelected ?? false) userHabit.planDays!.add(el);
          }
        }

        // Start, end date
        userHabit.startDate = Func.dateTimeToDateStr(_startDate);
        userHabit.endDate = Func.dateTimeToDateStr(_endDate);

        // Reminder
        if (_reminderBloc.switchValue && _reminderBloc.timeOfDayList.isNotEmpty) {
          userHabit.userHabitReminders = [];
          for (var el in _reminderBloc.timeOfDayList) {
            userHabit.userHabitReminders!.add(UserHabitReminders()..time = el.hour * 60 + el.minute);
          }
        } else {
          userHabit.userHabitReminders = null;
        }

        // Note
        userHabit.userNote = '';

        BlocManager.userHabitBloc.add(UpdateUserHabitEvent(userHabit));
        break;
      case ScreenMode.CustomNew:

        /// Custom new habit
        var userHabit = UserHabit();
        userHabit.userHabitId = 0;
        userHabit.isDynamicHabit = true;
        userHabit.habitId = 0;

        // Habit
        userHabit.habit = Habit();
        userHabit.habit!.habitId = 0;
        userHabit.habit!.categoryId = globals.userData?.habitCategoryId;

        // Name
        userHabit.name = _nameController.text;

        // Color
        userHabit.habit!.color = _primaryColorCode;
        userHabit.habit!.backgroundColor = _backgroundColorCode;

        // Icon
        userHabit.habit!.photo = _icon?.link;

        // Plan
        userHabit.planTerm = _planTerm;

        if (_planList.isNotEmpty) {
          userHabit.planDays = [];
          for (var el in _planList) {
            if (el.isSelected ?? false) userHabit.planDays!.add(el);
          }
        }

        // Goal
        userHabit.habit!.goalSettings = _goalSettings;

        if (_goalSettings?.goalRequired ?? false) {
          userHabit.goalValue = Func.toStr(_goalSliderBloc?.value);
        }

        // Start, end date
        userHabit.startDate = Func.dateTimeToDateStr(_startDate);
        userHabit.endDate = Func.dateTimeToDateStr(_endDate);

        // Reminder
        if (_reminderBloc.switchValue && _reminderBloc.timeOfDayList.isNotEmpty) {
          userHabit.userHabitReminders = [];
          for (var el in _reminderBloc.timeOfDayList) {
            userHabit.userHabitReminders!.add(UserHabitReminders()..time = el.hour * 60 + el.minute);
          }
        } else {
          userHabit.userHabitReminders = null;
        }

        // Note
        userHabit.userNote = '';

        BlocManager.userHabitBloc.add(InsertUserHabitEvent(userHabit));
        break;
      case ScreenMode.CustomEdit:

        /// Edit custom habit
        var userHabit = _userHabit!;

        // Name
        userHabit.name = _nameController.text;

        // Plan
        userHabit.planTerm = _planTerm;

        if (_planList.isNotEmpty) {
          userHabit.planDays = [];
          for (var el in _planList) {
            if (el.isSelected ?? false) userHabit.planDays!.add(el);
          }
        }

        // Start, end date
        userHabit.startDate = Func.dateTimeToDateStr(_startDate);
        userHabit.endDate = Func.dateTimeToDateStr(_endDate);

        // Reminder
        if (_reminderBloc.switchValue && _reminderBloc.timeOfDayList.isNotEmpty) {
          userHabit.userHabitReminders = [];
          for (var el in _reminderBloc.timeOfDayList) {
            userHabit.userHabitReminders!.add(UserHabitReminders()..time = el.hour * 60 + el.minute);
          }
        } else {
          userHabit.userHabitReminders = null;
        }

        // Note
        userHabit.userNote = '';

        BlocManager.userHabitBloc.add(UpdateUserHabitEvent(userHabit));
        break;
      case ScreenMode.CustomEdit:
        break;
    }
  }

  Widget _buttonDelete() {
    switch (_screenMode) {
      case ScreenMode.Edit:
      case ScreenMode.CustomEdit:
        return Align(
          alignment: Alignment.topRight,
          child: DeleteButtonWidget(
            onDelete: () {
              BlocManager.userHabitBloc.add(DeleteUserHabitEvent(_userHabit!.userHabitId!));
            },
          ),
        );
      case ScreenMode.New:
      case ScreenMode.Edit:
      default:
        return Container();
    }
    // return _screenMode == ScreenMode.Edit
    //     ? ButtonStadium(
    //         style: ButtonStadiumStyle.Primary,
    //         asset: Assets.trash,
    //         iconColor: customColors.iconRed,
    //         margin: EdgeInsets.only(top: 15.0),
    //         onPressed: () {
    //           if (_userHabit != null) {
    //             showCustomDialog(
    //               context,
    //               child: CustomDialogBody(
    //                 asset: Assets.warning,
    //                 text: LocaleKeys.sureToDelete,
    //                 buttonText: LocaleKeys.yes,
    //                 onPressedButton: () {
    //                   BlocManager.userHabitBloc.add(DeleteUserHabitEvent(_userHabit!));
    //                 },
    //                 button2Text: LocaleKeys.no,
    //               ),
    //             );
    //           }
    //         },
    //       )
    //     : Container();
  }

  Widget _goalWidget() {
    switch (_screenMode) {
      case ScreenMode.CustomNew:
      case ScreenMode.CustomEdit:
        return StadiumContainer(
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              /// Зорилго
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                child: Row(
                  children: [
                    SvgPicture.asset(Assets.trophy, color: HabitHelper.getPrimaryColor(_primaryColorCode)),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: CustomText(LocaleKeys.goal),
                    ),
                  ],
                ),
              ),

              _visibleGoalMeasure
                  ? Row(
                      children: [
                        /// Icon
                        // (_goalSettings == null)
                        //     ? SvgPicture.asset(Assets.icon_picker)
                        //     : CachedNetworkImage(imageUrl: _goalMeasure.val as HabitGoalSettings),

                        /// Measure combo
                        Expanded(
                          child: CustomCombobox(
                            primaryColor: HabitHelper.getPrimaryColor(_primaryColorCode),
                            backgroundColor: customColors.whiteBackground,
                            initialText: HabitHelper.getGoalSettingsComboItem(_goalSettings) != null
                                ? Func.toStr(_goalSettings!.goalName)
                                : LocaleKeys.selectMeasure,
                            selectedItem: HabitHelper.getGoalSettingsComboItem(_goalSettings),
                            list: HabitHelper.getGoalSettingsComboList(_goalSettingsList),
                            onItemSelected: (ComboItem item) {
                              setState(() {
                                _goalSettings = item.val;
                              });

                              print('test');

                              _goalSliderBloc?.add(SliderResetEvent(
                                Func.toDouble(_goalSettings!.goalMin),
                                Func.toDouble(_goalSettings!.goalMax),
                                Func.toDouble(_goalSettings!.goalMax) / 2,
                                Func.toDouble(_goalSettings!.goalStep),
                              ));
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(),

              HorizontalLine(margin: EdgeInsets.symmetric(horizontal: 15.0)),

              /// Slider
              if (_goalSliderBloc != null && (_goalSettings?.goalRequired ?? false))
                CustomSlider(
                  sliderBloc: _goalSliderBloc!,
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  primaryColor: HabitHelper.getPrimaryColor(_primaryColorCode),
                  title: _goalSettings!.toolMeasure,
                  quantityText: _goalSettings!.toolUnit,
                  visibleButtons: true,
                ),
            ],
          ),
        );
      case ScreenMode.New:
      case ScreenMode.Edit:
      default:
        if (!(_goalSettings?.goalRequired ?? false)) return Container();

        return StadiumContainer(
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              /// Зорилго
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                child: Row(
                  children: [
                    SvgPicture.asset(Assets.trophy, color: HabitHelper.getPrimaryColor(_primaryColorCode)),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: CustomText(
                        LocaleKeys.goal,
                      ),
                    ),
                  ],
                ),
              ),

              /// Slider
              if (_goalSliderBloc != null)
                CustomSlider(
                  sliderBloc: _goalSliderBloc!,
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  primaryColor: HabitHelper.getPrimaryColor(_primaryColorCode),
                  title: _goalSettings!.toolMeasure,
                  quantityText: _goalSettings!.toolUnit,
                  visibleButtons: true,
                ),
            ],
          ),
        );
    }
  }

  bool _validateForm() {
    String text = '';

    if (_startDate == null) {
      text = LocaleKeys.pleaseEnterStartDate;
    } else if (_endDate == null) {
      text = LocaleKeys.pleaseEnterEndDate;
    } else if ((_habit!.goalSettings?.goalRequired ?? false) && _goalSliderBloc != null && _goalSliderBloc!.value <= 0.0) {
      text = LocaleKeys.pleaseSelectGoal;
    }

    if (text.isNotEmpty) {
      showCustomDialog(
        context,
        isDismissible: false,
        child: CustomDialogBody(
          asset: Assets.warning,
          text: text,
          buttonText: LocaleKeys.ok,
        ),
      );

      return false;
    }

    return true;
  }
}
