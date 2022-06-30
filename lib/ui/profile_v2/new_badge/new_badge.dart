import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class NewBadge extends StatefulWidget {
  const NewBadge({Key? key}) : super(key: key);

  @override
  State<NewBadge> createState() => _NewBadgeState();
}

class _NewBadgeState extends State<NewBadge> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 100,
                  // ),
                  SizedBox(height: ResponsiveFlutter.of(context).hp(10)),
                  // if (Func.isNotEmpty(widget.testInfo.coverPhoto))
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.new_badge_background,
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width,
                        height: ResponsiveFlutter.of(context).hp(40),
                      ),
                      Column(
                        children: [
                          Container(
                            height: ResponsiveFlutter.of(context).hp(20),
                            width: ResponsiveFlutter.of(context).wp(40),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: new CachedNetworkImageProvider("https://habido-test.s3-ap-southeast-1.amazonaws.com/badge/Group+53092.png"),
                                  fit: BoxFit.fitHeight),
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                  height: MediaQuery.of(context).size.height / 38,
                                  width: MediaQuery.of(context).size.width / 10,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(width: 1, color: Color(0xffCCFFF2)),
                                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width / 30)),
                                  margin: EdgeInsets.only(
                                    bottom: ResponsiveFlutter.of(context).fontSize(4.5),
                                    right: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                  child: CustomText(
                                    '1',
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(),
                                  )),
                            ),
                          ),
                          CustomText(
                            "Эрүүл мэнддээ анхаарагч",
                            maxLines: 2,
                            alignment: Alignment.topCenter,
                            fontWeight: FontWeight.w700,
                            color: customColors.primary,
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveFlutter.of(context).hp(10)),
                  CustomText(
                    " Шинэ тэмдэг авлаа",
                    alignment: Alignment.center,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  CustomText(
                    "Баяр хүргэе!",
                    maxLines: 2,
                    alignment: Alignment.topCenter,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
            CustomButton(
              margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
              text: "Болсон",
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
