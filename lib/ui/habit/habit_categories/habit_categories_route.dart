import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

import 'habit_category_bloc.dart';

class HabitCategoriesRoute extends StatefulWidget {
  const HabitCategoriesRoute({Key? key}) : super(key: key);

  @override
  _HabitCategoriesRouteState createState() => _HabitCategoriesRouteState();
}

class _HabitCategoriesRouteState extends State<HabitCategoriesRoute> {
  // UI
  final _habitCategoriesKey = GlobalKey<ScaffoldState>();
  final _habitCategoryBloc = HabitCategoryBloc();

  // Data
  List<HabitCategory>? _habitCategoryList;

  @override
  void initState() {
    _habitCategoryBloc.add(GetHabitCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _habitCategoriesKey,
      appBarTitle: LocaleKeys.createHabit,
      body: BlocProvider.value(
        value: _habitCategoryBloc,
        child: BlocListener<HabitCategoryBloc, HabitCategoryState>(
          listener: _blocListener,
          child: BlocBuilder<HabitCategoryBloc, HabitCategoryState>(
            builder: (context, state) {
              // return Container(
              //   padding: SizeHelper.paddingScreen,
              //   child: CustomText('asd'),
              // );

              return (_habitCategoryList != null && _habitCategoryList!.isNotEmpty)
                  ? GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(SizeHelper.padding),
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      children:

                          // <Widget>[
                          //   for (var el in _habitCategoryList!) _categoryItem(el),
                          // ],

                          List.generate(
                        _habitCategoryList!.length,
                        (index) => _categoryItem(_habitCategoryList![index]),
                      ),
                    )
                  : Container();
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, HabitCategoryState state) {
    if (state is HabitCategoriesSuccess) {
      _habitCategoryList = state.habitCategoryList;
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
    }
  }

  Widget _categoryItem(HabitCategory category) {
    return GridItemContainer(
      imageUrl: 'https://habido-test.s3-ap-southeast-1.amazonaws.com/test-category/3f010def-93c4-425a-bce3-9df854a2f73b.png',
      // todo test category.photo,
      backgroundColor: '#EB86BE', //category.color,
      text: category.name ?? '',
      onPressed: () {
        Navigator.pushNamed(context, Routes.habitList, arguments: {
          'habitCategory': category,
        });
      },
    );
  }
}