import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/app_bars.dart';
import 'package:habido_app/widgets/text.dart';

class IntroRoute extends StatefulWidget {
  @override
  _IntroRouteState createState() => _IntroRouteState();
}

class _IntroRouteState extends State<IntroRoute> {
  // Main
  final _introKey = GlobalKey<ScaffoldState>();

  // PageView
  PageController _pageController = PageController();
  int _currentIndex = 0;
  List<String> titleList = [LocaleKeys.introTitle1, LocaleKeys.introTitle2, LocaleKeys.introTitle3, LocaleKeys.introTitle4];
  List<List> textList = [LocaleKeys.intro1, LocaleKeys.intro2, LocaleKeys.intro3, LocaleKeys.intro4];
  List<String> assetList = [Assets.intro1, Assets.intro2, Assets.intro3, Assets.intro4];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors.primaryBackground,
      appBar: EmptyAppBar(context: context, brightness: Brightness.dark),
      key: _introKey,
      body: Stack(
        children: [
          /// PageView
          PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _currentIndex = value;
              });
              if (value == 4) {
                _navigateToLogin();
              }
            },
            children: [
              _pageViewItem(0, 'svg'),
              _pageViewItem(1, 'png'),
              _pageViewItem(2, 'svg'),
              _pageViewItem(3, 'png'),
              Container(),
            ],
          ),

          /// Indicator
          if (_currentIndex != 4)
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(SizeHelper.margin, MediaQuery.of(context).size.height / 3 - 50, SizeHelper.margin, SizeHelper.margin),
              child: _indicator(_currentIndex),
            ),
        ],
      ),
    );
  }

  Widget _indicator(int currentIndex) {
    return Container(
      width: 150,
      height: 4,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: customColors.primary),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(children: [
        Expanded(child: _indicatorItem(0)),
        Expanded(child: _indicatorItem(1)),
        Expanded(child: _indicatorItem(2)),
        Expanded(child: _indicatorItem(3)),
      ]),
    );
  }

  Widget _indicatorItem(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: _currentIndex == index ? customColors.primary : customColors.primaryBackground,
      ),
    );
  }

  Widget _pageViewItem(int index, String assetType) {
    return Column(
      children: [
        /// Title
        Expanded(
          child: CustomText(
            titleList[index],
            alignment: Alignment.center,
            textAlign: TextAlign.center,
            color: customColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 35.0,
          ),
        ),

        /// Cover image
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: assetType == 'svg'
                ? SvgPicture.asset(
                    assetList[index],
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                  )
                : Image.asset(
                    assetList[index],
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                  ),
          ),
        ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(37.0, 58.0, 37.0, 0.0),
            child: Column(
              children: [
                for (String el in textList[index])
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 9.0,
                        width: 9.0,
                        margin: const EdgeInsets.only(top: 7.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: customColors.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(9.0 / 2),
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          el,
                          alignment: Alignment.topLeft,
                          textAlign: TextAlign.left,
                          color: customColors.primaryText,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                          margin: EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _navigateToLogin() {
    // HeroHelper.navigatePushReplacement(context: context, nextRoute: LoginRoute());

    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login2, (Route<dynamic> route) => false);
  }
}
