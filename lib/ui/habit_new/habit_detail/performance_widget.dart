import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class PerformanceWidget extends StatelessWidget {
  final int? totalPlans;
  final int? completedPlans;
  final int? skipPlans;
  final int? uncompletedPlans;
  const PerformanceWidget({Key? key, this.totalPlans, this.completedPlans, this.skipPlans, this.uncompletedPlans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: 1,
                width: double.infinity,
                color: customColors.greyBackground,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 24),
                height: double.infinity,
                width: 1,
                color: customColors.greyBackground,
              ),
            ),

            /// gridview
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: GridView.count(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                childAspectRatio: 2,
                crossAxisCount: 2,
                children: [
                  _performanceItem(
                    image: Assets.calendar,
                    title: "$totalPlans",
                    text: LocaleKeys.totalPlans,
                  ),
                  _performanceItem(
                    image: Assets.star_empty,
                    color: customColors.iconFeijoGreen,
                    title: "$completedPlans",
                    text: LocaleKeys.completedPlans,
                  ),
                  _performanceItem(
                    image: Assets.star_half,
                    // color: customColors.iconFeijoGreen,
                    title: "$skipPlans",
                    text: LocaleKeys.skipPlans,
                  ),
                  _performanceItem(
                    image: Assets.clear_circle,
                    title: "$uncompletedPlans",
                    text: LocaleKeys.uncompletedPlans,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _performanceItem({required String image, required String title, required String text, Color? color}) {
    return Container(
      padding: EdgeInsets.only(left: 34.0, top: 12.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            image,
            height: 18,
            fit: BoxFit.contain,
            color: color,
          ),
          SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                title,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(width: 1),
              CustomText(
                LocaleKeys.day,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                // margin: EdgeInsets.only(bottom: 1.2),
              ),
            ],
          ),
          CustomText(
            text,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
