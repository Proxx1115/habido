import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/psy_test_category_results.dart';
import 'package:habido_app/bloc/psy_test_main_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/ui/home/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_container.dart';
import 'package:habido_app/widgets/containers/expandable_container/expandable_list_item.dart';
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

  //
  bool _visibleHint = false;

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
      floatingActionButton: CustomButton(
        style: CustomButtonStyle.secondary,
        width: 130.0,
        text: LocaleKeys.doTest2,
        alignment: Alignment.bottomRight,
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

            if (_categoryList == null || _categoryList!.isEmpty) {
              _visibleHint = true;
            } else {
              _visibleHint = false;
            }
          }
        },
        child: BlocBuilder<PsyTestMainBloc, PsyTestMainState>(
          builder: (context, state) {
            return _visibleHint
                ? _hint()
                : ((_categoryList != null && _categoryList!.isNotEmpty)
                    ? ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          SizeHelper.padding,
                          25.0,
                          SizeHelper.margin,
                          SizeHelper.marginBottom,
                        ),
                        itemCount: _categoryList!.length,
                        itemBuilder: (context, index) => _expandable(_categoryList![index]),
                      )
                    : Container());
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
                delay: index * 0.2,
                text: category.psyTestResults![index].testResult?.testName ?? '',
                leadingUrl: category.psyTestResults![index].photo,
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

  Widget _hint() {
    return Column(
      children: [
        Expanded(child: Container()),
        Stack(
          children: [
            StadiumContainer(
              margin: EdgeInsets.fromLTRB(SizeHelper.margin, 45.0, SizeHelper.margin, SizeHelper.margin),
              padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HorizontalLine(),
                  CustomText(
                    LocaleKeys.psyTestHint1,
                    margin: EdgeInsets.only(top: SizeHelper.margin),
                    maxLines: 5,
                    alignment: Alignment.center,
                  ),
                  CustomText(LocaleKeys.psyTestHint2,
                      margin: EdgeInsets.only(top: SizeHelper.margin), maxLines: 5, alignment: Alignment.center),
                  CustomText(
                    LocaleKeys.psyTestHint3,
                    margin: EdgeInsets.only(top: SizeHelper.margin, bottom: SizeHelper.margin),
                    maxLines: 5,
                    alignment: Alignment.center,
                  ),
                  HorizontalLine(),
                  CustomText(
                    LocaleKeys.psyTestHint4,
                    margin: EdgeInsets.only(top: SizeHelper.margin),
                    maxLines: 5,
                    alignment: Alignment.center,
                    color: customColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),

            /// Habido assistant image
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Image.asset(Assets.habido_assistant_png, height: 50.0, width: 50.0),
              ),
            ),
          ],
        ),
        Expanded(child: Container()),
        SizedBox(height: 80.0),
      ],
    );
  }
}
