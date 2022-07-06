import 'package:flutter/material.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/ui/profile_v2/help_screen/help_container/help_list_item_container.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/app_bars/app_bar_with_profile.dart';
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
      appBarTitle: LocaleKeys.help,
      child: Column(
        children: [
          // AppBarWithProfile(
          //   backIcon: Assets.back,
          //   text: LocaleKeys.help,
          // ),

          /// Санал хүсэлт
          HelpListItemContainer(
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding,
                SizeHelper.padding, 0.0),
            height: 70.0,
            leadingAsset: Assets.edit,
            leadingColor: customColors.primary,
            leadingBackgroundColor: customColors.whiteBackground,
            title: LocaleKeys.feedback,
            onPressed: () {
              Navigator.pushNamed(context, Routes.feedbackV2);
            },
          ),

          /// Тусламж
          HelpListItemContainer(
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding,
                SizeHelper.padding, 0.0),
            height: 70.0,
            leadingAsset: Assets.question_mark,
            leadingColor: customColors.primary,
            leadingBackgroundColor: customColors.whiteBackground,
            title: LocaleKeys.faq,
            onPressed: () {
              Navigator.pushNamed(context, Routes.faqV2);
            },
          ),

          /// Үйлчилгээний нөхцөл
          HelpListItemContainer(
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding,
                SizeHelper.padding, 0.0),
            height: 70.0,
            leadingAsset: Assets.terms,
            leadingColor: customColors.primary,
            leadingBackgroundColor: customColors.whiteBackground,
            title: LocaleKeys.termsOfService,
            onPressed: () {
              Navigator.pushNamed(context, Routes.terms);
            },
          ),

          /// Үйлчилгээний нөхцөл
          HelpListItemContainer(
            margin: EdgeInsets.fromLTRB(SizeHelper.padding, SizeHelper.padding,
                SizeHelper.padding, 0.0),
            height: 70.0,
            leadingAsset: Assets.profile_exit,
            leadingColor: customColors.primary,
            leadingBackgroundColor: customColors.whiteBackground,
            title: LocaleKeys.exit,
            onPressed: () {
              AuthBloc.showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
