import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:showcaseview/showcaseview.dart';
import 'habit_category_bloc.dart';

class HabitCategoriesScreen extends StatefulWidget {
  const HabitCategoriesScreen({Key? key}) : super(key: key);

  @override
  _HabitCategoriesScreenState createState() => _HabitCategoriesScreenState();
}

class _HabitCategoriesScreenState extends State<HabitCategoriesScreen> {
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
            return Column(
              children: [
                /// Category list
                if (_habitCategoryList != null && _habitCategoryList!.isNotEmpty)
                  Expanded(
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(SizeHelper.padding),
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: _mainAxisSpacing,
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      children: List.generate(
                        _habitCategoryList!.length,
                        (index) => (index == 0)
                            ? CustomShowcase(
                                showcaseKey: ShowcaseKey.habitCategory,
                                description: LocaleKeys.showcaseHabitCategory,
                                overlayOpacity: 0.5,
                                overlayPadding: EdgeInsets.all(-5.0),
                                child: _categoryItem(_habitCategoryList![index]),
                              )
                            : _categoryItem(_habitCategoryList![index]),
                      ),
                    ),
                  ),
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
                Navigator.pushNamed(context, Routes.habitList, arguments: {
                  'habitCategory': category,
                });
              },
            ),
          )
        : Container();
  }
}
