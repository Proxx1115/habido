import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/test_category.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

import 'test_categories_bloc.dart';

class TestCategoriesRoute extends StatefulWidget {
  const TestCategoriesRoute({Key? key}) : super(key: key);

  @override
  _TestCategoriesRouteState createState() => _TestCategoriesRouteState();
}

class _TestCategoriesRouteState extends State<TestCategoriesRoute> {
  // UI
  final _testCategoryKey = GlobalKey<ScaffoldState>();
  late TestCategoryBloc _testCategoryBloc;

  // Data
  List<TestCategory>? _testCategoryList;

  @override
  void initState() {
    _testCategoryBloc = TestCategoryBloc();
    _testCategoryBloc.add(GetTestCategoriesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _testCategoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _testCategoryBloc,
      child: BlocListener<TestCategoryBloc, TestCategoryState>(
        listener: _blocListener,
        child: BlocBuilder<TestCategoryBloc, TestCategoryState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, TestCategoryState state) {
    if (state is TestCategoriesSuccess) {
      _testCategoryList = state.testCategoryList;
    } else if (state is TestCategoriesFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, button1Text: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, TestCategoryState state) {
    return CustomScaffold(
      scaffoldKey: _testCategoryKey,
      appBarTitle: LocaleKeys.psyTest,
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(SizeHelper.padding),
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        children: <Widget>[
          if (_testCategoryList != null && _testCategoryList!.length > 0)
            for (var el in _testCategoryList!) _testCategoryItem(el),
        ],
      ),
    );
  }

  Widget _testCategoryItem(TestCategory testCategory) {
    return CategoryContainer(
      imageUrl: testCategory.photo,
      backgroundColor: testCategory.color,
      text: testCategory.name!,
      onPressed: () {
        Navigator.pushNamed(context, Routes.psyTests, arguments: {
          'testCatId': testCategory.testCatId,
        });
      },
    );
  }
}
