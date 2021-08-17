import 'package:flutter/material.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars.dart';
import 'package:habido_app/widgets/loaders.dart';

class CustomScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  // final WillPopCallback? onWillPop;
  final VoidCallback? onWillPop;
  final bool loading;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final String? appBarTitle;
  final Widget body;

  const CustomScaffold({
    this.scaffoldKey,
    this.onWillPop,
    this.loading = false,
    this.padding = const EdgeInsets.all(0.0),
    this.backgroundColor,
    this.appBarTitle,
    required this.body,
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
              child: body,
            ),
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    if (appBarTitle == null) {
      return AppBarEmpty(context: context);
    } else {
      return CustomAppBar(
        context,
        backgroundColor: backgroundColor ?? customColors.primaryBackground,
        titleText: appBarTitle,
      );
    }
  }
}
