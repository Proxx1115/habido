import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/psy_test_category_results.dart';
import 'package:habido_app/models/psy_test_result.dart';
import 'package:habido_app/models/psy_test_results_response.dart';
import 'package:habido_app/models/user_psy_test_result.dart';
import 'package:habido_app/widgets/app_bars/home_app_bar.dart';
import 'package:habido_app/bloc/psy_test_main_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

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
      body: Column(
        children: [
          /// Calendar, Title, Notification
          HomeAppBar(title: LocaleKeys.psyTest),

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
                    itemCount: 1,
                    itemBuilder: (context, index) => _psyTestCategoryResultsItem(),
                  )
                : Container();
          },
        ),
      ),
    );
  }

  Widget _psyTestCategoryResultsItem() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _categoryList![index].isExpanded = !isExpanded;
        });
      },
      children: _categoryList!.map<ExpansionPanel>((PsyTestCategoryResults category) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: CustomText(category.categoryName),
            );
          },
          body: Column(
            children: [
              if (category.psyTestResults != null)
                for (var el in category.psyTestResults!)
                  ListTile(
                    title: CustomText(el.testResult?.text),
                    subtitle: CustomText(el.testResult?.pointRange),
                    // trailing: const Icon(Icons.delete),
                    onTap: () {
                      // setState(() {
                      //   _data.removeWhere((Item currentItem) => item == currentItem);
                      // });
                    },
                  ),
            ],
          ),
          isExpanded: category.isExpanded ?? false,
        );
      }).toList(),
    );

    // return Column(
    //   children: [
    //     CustomText('text'),
    //     ExpansionPanel(headerBuilder: headerBuilder, body: Conatine),
    //     ExpansionPanel(
    //       headerBuilder: (context, isOpen) {
    //         return CustomText(psyTestCategoryResults.categoryName);
    //       },
    //       body: Column(
    //         children: [
    //           //
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget _psyTestResultItem() {
    return Column(
      children: [
        //
      ],
    );
  }
}
