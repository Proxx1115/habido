import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/psy_test_dashboard_bloc.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/psy_test_category_results.dart';
import 'package:habido_app/bloc/psy_test_main_bloc.dart';
import 'package:habido_app/models/psy_test_results.dart';
import 'package:habido_app/models/user_psy_test_result.dart';
import 'package:habido_app/ui/psy_test/psy_test_card.dart';
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
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class PsyUserTestDashboard extends StatefulWidget {
  const PsyUserTestDashboard({Key? key}) : super(key: key);

  @override
  _PsyUserTestDashboardState createState() => _PsyUserTestDashboardState();
}

class _PsyUserTestDashboardState extends State<PsyUserTestDashboard> {
  // UI
  final _psyDashboardKey = GlobalKey<ScaffoldState>();

  // Data
  // List<PsyTestCategoryResults>? _categoryList;
  List<UserPsyTestResult>? _userTests;
  PsyTest? _latestTest;

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
      BlocManager.psyTestDashboardBloc.add(GetPsyUserTestResultsEvent());
    });
  }

  Widget _psyTestResultsWidget() {
    return BlocProvider.value(
      value: BlocManager.psyTestDashboardBloc,
      child: BlocListener<PsyTestDashBoardBloc, PsyTestDashboardState>(
        listener: (context, state) {
          if (state is PsyUserTestResultsSuccess) {
            _userTests = state.response.userPsyTestResults;
            _latestTest = state.response.psyTest;
            if (_userTests == null || _userTests!.isEmpty) {
              _visibleHint = true;
            } else {
              _visibleHint = false;
            }
          }
        },
        child: BlocBuilder<PsyTestDashBoardBloc, PsyTestDashboardState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: SizeHelper.screenPadding,
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  /// Latest test
                  _latestTest != null
                      ? HorizontalPsyTestCard(test: _latestTest!)
                      : Container(),
                  SizedBox(
                    height: 15,
                  ),

                  (_userTests != null && _userTests!.isNotEmpty)
                      ? HorizontalLine()
                      : Container(),

                  (_userTests != null && _userTests!.isNotEmpty)
                      ? SectionTitleText(
                          margin: EdgeInsets.only(top: 30.0, bottom: 25),
                          text: LocaleKeys.myPsyTestResult,
                        )
                      : Container(),

                  /// User test list
                  _visibleHint
                      ? _hint()
                      : ((_userTests != null && _userTests!.isNotEmpty)
                          ? Container(
                              padding: EdgeInsets.fromLTRB(
                                0,
                                0,
                                SizeHelper.margin,
                                SizeHelper.marginBottom,
                              ),
                              child: _expandable(_userTests!),
                            )
                          : Container()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _expandable(List<UserPsyTestResult> userTests) {
    return userTests.length > 0
        ? Column(
            children: [
              for (var el in userTests)
                ListItemContainer(
                  margin: EdgeInsets.only(bottom: 10.0),
                  height: 70.0,
                  leadingImageUrl: el.photo,
                  leadingBackgroundColor:
                      HexColor.fromHex(el.color ?? '#F4F6F8'),
                  title: el.testResult?.testName ?? '',
                  suffixAsset: Assets.arrow_forward,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.psyTestResult,
                        arguments: {
                          'psyTestResult': el.testResult,
                        });
                  },
                ),

              // ExpandableContainer(
              //     isToday: false,
              //     margin: EdgeInsets.only(bottom: 20.0),
              //     title: LocaleKeys.myPsyTestResult,
              //     expandableListItems: List.generate(
              //       userTests.length,
              //       (index) => ExpandableListItem(
              //         delay: index * 0.2,
              //         text: userTests[index].testResult?.testName ?? '',
              //         leadingUrl: userTests[index].photo,
              //         leadingBackgroundColor: (userTests[index].color != null)
              //             ? HexColor.fromHex(userTests[index].color!)
              //             : null,
              //         onPressed: () {
              //           if (userTests[index].testResult != null) {
              //             Navigator.pushNamed(context, Routes.psyTestResult,
              //                 arguments: {
              //                   'psyTestResult': userTests[index].testResult,
              //                 });
              //           }
              //         },
              //       ),
              //     ),
              //   ),
            ],
          )
        : Container();
  }

  Widget _hint() {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        child: Column(
          children: [
            Expanded(child: Container()),
            Stack(
              children: [
                StadiumContainer(
                  margin: EdgeInsets.fromLTRB(SizeHelper.margin, 45.0,
                      SizeHelper.margin, SizeHelper.margin),
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
                          margin: EdgeInsets.only(top: SizeHelper.margin),
                          maxLines: 5,
                          alignment: Alignment.center),
                      CustomText(
                        LocaleKeys.psyTestHint3,
                        margin: EdgeInsets.only(
                            top: SizeHelper.margin, bottom: SizeHelper.margin),
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
                    child: Image.asset(Assets.habido_assistant_png,
                        height: 50.0, width: 50.0),
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            SizedBox(height: 80.0),
          ],
        ),
      ),
    );
  }
}
