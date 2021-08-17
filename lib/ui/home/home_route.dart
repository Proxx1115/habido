import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/home_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

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
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
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
      // showCustomDialog(
      //   context,
      //   dialogType: DialogType.warning,
      //   bodyText: AppText.loginExpired,
      //   btnPositiveText: AppText.ok,
      //   onPressedBtnPositive: () {
      //     Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
      //   },
      // );

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
          BlocProvider.of<HomeBloc>(context).add(NavigateToPageEvent(0));
        }
      },
      body: Column(
        children: [
          // /// Та өөрийн утасны дугаараа оруулна уу.
          // CustomText(LocaleKeys.enterPhoneNumber, alignment: Alignment.center, maxLines: 2),
          //
          // /// Утасны дугаар
          // _phoneNumberTextField(),
          //
          // Spacer(),
          //
          // /// Button next
          // _buttonNext(),
        ],
      ),
    );
  }
}
