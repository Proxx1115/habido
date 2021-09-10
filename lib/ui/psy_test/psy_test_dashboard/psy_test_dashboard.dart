import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/psy_test_category_results.dart';
import 'package:habido_app/bloc/psy_test_main_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/app_bars/dashboard_app_bar.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_container.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item.dart';
import 'package:habido_app/widgets/scaffold.dart';

class PsyTestDashboard extends StatefulWidget {
  const PsyTestDashboard({Key? key}) : super(key: key);

  @override
  _PsyTestDashboardState createState() => _PsyTestDashboardState();
}

class _PsyTestDashboardState extends State<PsyTestDashboard> {
  // UI
  final _psyDashboardKey = GlobalKey<ScaffoldState>();

  // Data
  List<PsyTestCategoryResults>? _categoryList;

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _psyDashboardKey,
      onWillPop: () {
        print('nothing');
      },
      child: Column(
        children: [
          /// App bar
          DashboardAppBar(
            title: LocaleKeys.psyTest,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
          ),

          /// List
          Expanded(
            child: _psyTestResultsWidget(),
          ),
        ],
      ),
      floatingActionButton: ButtonStadium(
        style: ButtonStadiumStyle.Secondary,
        asset: Assets.add,
        onPressed: () {
          Navigator.pushNamed(context, Routes.psyCategories);
        },
      ),
    );
  }

  void _getData() {
    Future.delayed(Duration(milliseconds: 500), () {
      BlocManager.psyTestMainBloc.add(GetPsyTestResultsEvent());
    });
  }

  Widget _psyTestResultsWidget() {
    return BlocProvider.value(
      value: BlocManager.psyTestMainBloc,
      child: BlocListener<PsyTestMainBloc, PsyTestMainState>(
        listener: (context, state) {
          if (state is PsyTestResultsSuccess) {
            _categoryList = state.response.psyTestCategoryResults;
          }
        },
        child: BlocBuilder<PsyTestMainBloc, PsyTestMainState>(
          builder: (context, state) {
            return (_categoryList != null && _categoryList!.isNotEmpty)
                ? ListView.builder(
                    padding: EdgeInsets.fromLTRB(SizeHelper.padding, 25.0, SizeHelper.margin, SizeHelper.marginBottom),
                    itemCount: _categoryList!.length,
                    itemBuilder: (context, index) => _expandable(_categoryList![index]),
                  )
                : Container();
          },
        ),
      ),
    );
  }

  Widget _expandable(PsyTestCategoryResults category) {
    return category.psyTestResults != null && category.psyTestResults!.length > 0
        ? ExpandableContainer(
            margin: EdgeInsets.only(bottom: 20.0),
            title: category.categoryName ?? '',
            expandableListItems: List.generate(
              category.psyTestResults!.length,
              (index) => ExpandableListItem(

                text: category.psyTestResults![index].testResult?.testName ?? '',
                leadingImageUrl: category.psyTestResults![index].photo,
                leadingBackgroundColor: (category.psyTestResults![index].color != null)
                    ? HexColor.fromHex(category.psyTestResults![index].color!)
                    : null,
                onPressed: () {
                  if (category.psyTestResults![index].testResult != null) {
                    Navigator.pushNamed(context, Routes.psyTestResult, arguments: {
                      'psyTestResult': category.psyTestResults![index].testResult,
                    });
                  }
                },
              ),
            ),
          )
        : Container();
  }
}
