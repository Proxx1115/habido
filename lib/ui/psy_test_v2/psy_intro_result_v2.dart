import 'package:flutter/material.dart';
import 'package:habido_app/ui/home/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/ui/psy_test_v2/psy_intro_route_v2.dart';
import 'package:habido_app/ui/psy_test_v2/psy_result_route_v2.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class PsyIntroResultV2 extends StatefulWidget {
  const PsyIntroResultV2({Key? key}) : super(key: key);

  @override
  State<PsyIntroResultV2> createState() => _PsyIntroResultV2State();
}

class _PsyIntroResultV2State extends State<PsyIntroResultV2> {
  // UI
  final _psyDashboardKey = GlobalKey<ScaffoldState>();

  PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
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
          Container(margin: EdgeInsets.fromLTRB(SizeHelper.margin, 20.0, SizeHelper.margin, 0.0), child: _tabItem()),
          SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                PsyIntroRouteV2(),
                PsyTestResultRouteV2(),
              ],
              onPageChanged: (value) {
                _currentIndex = value;
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _tabItem() {
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
                _tabButtonItem(index: 0, text: "Танилцуулга", flex: 5),
                SizedBox(width: 30),
                _tabButtonItem(index: 1, text: "Үр дүн", flex: 2),
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

  Widget _tabButtonItem({required int index, required String text, required int flex}) {
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
