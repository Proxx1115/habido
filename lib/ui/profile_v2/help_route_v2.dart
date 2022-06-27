import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/app_bar_with_profile.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/scaffold.dart';

class HelpRouteV2 extends StatefulWidget {
  const HelpRouteV2({Key? key}) : super(key: key);

  @override
  _HelpRouteV2State createState() => _HelpRouteV2State();
}

class _HelpRouteV2State extends State<HelpRouteV2> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          AppBarWithProfile(
            backIcon: Assets.back,
            text: LocaleKeys.help,
          ),

          /// Санал хүсэлт
          ListItemContainer(
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding,
                SizeHelper.padding, 0.0),
            height: 70.0,
            leadingAsset: Assets.edit,
            leadingColor: customColors.primary,
            leadingBackgroundColor: customColors.primaryBackground,
            title: LocaleKeys.feedback,
            onPressed: () {
              Navigator.pushNamed(context, Routes.feedbackV2);
            },
          ),

          /// Тусламж
          ListItemContainer(
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding,
                SizeHelper.padding, 0.0),
            height: 70.0,
            leadingAsset: Assets.question_mark,
            leadingColor: customColors.primary,
            leadingBackgroundColor: customColors.primaryBackground,
            title: LocaleKeys.faq,
            onPressed: () {
              Navigator.pushNamed(context, Routes.faqV2);
            },
          ),

          /// Үйлчилгээний нөхцөл
          ListItemContainer(
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding,
                SizeHelper.padding, 0.0),
            height: 70.0,
            leadingAsset: Assets.terms,
            leadingColor: customColors.primary,
            leadingBackgroundColor: customColors.primaryBackground,
            title: LocaleKeys.termsOfService,
            onPressed: () {
              Navigator.pushNamed(context, Routes.terms);
            },
          ),
        ],
      ),
    );
  }
}
