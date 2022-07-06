import 'package:flutter/material.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/app_bars.dart';
import 'package:habido_app/widgets/loaders.dart';

class CustomScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  // final WillPopCallback? onWillPop;
  final VoidCallback? onWillPop;
  final bool loading;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final String? appBarTitle;
  final VoidCallback? appBarOnPressedLeading;
  final VoidCallback? onPressedAction;
  final Color? appBarLeadingColor;
  final Color? appBarLeadingBackgroundColor;
  final Widget child;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? actionWidget;

  const CustomScaffold({
    this.scaffoldKey,
    this.onWillPop,
    this.loading = false,
    this.padding = const EdgeInsets.all(0.0),
    this.backgroundColor,
    this.appBarTitle,
    this.appBarOnPressedLeading,
    this.appBarLeadingColor,
    this.appBarLeadingBackgroundColor,
    required this.child,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.actionWidget,
    this.onPressedAction,
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
      child: GestureDetector(
        onTap: () {
          Func.hideKeyboard(context);
        },
        child: BlurLoadingContainer(
          loading: loading,
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: backgroundColor ?? customColors.primaryBackground,
            appBar: _appBar(context),
            body: Container(
              padding: padding,
              child: child,
            ),
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    if (appBarTitle == null) {
      return EmptyAppBar(context: context);
    } else {
      return CustomAppBar(context,
          backgroundColor: backgroundColor ?? customColors.primaryBackground,
          titleText: appBarTitle,
          leadingColor: appBarLeadingColor,
          leadingBackgroundColor: appBarLeadingBackgroundColor,
          onPressedLeading: appBarOnPressedLeading,
          actionWidget: actionWidget,
          onPressedAction: onPressedAction);
    }
  }
}
