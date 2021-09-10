import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/psy_test_result.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/scaffold.dart';

class PsyTestResultRoute extends StatefulWidget {
  final PsyTestResult psyTestResult;

  const PsyTestResultRoute({Key? key, required this.psyTestResult}) : super(key: key);

  @override
  _PsyTestResultRouteState createState() => _PsyTestResultRouteState();
}

class _PsyTestResultRouteState extends State<PsyTestResultRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: '',
      onWillPop: () {
        Navigator.popUntil(context, ModalRoute.withName(Routes.home));
      },
      body: Container(
        padding: SizeHelper.paddingScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Result
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Stack(
                    children: [
                      /// Info container
                      InfoContainer(
                        margin: EdgeInsets.only(top: 28.0),
                        padding: EdgeInsets.fromLTRB(18.0, 50.0, 18.0, 16.0),
                        title: widget.psyTestResult.testName ?? '',
                        titleAlignment: Alignment.center,
                        body: widget.psyTestResult.text ?? '',
                        footer: widget.psyTestResult.pointRange ?? '',
                      ),

                      /// Icon
                      Align(
                        alignment: Alignment.topCenter,
                        child: _icon(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Button
            CustomButton(
              margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
              text: LocaleKeys.thanksHabido,
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName(Routes.home));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      height: 55.0,
      width: 55.0,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: customColors.primary,
      ),
      child: SvgPicture.asset(Assets.trophy, color: customColors.iconWhite),
    );
  }
}
