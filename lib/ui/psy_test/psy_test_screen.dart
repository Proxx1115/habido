import 'package:flutter/material.dart';
import 'package:habido_app/ui/home/home_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';

class PsyTestScreen extends StatefulWidget {
  const PsyTestScreen({Key? key}) : super(key: key);

  @override
  _PsyTestScreenState createState() => _PsyTestScreenState();
}

class _PsyTestScreenState extends State<PsyTestScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Calendar, Title, Notification
            HomeAppBar(title: LocaleKeys.test),

            //
          ],
        ),
      ),
      floatingActionButton: ButtonStadium(
        style: ButtonStadiumStyle.Secondary,
        asset: Assets.add,
        onPressed: () {
          Navigator.pushNamed(context, Routes.psyCategories);
        },
      ),
    );
  }
}
