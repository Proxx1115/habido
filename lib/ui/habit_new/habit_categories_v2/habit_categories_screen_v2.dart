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
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_container.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_container_v2.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item_v2.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:showcaseview/showcaseview.dart';
import 'habit_category_bloc.dart';

class HabitCategoriesScreenV2 extends StatefulWidget {
  const HabitCategoriesScreenV2({Key? key}) : super(key: key);

  @override
  _HabitCategoriesScreenV2State createState() =>
      _HabitCategoriesScreenV2State();
}

class _HabitCategoriesScreenV2State extends State<HabitCategoriesScreenV2> {
  // Data
  List<Habit>? _habitList;
  // Bloc
  final _habitCategoryBloc = HabitCategoryBloc();

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
              padding:
                  EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 55),
              children: [
                if (_habitCategoryList != null &&
                    _habitCategoryList!.isNotEmpty)
                  for (var el in _habitCategoryList!)
                    if (el.userId != 0)
                      ButtonStadiumWithText(
                        backgroundColor: customColors.primary,
                        asset: Assets.add,
                        text: el.name!,
                        borderRadius: 15.0,
                      ),
                SizedBox(
                  height: 20.0,
                ),
                if (_habitCategoryList != null &&
                    _habitCategoryList!.isNotEmpty)
                  for (var el in _habitCategoryList!)
                    if (el.userId == 0)
                      Column(
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          _expandableHabitList(
                              el.name!, el.habits!, true, false, ''),
                        ],
                      )

                /// Category list
                // if (_habitCategoryList != null &&
                //     _habitCategoryList!.isNotEmpty)
                // Expanded(
                //   child: GridView.count(
                //     primary: false,
                //     padding: const EdgeInsets.all(SizeHelper.padding),
                //     crossAxisSpacing: 15.0,
                //     mainAxisSpacing: _mainAxisSpacing,
                //     crossAxisCount: 2,
                //     childAspectRatio: 1.11,
                //     children: List.generate(
                //       _habitCategoryList!.length,
                //       (index) => (index == 0)
                //           ? CustomShowcase(
                //               showcaseKey: ShowcaseKey.habitCategory,
                //               description: LocaleKeys.showcaseHabitCategory,
                //               overlayOpacity: 0.5,
                //               overlayPadding: EdgeInsets.all(-5.0),
                //               child:
                //                   _categoryItem(_habitCategoryList![index]),
                //             )
                //           : _categoryItem(_habitCategoryList![index]),
                //     ),
                //   ),
                // ),
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
      // print(_habitCategoryList);
      if (_habitCategoryList != null && _habitCategoryList!.isNotEmpty) {
        _habitCategoryBloc
            .add(HabitCategoryShowcaseEvent(ShowcaseKeyName.habitCategory));
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

  Widget _categoryItem(HabitCategory category) {
    return (Func.isNotEmpty(category.photo) && Func.isNotEmpty(category.color))
        ? FadeInAnimation(
            child: GridItemContainer(
              imageUrl: category.photo!,
              backgroundColor: category.color!,
              text: category.name ?? '',
              onPressed: () {
                if (Func.toInt(category.userId) > 0) {
                  _habitCategoryBloc.add(GetCustomHabitSettingsEvent(category));
                } else {
                  // Default habit
                  Navigator.pushNamed(context, Routes.habitList, arguments: {
                    'habitCategory': category,
                  });
                }
              },
            ),
          )
        : Container();
  }

  Widget _expandableHabitList(String title, List<Habit> userHabitList,
      bool enabled, bool isToday, String? todayText) {
    return ExpandableContainerV2(
      isToday: isToday,
      todayText: todayText,
      title: title,
      expandableListItems: List.generate(
        userHabitList.length,
        (index) => ExpandableListItemV2(
          delay: index * 0.2,
          text: userHabitList[index].name ?? '',
          leadingUrl: userHabitList[index].photo,
          leadingColor: customColors.iconWhite,
          // leadingBackgroundColor: (userHabitList[index].habit?.color != null)
          //     ? HexColor.fromHex(userHabitList[index].habit!.color!)
          //     : null,
          // suffixAsset: _getSuffixAsset(userHabitList[index]),
          // suffixColor: _getSuffixColor(userHabitList[index]),
          // suffixAsset: (userHabitList[index].isDone ?? false) ? Assets.check2 : Assets.arrow_forward,
          // suffixColor: (userHabitList[index].isDone ?? false) ? customColors.iconSeaGreen : customColors.primary,
          onPressed: () {
            // Is finished
            // if (userHabitList[index].isDone ?? false) return;

            // Navigate
            // if (enabled && userHabitList[index].habit?.goalSettings != null) {
            //   String? route =
            //       HabitHelper.getProgressRoute(userHabitList[index].habit!);
            //   if (route != null) {
            //     Navigator.pushNamed(
            //       context,
            //       route,
            //       arguments: {
            //         'userHabit': userHabitList[index],
            //       },
            //     );
            //   }
            // }
          },
        ),
      ),
    );
  }
}
