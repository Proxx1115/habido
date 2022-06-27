import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';

class Ability extends StatefulWidget {
  const Ability({Key? key}) : super(key: key);

  @override
  State<Ability> createState() => _AbilityState();
}

class _AbilityState extends State<Ability> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        _ability(
            AssetName: "assets/images/test/ability.svg",
            title: "Тайван сэтгэл зүй",
            text: "Энэ бол тайлбар гаййййййййккя"),
        _ability(
            AssetName: "assets/images/test/ability.svg",
            title: "Тайван сэтгэл зүй",
            text: "Энэ бол тайлбар гаййййййййккя"),
      ]),
    );
  }

  Widget _ability(
      {required String AssetName,
      required String title,
      required String text}) {
    return InkWell(
      onTap: () {
        showCustomDialog(
          context,
          child: CustomDialogBody(
            buttonText: "Цонхыг хаах",
            child: Column(
              children: [
                /// Image
                // if (Func.isNotEmpty(_notifList[index].photo))
                if (true) //todo yela
                  Container(
                    margin: EdgeInsets.only(right: 15.0),
                    padding: EdgeInsets.all(10.0),
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: customColors.greyBackground,
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://image.similarpng.com/very-thumbnail/2020/08/Yellow-star-on-transparent-background-PNG.png",
                      placeholder: (context, url) => Container(),
                      //CustomLoader(),
                      errorWidget: (context, url, error) => Container(),
                      height: 40.0,
                      // width: 40.0,
                      fit: BoxFit.fitHeight,
                    ),
                  ),

                /// Title
                CustomText(
                  "Тайван сэтгэл зүй",
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  fontWeight: FontWeight.w500,
                  color: customColors.primary,
                ),

                /// Body
                CustomText(
                  "Ашиг тус",
                  margin: EdgeInsets.only(bottom: 20.0),
                ),
                Container(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 20),
                            CustomText(
                              "• Сэтгэлзүйн эрүүл мэнд сайжрах",
                              margin: EdgeInsets.only(bottom: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            CustomText(
                              "• Сэтгэлзүйн эрүүл мэнд сайжрах",
                              margin: EdgeInsets.only(bottom: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            CustomText(
                              "• Сэтгэлзүйн эрүүл мэнд сайжрах",
                              margin: EdgeInsets.only(bottom: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            CustomText(
                              "• Сэтгэлзүйн эрүүл мэнд сайжрах",
                              margin: EdgeInsets.only(bottom: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            CustomText(
                              "• Сэтгэлзүйн эрүүл мэнд сайжрах",
                              margin: EdgeInsets.only(bottom: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            CustomText(
                              "• Сэтгэлзүйн эрүүл мэнд сайжрах",
                              margin: EdgeInsets.only(bottom: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            CustomText(
                              "• Сэтгэлзүйн эрүүл мэнд сайжрах",
                              margin: EdgeInsets.only(bottom: 20.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            CustomText(
                              "• Сэтгэлзүйн эрүүл мэнд сайжрах",
                              margin: EdgeInsets.only(bottom: 20.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            onPressedButton: () {},
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: customColors.greyBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SvgPicture.asset(AssetName),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    CustomText(title),
                    SizedBox(height: 10),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: customColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomText(text),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
