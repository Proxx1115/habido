/// result
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/ui/psy_test_v2/info_container_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class PsyTestResultRouteV2 extends StatefulWidget {
  const PsyTestResultRouteV2({Key? key}) : super(key: key);

  @override
  _PsyTestResultRouteV2State createState() => _PsyTestResultRouteV2State();
}

class _PsyTestResultRouteV2State extends State<PsyTestResultRouteV2> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      onWillPop: () {
        Navigator.popUntil(context, ModalRoute.withName(Routes.home));
      },
      child: Container(
        // color: Colors.red,
        padding: SizeHelper.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Result
            RoundedCornerListView(
              // padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.padding),
              children: [
                _infoContainerResult(),

                /// Suggest habit
                // if (widget.psyTestResult.habit != null)
                if (true)
                  Column(
                    children: [
                      /// Title
                      SizedBox(height: 25),
                      CustomText(
                        "Танд санал болгож буй дадал",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      SizedBox(height: 25),

                      // SectionTitleText(
                      //   text: LocaleKeys.recommendedHabit,
                      //   margin: EdgeInsets.symmetric(vertical: 30.0),
                      // ),

                      /// Habit item
                      ListItemContainer(
                        margin: EdgeInsets.only(bottom: 15.0),
                        height: 70.0,
                        leadingImageUrl:
                            "https://media.istockphoto.com/photos/driving-on-the-road-picture-id901650488?k=20&m=901650488&s=170667a&w=0&h=OKU2V2SovysOBLPwVlS7tvbiD76vbMDJWW2gJO2QDJo=",
                        title: "Мэдрэмж тэмдэглэл" ?? '',
                        suffixAsset: Assets.arrow_forward,
                        // leadingBackgroundColor:
                        //     (widget.psyTestResult.habit!.color != null)
                        //         ? HexColor.fromHex(
                        //             widget.psyTestResult.habit!.color!)
                        //         : null,
                        // onPressed: () {
                        //   Navigator.popUntil(
                        //       context, ModalRoute.withName(Routes.home));
                        //   Navigator.pushNamed(context, Routes.userHabit,
                        //       arguments: {
                        //         'screenMode': ScreenMode.New,
                        //         'habit': widget.psyTestResult.habit,
                        //         'title': LocaleKeys.createHabit,
                        //       });
                        // },
                      ),
                    ],
                  ),
              ],
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

  Widget _infoContainerResult() {
    return InfoContainerV2(
      title: "Та бол хохирогч төрлийн хүн" ?? '',
      body:
          "Та ерөнхийдөө өөрийн амьдралдаа сэтгэл хангалуун байдаг ч тодорхой өөрчлөлтүүдийг хийж чадвал та улам бүрбаяр жаргалтай амьдрах боломжтой байна. " ??
              '',
      titleAlignment: Alignment.center,
      textColor: customColors.primary,
      child: Row(
        children: [
          CustomText(
            "Үнэлгээ өгөх",
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
          SizedBox(width: 13),
          SvgPicture.asset(
            Assets.star_yellow,
            height: 16,
            width: 16,
          ),
          SizedBox(width: 6.7),
          SvgPicture.asset(
            Assets.star_yellow,
            height: 16,
            width: 16,
          ),
          SizedBox(width: 6.7),
          SvgPicture.asset(
            Assets.star_white,
            height: 16,
            width: 16,
          ),
        ],
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
      child: SvgPicture.asset(Assets.test, color: customColors.iconWhite),
    );
  }
}
