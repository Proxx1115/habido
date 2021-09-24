import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/custom_habit_settings_response.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/plan.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habit_reminders.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/ui/habit/user_habit/plan_terms/plan_term_helper.dart';
import 'package:habido_app/ui/habit/user_habit/plan_terms/plan_terms_widget.dart';
import 'package:habido_app/ui/habit/user_habit/reminder/reminder_bloc.dart';
import 'package:habido_app/bloc/user_habit_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/date_picker.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/slider/custom_slider.dart';
import 'package:habido_app/widgets/slider/slider_bloc.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:showcaseview/showcaseview.dart';
import 'custom_color_picker.dart';
import 'reminder/reminder_widget.dart';

class UserHabitScreen extends StatefulWidget {
  final String? title;
  final UserHabit? userHabit; // UserHabit, habit 2-ын нэг нь заавал утгатай байх ёстой
  final Habit? habit;
  final CustomHabitSettingsResponse? customHabitSettings;

  const UserHabitScreen({
    Key? key,
    this.title,
    this.userHabit,
    this.habit,
    this.customHabitSettings,
  }) : super(key: key);

  @override
  _UserHabitScreenState createState() => _UserHabitScreenState();
}

class _UserHabitScreenState extends State<UserHabitScreen> {
  // UI
  String _screenMode = ScreenMode.New;
  late Color _primaryColor;
  late Color _backgroundColor;

  // Data
  UserHabit? _userHabit;
  late Habit _habit;
  CustomHabitSettingsResponse? _customHabitSettings;

  // Name
  final _nameController = TextEditingController();

  // Color
  CustomHabitColor? _selectedCustomHabitColor;

  // Plan
  late String _selectedPlanTerm;
  late List<Plan> _planList;

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

  @override
  void initState() {
    /// User habit
    _userHabit = widget.userHabit;

    /// Screen mode
    if (_userHabit != null) {
      _screenMode = ScreenMode.Edit;
    } else if (widget.customHabitSettings != null) {
      _customHabitSettings = widget.customHabitSettings;
      _screenMode = ScreenMode.CustomNew;
    } else {
      _screenMode = ScreenMode.New;
    }

    /// Habit
    if (_userHabit != null && _userHabit!.habit != null) {
      _habit = _userHabit!.habit!;
    } else if (widget.habit != null) {
      _habit = widget.habit!;
    }

    /// Color
    _primaryColor = HabitHelper.getPrimaryColor2(_habit);
    _backgroundColor = HabitHelper.getBackgroundColor2(_habit);

    /// Name
    _nameController.text = _habit.name ?? '';

    /// Plan term
    if (_screenMode == ScreenMode.Edit) {
      _selectedPlanTerm = _userHabit!.planTerm ?? PlanTerm.Daily;
      _planList = _userHabit!.planDays ?? [];
    } else {
      _selectedPlanTerm = PlanTerm.Daily;
      _planList = [];
    }

    /// Goal
    if (_habit.goalSettings != null && _habit.goalSettings!.toolType != null) {
      // Slider
      if (_habit.goalSettings!.goalRequired ?? false) {
        // Value
        late double value;
        if (_screenMode == ScreenMode.Edit) {
          value = Func.toDouble(_userHabit!.goalValue);
        } else {
          value = Func.toDouble(_habit.goalSettings!.goalMax) / 2;
        }

        _sliderBloc = SliderBloc(
          minValue: Func.toDouble(_habit.goalSettings!.goalMin),
          maxValue: Func.toDouble(_habit.goalSettings!.goalMax),
          value: value,
          step: Func.toDouble(_habit.goalSettings!.goalStep),
        );

        _sliderTitle = _habit.goalSettings!.goalName;
        _sliderQuantity = _habit.goalSettings!.toolUnit;
      }
    }

    /// Start date, end date
    if (_screenMode == ScreenMode.Edit) {
      _selectedStartDate = Func.toDate(_userHabit!.startDate ?? '');
      _selectedEndDate = Func.toDate(_userHabit!.endDate ?? '');
    } else {
      _selectedStartDate = DateTime.now();
      _selectedEndDate = DateTime.now();
    }

    /// Reminder
    if (_screenMode == ScreenMode.Edit) {
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
    } else {
      //
    }

    /// Tip
    _tip = _habit.tip;

    /// Showcase
    BlocManager.userHabitBloc.add(UserHabitShowcaseEvent(ShowcaseKeyName.userHabit));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: widget.title != null ? widget.title : LocaleKeys.habit,
      backgroundColor: _backgroundColor,
      child: (_userHabit != null || widget.habit != null)
          ? BlocProvider.value(
              value: BlocManager.userHabitBloc,
              child: BlocListener<UserHabitBloc, UserHabitState>(
                listener: _blocListener,
                child: BlocBuilder<UserHabitBloc, UserHabitState>(builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                CustomShowcase(
                                  showcaseKey: ShowcaseKey.userHabit,
                                  description: LocaleKeys.showcaseUserHabit,
                                  overlayOpacity: 0.9,
                                  overlayPadding: EdgeInsets.all(20.0),
                                  shapeBorder: CircleBorder(),
                                  child: Column(
                                    children: [
                                      /// Нэр
                                      _nameTextField(),

                                      /// Өнгө сонгох
                                      _colorPicker(),

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

                                      // SizedBox(height: 300.0),
                                    ],
                                  ),
                                ),

                                /// Зөвлөмж
                                _tipWidget(),
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
                  );
                }),
              ),
            )
          : Container(),
    );
  }

  void _blocListener(BuildContext context, UserHabitState state) {
    if (state is InsertUserHabitSuccess || state is UpdateUserHabitSuccess || state is DeleteUserHabitSuccess) {
      showCustomDialog(
        context,
        isDismissible: false,
        child: CustomDialogBody(
          asset: Assets.success,
          text: LocaleKeys.success,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.popUntil(context, ModalRoute.withName(Routes.home));
          },
        ),
      );
    } else if (state is InsertUserHabitFailed || state is UpdateUserHabitFailed || state is DeleteUserHabitFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, buttonText: LocaleKeys.ok),
      );
    } else if (state is UserHabitShowcaseState) {
      ShowCaseWidget.of(context)?.startShowCase(state.showcaseKeyList);
    }
  }

  Widget _nameTextField() {
    return CustomTextField(
      controller: _nameController,
      hintText: LocaleKeys.habitName,
      maxLength: 30,
    );
  }

  Widget _colorPicker() {
    return _screenMode == ScreenMode.CustomNew
        ? CustomColorPicker(
            colorList: _customHabitSettings?.colors ?? [],
            margin: EdgeInsets.only(top: 15.0),
            onColorSelected: (value) {
              _selectedCustomHabitColor = value;
              if (_selectedCustomHabitColor != null) {
                // todo test
                setState(() {
                  _primaryColor = HexColor.fromHex(_selectedCustomHabitColor!.color ?? ColorCodes.primary);
                  _backgroundColor = HexColor.fromHex(_selectedCustomHabitColor!.bgColor ?? ColorCodes.roseWhite);
                });
              }
            },
          )
        : Container();
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
    return _habit.goalSettings?.goalRequired ?? false
        ? StadiumContainer(
            margin: EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
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
      initialDate: _selectedStartDate,
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
      initialDate: _selectedEndDate,
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
    return (Func.isNotEmpty(_tip))
        ? InfoContainer(
            margin: EdgeInsets.only(top: 15.0),
            title: LocaleKeys.tip,
            body: _tip!,
          )
        : Container();
  }

  Widget _buttonDelete() {
    return _screenMode == ScreenMode.Edit
        ? ButtonStadium(
            style: ButtonStadiumStyle.Primary,
            asset: Assets.trash,
            iconColor: customColors.iconRed,
            margin: EdgeInsets.only(top: 15.0),
            onPressed: () {
              if (_userHabit != null) {
                showCustomDialog(
                  context,
                  child: CustomDialogBody(
                    asset: Assets.warning,
                    text: LocaleKeys.sureToDelete,
                    buttonText: LocaleKeys.yes,
                    onPressedButton: () {
                      BlocManager.userHabitBloc.add(DeleteUserHabitEvent(_userHabit!));
                    },
                    button2Text: LocaleKeys.no,
                  ),
                );
              }
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
    late UserHabit userHabit;
    if (_screenMode == ScreenMode.Edit) {
      userHabit = _userHabit!;
    } else {
      userHabit = UserHabit();
      userHabit.userHabitId = 0;

      // Habit settings
      userHabit.habitId = _habit.habitId;
    }

    /// Name
    userHabit.name = _nameController.text;

    /// Plan
    userHabit.planTerm = _selectedPlanTerm;

    if (_planList.isNotEmpty) {
      userHabit.planDays = [];
      for (var el in _planList) {
        if (el.isSelected ?? false) userHabit.planDays!.add(el);
      }
    }

    /// Goal
    if (_habit.goalSettings?.goalRequired ?? false) {
      userHabit.goalValue = Func.toStr(_sliderBloc?.value);
    }

    /// Start, end date
    userHabit.startDate = Func.dateTimeToDateStr(_selectedStartDate);
    userHabit.endDate = Func.dateTimeToDateStr(_selectedEndDate);

    /// Reminder
    if (_reminderBloc.switchValue && _reminderBloc.timeOfDayList.isNotEmpty) {
      userHabit.userHabitReminders = [];
      for (var el in _reminderBloc.timeOfDayList) {
        userHabit.userHabitReminders!.add(UserHabitReminders()..time = el.hour * 60 + el.minute);
      }
    }

    /// Note
    userHabit.userNote = '';

    if (_screenMode == ScreenMode.Edit) {
      BlocManager.userHabitBloc.add(UpdateUserHabitEvent(userHabit));
    } else {
      BlocManager.userHabitBloc.add(InsertUserHabitEvent(userHabit));
    }
  }
}
