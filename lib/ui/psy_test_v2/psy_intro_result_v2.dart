import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/test.dart';
import 'package:habido_app/models/test_info_result_response.dart';
import 'package:habido_app/ui/home/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/ui/psy_test_v2/psy_intro_route_v2.dart';
import 'package:habido_app/ui/psy_test_v2/psy_result_route_v2.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_bloc_v2/psy_test_bloc_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class PsyIntroResultV2 extends StatefulWidget {
  final Test test;
  const PsyIntroResultV2({Key? key, required this.test}) : super(key: key);

  @override
  State<PsyIntroResultV2> createState() => _PsyIntroResultV2State();
}

class _PsyIntroResultV2State extends State<PsyIntroResultV2> {
  // UI
  final _psyDashboardKey = GlobalKey<ScaffoldState>();

  /// PAGE_VIEW_CONTROLLER
  PageController _pageController = PageController();
  int _currentIndex = 0;

  /// TEST_INFO_RESULT_RESPONSE
  TestInfoResultResponse? _testInfoResultResponse;

  @override
  void initState() {
    BlocManager.psyTestBlocV2.add(GetTestIntrolResultEvent(widget.test.testId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.psyTestBlocV2,
        child: BlocListener<TestsBlocV2, TestsStateV2>(
          listener: _blocListener,
          child: BlocBuilder<TestsBlocV2, TestsStateV2>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, TestsStateV2 state) {
    if (state is TestIntrolResultSuccess) {
      _testInfoResultResponse = state.testInfoResultResponse;
    } else if (state is TestIntrolResultFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, TestsStateV2 state) {
    return _testInfoResultResponse != null
        ? Column(
            children: [
              /// APP BAR
              DashboardAppBar(
                title: LocaleKeys.psyTest,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(SizeHelper.margin, 20.0, SizeHelper.margin, 0.0),
                child: _tab(),
              ),
              SizedBox(height: 20),

              /// PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    PsyIntroRouteV2(testInfo: _testInfoResultResponse!.testInfo!),
                    _testInfoResultResponse!.testResult != null
                        ? PsyTestResultRouteV2(
                            testResult: _testInfoResultResponse?.testResult,
                            testId: widget.test.testId!,
                          )
                        : Container()
                  ],
                  onPageChanged: (value) {
                    _currentIndex = value;
                    setState(() {});
                  },
                ),
              )
            ],
          )
        : Container();
  }

  /// TAB
  Widget _tab() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _tabItem(index: 0, text: "Танилцуулга", flex: 5),
                SizedBox(width: 30),
                // _tabButtonItem(index: 1, text: "Үр дүн", flex: 2)
                // if (_testInfoResultResponse!.testResult != null) _tabButtonItem(index: 1, text: "Үр дүн", flex: 2)
                _testInfoResultResponse!.testResult != null
                    ? _tabItem(index: 1, text: "Үр дүн", flex: 2)
                    : Expanded(
                        flex: 2,
                        child: Container(),
                      ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          )
        ],
      ),
    );
  }

  /// TAB ITEM
  Widget _tabItem({required int index, required String text, required int flex}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          setState(() {
            _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          });
        },
        child: Column(
          children: [
            CustomText(
              text,
              alignment: Alignment.center,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 2),
            Container(
              height: 2,
              decoration: BoxDecoration(
                color: _currentIndex == index ? customColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
