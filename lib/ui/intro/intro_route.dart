import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/txt.dart';
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
  List<String> textList = [CustomText.intro1, CustomText.intro2, CustomText.intro3];
  List<String> assetList = [Assets.intro1, Assets.intro2, Assets.intro2]; // todo test

  // Button close
  double _btnCloseHeight = 40.0;
  double _btnCloseMargin = 35.0;

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
      key: _introKey,
      body: Stack(
        children: [
          /// PageView
          PageView(
            controller: _pageController,
            children: [
              _pageViewItem(0),
              _pageViewItem(1),
              _pageViewItem(2),
            ],
          ),

          /// Button - Close
          Align(
            alignment: Alignment.topRight,
            child: BtnIcon(
              asset: Assets.close,
              margin: EdgeInsets.fromLTRB(0.0, _btnCloseMargin, _btnCloseMargin, 0.0),
              size: _btnCloseHeight,
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
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 15,
                dotWidth: 9,
                activeDotColor: customColors.backgroundWhite,
                dotColor: customColors.backgroundWhite.withOpacity(0.3),
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

  Widget _pageViewItem(int index) {
    return Stack(
      children: [
        /// Cover image
        Align(
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset(assetList[index], fit: BoxFit.fitWidth),
        ),

        /// Text
        Txt(
          textList[index],
          alignment: Alignment.topCenter,
          textAlign: TextAlign.center,
          color: customColors.txtWhite,
          fontWeight: FontWeight.bold,
          fontSize: 35.0,
          maxLines: 3,
          margin: EdgeInsets.fromLTRB(30.0, _marginTopText, 30.0, 0.0),
        ),
      ],
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
  }
}
