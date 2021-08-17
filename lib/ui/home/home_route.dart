import 'package:flutter/material.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/scaffold.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final _homeKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _homeKey,
      padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
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
