import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/ui/content/content_card.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'habit_list_bloc.dart';

class HabitListRoute extends StatefulWidget {
  final HabitCategory habitCategory;

  const HabitListRoute({Key? key, required this.habitCategory}) : super(key: key);

  @override
  _HabitListRouteState createState() => _HabitListRouteState();
}

class _HabitListRouteState extends State<HabitListRoute> {
  // UI
  final _habitHabitsKey = GlobalKey<ScaffoldState>();
  final _habitHabitBloc = HabitListBloc();

  // Data
  List<Habit>? _habitList;

  @override
  void initState() {
    _habitHabitBloc.add(GetHabitsEvent(widget.habitCategory.categoryId ?? -99));
    super.initState();
  }

  @override
  void dispose() {
    _habitHabitBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _habitHabitsKey,
      appBarTitle: LocaleKeys.createHabit,
      body: BlocProvider.value(
        value: _habitHabitBloc,
        child: BlocListener<HabitListBloc, HabitListState>(
          listener: _blocListener,
          child: BlocBuilder<HabitListBloc, HabitListState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  padding: SizeHelper.paddingScreen,
                  child: Column(
                    children: <Widget>[
                      /// HabitList
                      if (_habitList != null && _habitList!.isNotEmpty)
                        for (var el in _habitList!)
                          ListItemContainer(
                            margin: EdgeInsets.only(bottom: 10.0),
                            height: 70.0,
                            // leadingImageUrl: el.photo,
                            // leadingBackgroundColor: HexColor.fromHex(el.color ?? '#F4F6F8'),

                            leadingImageUrl:
                                'https://habido-test.s3-ap-southeast-1.amazonaws.com/test-category/3f010def-93c4-425a-bce3-9df854a2f73b.png',
                            // todo test category.photo,
                            leadingBackgroundColor: HexColor.fromHex('#F4F6F8'),
                            //category.color,
                            text: el.name ?? '',
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.habit, arguments: {
                                'title': LocaleKeys.createHabit,
                                'habit': el,
                              });
                            },
                          ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, HabitListState state) {
    if (state is HabitsSuccess) {
      _habitList = state.habitList;
    } else if (state is HabitsFailed) {
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
}
