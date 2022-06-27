import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';

class Badge extends StatefulWidget {
  const Badge({Key? key}) : super(key: key);

  @override
  State<Badge> createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 350,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: GridView.builder(
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 5 / 7),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  showCustomDialog(
                    context,
                    child: CustomDialogBody(
                      // buttonText: "Цонхыг хаах",
                      primaryColor: customColors.greyBackground,
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
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://image.similarpng.com/very-thumbnail/2020/08/Yellow-star-on-transparent-background-PNG.png",
                                placeholder: (context, url) => Container(),
                                //CustomLoader(),
                                errorWidget: (context, url, error) =>
                                    Container(),
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
                            fontSize: 15,
                            color: customColors.primary,
                          ),

                          /// Body
                          CustomText(
                            "21 хоног тасралтгүй мэдрэмжээ тэмдэглэх бүрт. Нэг өдөр тасалдахад тэмдэг авах нөхцлийг эхнээс нь тоолж эхэлнэ.  Нэг өдрийн мэдрэмж тэмдэглэл нэг тэмдэгт л хамаарна, олон тэмдэгт давхцуулж тооцохгүй.",
                            maxLines: 10,
                            margin: EdgeInsets.only(bottom: 20.0),
                          ),

                          CustomButton(
                            text: "Хаах",
                            contentColor: customColors.primaryText,
                            backgroundColor: customColors.greyBackground,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                      onPressedButton: () {},
                    ),
                  );
                },
                child: Container(
                    margin: EdgeInsets.all(5),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: new CachedNetworkImageProvider(
                                      "https://static.vecteezy.com/system/resources/previews/001/189/136/original/christmas-decoration-star-png.png"),
                                  fit: BoxFit.fitHeight),
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 40,
                                  width: MediaQuery.of(context).size.width / 11,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Color(0xffCCFFF2)),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width /
                                              30)),
                                  margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height /
                                              30,
                                      left: MediaQuery.of(context).size.width /
                                          100),
                                  child: CustomText(
                                    '6',
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(),
                                  )),
                            ),
                          ),
                        ),
                        CustomText(
                          'Сэтгэл зүйдээ анхаарагч',
                          maxLines: 2,
                          alignment: Alignment.center,
                          fontWeight: FontWeight.w400,
                        )
                      ],
                    )),
              );
            },
          ),
        ),
      ],
    );
  }
}
