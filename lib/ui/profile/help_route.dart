import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/scaffold.dart';

class HelpRoute extends StatefulWidget {
  const HelpRoute({Key? key}) : super(key: key);

  @override
  _HelpRouteState createState() => _HelpRouteState();
}

class _HelpRouteState extends State<HelpRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.help,
      child: Column(
        children: [
          /// Санал хүсэлт
          ListItemContainer(
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding, SizeHelper.padding, 0.0),
            height: 70.0,
            leadingAsset: Assets.edit,
            leadingColor: customColors.primary,
            leadingBackgroundColor: customColors.primaryBackground,
            title: LocaleKeys.feedback,
            onPressed: () {
              Navigator.pushNamed(context, Routes.feedback);
            },
          ),

          /// Тусламж
          ListItemContainer(
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding, SizeHelper.padding, 0.0),
            height: 70.0,
            leadingAsset: Assets.question_mark,
            leadingColor: customColors.primary,
            leadingBackgroundColor: customColors.primaryBackground,
            title: LocaleKeys.faq,
            onPressed: () {
              Navigator.pushNamed(context, Routes.faq);
            },
          ),
        ],
      ),
    );
  }
}
