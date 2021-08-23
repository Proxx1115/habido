import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'psy_tests_bloc.dart';

class PsyTestsRoute extends StatefulWidget {
  final int testCatId;

  const PsyTestsRoute({Key? key, required this.testCatId}) : super(key: key);

  @override
  _PsyTestsRouteState createState() => _PsyTestsRouteState();
}

class _PsyTestsRouteState extends State<PsyTestsRoute> {
  // UI
  final _categoryTestsKey = GlobalKey<ScaffoldState>();
  late PsyTestBloc _categoryTestsBloc;

  // Data
  Content? _content;
  List<PsyTest>? _psyTestList;

  @override
  void initState() {
    _categoryTestsBloc = PsyTestBloc();
    _categoryTestsBloc.add(GetPsyTestsEvent(widget.testCatId));
    super.initState();
  }

  @override
  void dispose() {
    _categoryTestsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _categoryTestsBloc,
      child: BlocListener<PsyTestBloc, PsyTestState>(
        listener: _blocListener,
        child: BlocBuilder<PsyTestBloc, PsyTestState>(
          builder: (context, state) {
            return CustomScaffold(
              scaffoldKey: _categoryTestsKey,
              appBarTitle: LocaleKeys.psyStatus,
              body: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(SizeHelper.padding),
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                children: <Widget>[
                  if (_psyTestList != null && _psyTestList!.length > 0)
                    for (var el in _psyTestList!) _testCategoryItem(el),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, PsyTestState state) {
    if (state is PsyTestsSuccess) {
      _content = state.psyTestsResponse.content;
      _psyTestList = state.psyTestsResponse.psyTestList;
    } else if (state is PsyTestsFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          button1Text: LocaleKeys.ok,
          onPressedButton1: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  Widget _testCategoryItem(PsyTest psyTest) {
    return Container();
    // return CategoryContainer(
    //   imageUrl: testCategory.photo,
    //   backgroundColor: testCategory.color,
    //   text: testCategory.name! + 'asdasd',
    //   onPressed: () {
    //     Navigator.pushNamed(context, Routes.testCategories);
    //   },
    // );
  }
}
