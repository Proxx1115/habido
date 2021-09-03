import 'package:flutter/material.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/scaffold.dart';

class UserInfoRoute extends StatefulWidget {
  const UserInfoRoute({Key? key}) : super(key: key);

  @override
  _UserInfoRouteState createState() => _UserInfoRouteState();
}

class _UserInfoRouteState extends State<UserInfoRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.userInfo,
      body: SingleChildScrollView(
        padding: SizeHelper.paddingScreen,
        child: Column(
          children: [
            //
          ],
        ),
      ),
    );
  }
}
