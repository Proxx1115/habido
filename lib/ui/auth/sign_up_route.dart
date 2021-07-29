import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/scaffold.dart';

class SignUpRoute extends StatefulWidget {
  @override
  _SignUpRouteState createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  final _signUpKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _signUpKey,
      backgroundColor: customColors.backgroundRoseWhite,
      appBarTitle: 'Test',
      child: Container(),
    );
  }
}
