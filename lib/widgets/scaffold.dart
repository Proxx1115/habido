import 'package:flutter/material.dart';
import 'package:habido_app/widgets/app_bars.dart';

class CustomScaffold extends StatelessWidget {
  final WillPopCallback? onWillPop;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Color backgroundColor;

  // final PreferredSize? appBar;
  final String? appBarTitle;
  final Widget child;

  const CustomScaffold({
    this.onWillPop,
    this.scaffoldKey,
    required this.backgroundColor,
    // this.appBar,
    this.appBarTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (onWillPop != null) {
          onWillPop!();
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        appBar: _appBar(context),
        body: child,
      ),
    );
  }

  _appBar(BuildContext context) {
    if (appBarTitle == null) {
      return AppBarEmpty(context: context);
    } else {
      return CustomAppBar(
        context: context,
        backgroundColor: backgroundColor,
        titleText: appBarTitle,
      );
    }
  }
}
