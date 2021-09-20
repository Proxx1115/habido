import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/home_bloc.dart';
import 'package:habido_app/models/chat_type.dart';
import 'package:habido_app/ui/chat/chat_screen.dart';
import 'package:habido_app/ui/chat/chatbot_dashboard.dart';
import 'package:habido_app/ui/content/content_dashboard.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';
import 'dashboard/dashboard_screen.dart';
import '../profile/profile_dashboard.dart';
import '../psy_test/psy_test_dashboard/psy_test_dashboard.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with SingleTickerProviderStateMixin {
  // UI
  final _homeKey = GlobalKey<ScaffoldState>();

  // Bottom navigation bar
  late TabController _tabController;
  double? _navBarItemWidth;

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
    }
  }

  Widget _blocBuilder(BuildContext context, HomeState state) {
    return WillPopScope(
      onWillPop: () {
        if (_tabController.index == 0) {
          AuthBloc.showLogoutDialog(context);
        } else {
          BlocManager.homeBloc.add(NavigateToPageEvent(0));
        }

        return Future.value(false);
      },
      child: Scaffold(
        key: _homeKey,
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            /// Нүүр
            DashboardScreen(),

            /// Тест
            PsyTestDashboard(),

            /// Туслах
            ChatbotDashboard(),

            /// Контент
            ContentDashboard(),

            /// Профайл
            ProfileScreen(),
          ],
        ),

        /// Bottom navigation bar
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: customColors.secondaryBackground,
      elevation: 0.0,
      clipBehavior: Clip.none,
      notchMargin: 4.0,
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
    );
  }

  Widget _bottomNavigationBarItem(int index, String asset, String text) {
    _navBarItemWidth = _navBarItemWidth ?? (MediaQuery.of(context).size.width) / 5;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        onTap: () {
          BlocManager.homeBloc.add(NavigateToPageEvent(index));
        },
        child: Container(
          height: 55.0,
          width: _navBarItemWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Icon
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: SvgPicture.asset(
                  asset,
                  color: _tabController.index == index ? customColors.primary : customColors.iconGrey,
                ),
              ),

              /// Text
              CustomText(
                text,
                padding: EdgeInsets.only(top: 5.0),
                alignment: Alignment.center,
                color: _tabController.index == index ? customColors.primary : customColors.iconGrey,
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
