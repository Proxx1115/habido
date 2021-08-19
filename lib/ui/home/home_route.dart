import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/home_bloc.dart';
import 'package:habido_app/ui/home/assistant_screen.dart';
import 'package:habido_app/ui/home/content_screen.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

import 'home_screen.dart';
import 'profile_screen.dart';
import 'test_screen.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with SingleTickerProviderStateMixin {
  // UI
  final _homeKey = GlobalKey<ScaffoldState>();

  // Bottom navigation bar
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.homeBloc,
      child: BlocListener<HomeBloc, HomeState>(
        listener: _blocListener,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, HomeState state) {
    if (state is NavigateToPageState) {
      _tabController.index = state.index;
      // _tabController.animateToPage(state.index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (state is SessionExpiredState) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: LocaleKeys.sessionExpired,
          button1Text: LocaleKeys.ok,
          onPressedButton1: () {
            // todo test logout

            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, HomeState state) {
    return CustomScaffold(
      scaffoldKey: _homeKey,
      padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
      onWillPop: () {
        if (_tabController.index == 0) {
          // AuthHelper.showLogoutDialog(context); // todo test
          // todo test logout

        } else {
          BlocManager.homeBloc.add(NavigateToPageEvent(0));
        }
      },
      body: Container(
        padding: EdgeInsets.only(bottom: 15.0),
        child: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            /// Нүүр
            HomeScreen(),

            /// Тест
            TestScreen(),

            /// Туслах
            AssistantScreen(),

            /// Контент
            ContentScreen(),

            /// Профайл
            ProfileScreen(),
          ],
        ),
      ),

      /// Bottom navigation bar
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: customColors.secondaryBackground,
      elevation: 0.0,
      clipBehavior: Clip.none,
      notchMargin: 4.0,
      child: Container(
        height: 55.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _bottomNavigationBarItem(0, Assets.home, LocaleKeys.home),
            _bottomNavigationBarItem(1, Assets.test, LocaleKeys.test),
            _bottomNavigationBarItem(2, Assets.assistant, LocaleKeys.assistant),
            _bottomNavigationBarItem(3, Assets.content, LocaleKeys.content),
            _bottomNavigationBarItem(4, Assets.profile, LocaleKeys.profile),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigationBarItem(int index, String asset, String text) {
    return InkWell(
      onTap: () {
        BlocManager.homeBloc.add(NavigateToPageEvent(index));
        // setState(() {
        //   _tabController.index = index;
        // });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Icon
          SvgPicture.asset(asset, color: customColors.iconGrey),

          /// Text
          CustomText(text, color: customColors.iconGrey, fontSize: 11.0, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}
