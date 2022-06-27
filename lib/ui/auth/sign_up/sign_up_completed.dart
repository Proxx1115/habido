import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/hero.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class SignUpCompletedRoute extends StatelessWidget {
  const SignUpCompletedRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _signUpCompletedKey = GlobalKey<ScaffoldState>();

    return CustomScaffold(
      scaffoldKey: _signUpCompletedKey,
      child: Column(
        children: [
          /// HabiDo logo
          Expanded(
            flex: 1,
            child: HeroHelper.getAppLogoWithName(),
          ),

          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  CustomText(
                    LocaleKeys.signUpCompletedText,
                    fontWeight: FontWeight.w700,
                    fontSize: 25.0,
                    maxLines: 5,
                  ),
                  SizedBox(height: SizeHelper.margin),
                  _thanksBtn(context)
                ],
              ),
            ),
          ),

          Expanded(
            child: Image.asset(
              Assets.sign_up_success,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }

  // _navigateToFirstRoute() {
  //   Navigator.of(context).pushNamedAndRemoveUntil(
  //     Routes.home,
  //     (Route<dynamic> route) => false,
  //   );
  // }

  Widget _thanksBtn(BuildContext context) {
    return Row(children: [
      InkWell(
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.home,
            (Route<dynamic> route) => false,
          );
        },
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          height: 34.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: customColors.primary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              CustomText(
                LocaleKeys.thanksHabiDo,
                color: customColors.primary,
                alignment: Alignment.center,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                fontSize: 13.0,
              ),
              SizedBox(width: 5.0),
              SvgPicture.asset(
                Assets.arrow_right,
                color: customColors.primary,
              )
            ],
          ),
        ),
      ),
      Expanded(child: Container())
    ]);
  }
}
