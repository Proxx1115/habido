import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/ui/auth/login_route.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/hero.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  List<String> textList = [LocaleKeys.intro1, LocaleKeys.intro2, LocaleKeys.intro3];
  List<String> assetList = [Assets.intro1, Assets.intro2, Assets.intro3];

  // Button close
  double _btnCloseHeight = 40.0;
  double _btnCloseMargin = 20.0;

  // Text
  double _marginTopText = 0.0;

  @override
  void initState() {
    _marginTopText = _btnCloseHeight + _btnCloseMargin * 2;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors.primary,
      appBar: AppBarEmpty(context: context, brightness: Brightness.dark),
      key: _introKey,
      body: Stack(
        children: [
          /// PageView
          PageView(
            controller: _pageController,
            children: [
              _pageViewItem(0, 'svg'),
              _pageViewItem(1, 'svg'),
              _pageViewItem(2, 'png'),
            ],
          ),

          /// Button - Close
          Align(
            alignment: Alignment.topRight,
            child: ButtonStadium(
              asset: Assets.close,
              margin: EdgeInsets.fromLTRB(0.0, _btnCloseMargin, 35.0, 0.0),
              size: _btnCloseHeight,
              iconColor: customColors.primary,
              onPressed: () {
                _navigateToLogin();
              },
            ),
          ),

          /// Indicator
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(SizeHelper.margin, _marginTopText + 120.0, SizeHelper.margin, SizeHelper.margin),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: assetList.length,
              effect: ExpandingDotsEffect(
                dotHeight: 15,
                dotWidth: 9,
                activeDotColor: customColors.secondaryBackground,
                dotColor: customColors.secondaryBackground.withOpacity(0.3),
                expansionFactor: 1.3,
                radius: 10.0,
                paintStyle: PaintingStyle.fill,
              ),
            ),
          ),

          /// Next
        ],
      ),
    );
  }

  Widget _pageViewItem(int index, String assetType) {
    return Stack(
      children: [
        /// Cover image
        Align(
          alignment: Alignment.bottomCenter,
          child: assetType == 'svg'
              ? SvgPicture.asset(
                  assetList[index],
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                )
              : Image.asset(
                  assetList[index],
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                ),
        ),

        /// Text
        CustomText(
          textList[index],
          alignment: Alignment.topCenter,
          textAlign: TextAlign.center,
          color: customColors.whiteText,
          fontWeight: FontWeight.bold,
          fontSize: 35.0,
          maxLines: 2,
          margin: EdgeInsets.fromLTRB(50.0, _marginTopText, 50.0, 0.0),
        ),
      ],
    );
  }

  void _navigateToLogin() {
    // HeroHelper.navigatePushReplacement(context: context, nextRoute: LoginRoute());

    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
  }
}
