import 'package:flutter/material.dart';
import 'package:habido_app/ui/home/home_app_bar.dart';
import 'package:habido_app/ui/home/slider/custom_slider.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: customColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                /// Slider
                CustomSlider(margin: EdgeInsets.only(top: 30.0)),

                /// Calendar, Title, Notification
                HomeAppBar(title: 'Test'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
