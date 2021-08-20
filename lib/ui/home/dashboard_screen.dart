import 'package:flutter/material.dart';
import 'package:habido_app/ui/home/slider/custom_slider.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
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
            CustomText('Dashboard screen'),
            Stack(
              children: [
                Row(
                  children: [
                    /// Calendar
                    //

                    /// Title

                    /// Notification
                    //
                  ],
                ),

                /// Slider
                CustomSlider(margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
