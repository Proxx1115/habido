import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_container_v2.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item_v2.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:showcaseview/showcaseview.dart';
import 'habit_category_bloc.dart';

class HabitCategoriesScreenV2 extends StatefulWidget {
  const HabitCategoriesScreenV2({Key? key}) : super(key: key);

  @override
  _HabitCategoriesScreenV2State createState() => _HabitCategoriesScreenV2State();
}

class _HabitCategoriesScreenV2State extends State<HabitCategoriesScreenV2> {
  // Data
  List<Habit>? _habitList;
  // Habit _newHabit;
  // Bloc
  final _habitCategoryBloc = HabitCategoryBloc();

  HabitCategory? _customCategory;

  // Gridview
  double _mainAxisSpacing = 15.0;
  List<HabitCategory>? _habitCategoryList;

  @override
  void initState() {
    _habitCategoryBloc.add(GetHabitCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _habitCategoryBloc,
      child: BlocListener<HabitCategoryBloc, HabitCategoryState>(
        listener: _blocListener,
        child: BlocBuilder<HabitCategoryBloc, HabitCategoryState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 55),
              children: [
                if (_customCategory != null)
                  ButtonStadiumWithText(
                    onPressed: () {
                      _habitCategoryBloc.add(GetCustomHabitSettingsEvent(_customCategory!));
                    },
                    backgroundColor: customColors.primary,
                    asset: Assets.add,
                    text: LocaleKeys.addNew, //_customCategory!.name!
                    borderRadius: 15.0,
                  ),
                SizedBox(
                  height: 20.0,
                ),
                if (_habitCategoryList != null && _habitCategoryList!.isNotEmpty)
                  for (var el in _habitCategoryList!)
                    if (el.userId == 0)
                      Column(
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          _expandableHabitList(el.name!, el.habits!),
                        ],
                      )
              ],
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, HabitCategoryState state) {
    if (state is HabitCategoriesSuccess) {
      _habitCategoryList = state.habitCategoryList;
      if (_habitCategoryList != null && _habitCategoryList!.isNotEmpty) {
        _customCategory = _habitCategoryList!.where((x) => x.userId != 0).first;
        _habitCategoryBloc.add(HabitCategoryShowcaseEvent(ShowcaseKeyName.habitCategory));
      }
    } else if (state is HabitCategoriesFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.pop(context);
          },
        ),
      );
    } else if (state is HabitCategoryShowcaseState) {
      ShowCaseWidget.of(context)?.startShowCase(state.showcaseKeyList);
    } else if (state is CustomHabitSettingsSuccess) {
      Navigator.pushNamed(context, Routes.userHabit, arguments: {
        'screenMode': ScreenMode.CustomNew,
        'habit': state.customHabit,
        'habitId': 0,
        'customHabitSettings': state.customHabitSettings,
        'title': LocaleKeys.createHabit,
      });
    } else if (state is CustomHabitSettingsFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  Widget _expandableHabitList(
    String title,
    List<Habit> userHabitList,
  ) {
    return ExpandableContainerV2(
      title: title,
      expandableListItems: List.generate(
        userHabitList.length,
        (index) => ExpandableListItemV2(
          delay: index * 0.2,
          text: userHabitList[index].name ?? '',
          leadingUrl: userHabitList[index].photo,
          leadingColor: HexColor.fromHex(userHabitList[index].color!),
          onPressed: () {
            Navigator.pushNamed(context, Routes.userHabit, arguments: {
              'screenMode': ScreenMode.New,
              'habitId': userHabitList[index].habitId,
              'title': LocaleKeys.startNewHabit,
            });
          },
        ),
      ),
    );
  }
}
