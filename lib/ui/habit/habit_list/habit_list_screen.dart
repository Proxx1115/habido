import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/habit.dart';
import 'package:habido_app/models/habit_category.dart';
import 'package:habido_app/ui/habit/habit_helper.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/screen_mode.dart';
import 'package:habido_app/utils/showcase_helper.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/custom_showcase.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:showcaseview/showcaseview.dart';
import 'habit_list_bloc.dart';

class HabitListScreen extends StatefulWidget {
  final HabitCategory habitCategory;

  const HabitListScreen({Key? key, required this.habitCategory})
      : super(key: key);

  @override
  _HabitListScreenState createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  // UI
  final _habitHabitsKey = GlobalKey<ScaffoldState>();
  late Color _primaryColor;
  late Color _backgroundColor;

  // Bloc
  final _habitListBloc = HabitListBloc();

  // Data
  List<Habit>? _habitList;

  @override
  void initState() {
    // Color
    _primaryColor = HabitHelper.getPrimaryColor3(widget.habitCategory);
    _backgroundColor = HabitHelper.getBackgroundColor3(widget.habitCategory);

    _habitListBloc.add(GetHabitsEvent(widget.habitCategory.categoryId ?? -99));

    super.initState();
  }

  @override
  void dispose() {
    _habitListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        scaffoldKey: _habitHabitsKey,
        appBarTitle: LocaleKeys.createHabit,
        backgroundColor: _backgroundColor,
        child: BlocProvider.value(
          value: _habitListBloc,
          child: BlocListener<HabitListBloc, HabitListState>(
            listener: _blocListener,
            child: BlocBuilder<HabitListBloc, HabitListState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: SizeHelper.screenPadding,
                  child: Column(
                    children: <Widget>[
                      /// HabitList
                      if (_habitList != null && _habitList!.isNotEmpty)
                        for (int i = 0; i < _habitList!.length; i++)
                          (i == 0) ? _listItem(i) : _listItem(i),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, HabitListState state) {
    if (state is HabitsSuccess) {
      _habitList = state.habitList;

      if (_habitList != null && _habitList!.isNotEmpty) {
        _habitListBloc.add(HabitListShowcaseEvent(ShowcaseKeyName.habit));
      }
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
    } else if (state is HabitListShowcaseState) {
      ShowCaseWidget.of(context)?.startShowCase(state.showcaseKeyList);
    }
  }

  Widget _listItem(int index) {
    return ListItemContainer(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 70.0,
      leadingImageUrl: _habitList![index].photo,
      leadingBackgroundColor: _primaryColor,
      title: _habitList![index].name ?? '',
      suffixAsset: Assets.arrow_forward,
      onPressed: () {
        Navigator.pushNamed(context, Routes.userHabit, arguments: {
          'screenMode': ScreenMode.New,
          'habit': _habitList![index],
          'title': LocaleKeys.startNewHabit,
        });
      },
    );
  }
}
