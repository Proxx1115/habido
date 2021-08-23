import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/test_category.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers.dart';
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
  late PsyTestsBloc _categoryTestsBloc;

  // Data
  List<PsyTest>? _psyTestList;

  @override
  void initState() {
    _categoryTestsBloc = PsyTestsBloc();
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
      child: BlocListener<PsyTestsBloc, PsyTestsState>(
        listener: _blocListener,
        child: BlocBuilder<PsyTestsBloc, PsyTestsState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, PsyTestsState state) {
    if (state is PsyTestsSuccess) {
      _psyTestList = state.psyTestList;
    } else if (state is PsyTestsFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, button1Text: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, PsyTestsState state) {
    return CustomScaffold(
      scaffoldKey: _categoryTestsKey,
      appBarTitle: LocaleKeys.psyTest,
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
