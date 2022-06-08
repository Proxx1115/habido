import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';

class Performance extends StatefulWidget {
  const Performance({Key? key}) : super(key: key);

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  List _data = [
    {
      "month": 7,
      "days": [
        {
          "weekDay": 1,
          "process": 4,
        },
        {
          "weekDay": 2,
          "process": 4,
        },
        {
          "weekDay": 3,
          "process": 2,
        },
        {
          "weekDay": 4,
          "process": 5,
        },
        {
          "weekDay": 5,
          "process": 1,
        },
        {
          "weekDay": 6,
          "process": 2,
        },
        {
          "weekDay": 7,
          "process": 5,
        },
        {
          "weekDay": 1,
          "process": 4,
        },
        {
          "weekDay": 2,
          "process": 4,
        },
        {
          "weekDay": 3,
          "process": 2,
        },
        {
          "weekDay": 4,
          "process": 5,
        },
        {
          "weekDay": 5,
          "process": 1,
        },
        {
          "weekDay": 6,
          "process": 2,
        },
        {
          "weekDay": 7,
          "process": 5,
        },
        {
          "weekDay": 1,
          "process": 4,
        },
        {
          "weekDay": 2,
          "process": 4,
        },
        {
          "weekDay": 3,
          "process": 2,
        },
        {
          "weekDay": 4,
          "process": 5,
        },
        {
          "weekDay": 5,
          "process": 1,
        },
        {
          "weekDay": 6,
          "process": 2,
        },
        {
          "weekDay": 7,
          "process": 5,
        },
        {
          "weekDay": 1,
          "process": 4,
        },
        {
          "weekDay": 2,
          "process": 4,
        },
        {
          "weekDay": 3,
          "process": 2,
        },
        {
          "weekDay": 4,
          "process": 5,
        },
        {
          "weekDay": 5,
          "process": 1,
        },
        {
          "weekDay": 6,
          "process": 2,
        },
        {
          "weekDay": 7,
          "process": 5,
        },
      ]
    }
  ];

  List _colorsOpacity = [
    Color(0xff73BBB6).withOpacity(0.2),
    Color(0xff73BBB6).withOpacity(0.4),
    Color(0xff73BBB6).withOpacity(0.6),
    Color(0xff73BBB6).withOpacity(0.8),
    Color(0xff73BBB6),
  ];

  Map _calendar1 = {"color": Color(0xff73BBB6), "text": "Гайхамшиг"};
  Map _calendar2 = {"color": Color(0xff73BBB6).withOpacity(0.8), "text": "Гайхамшиг"};
  Map _calendar3 = {"color": Color(0xff73BBB6).withOpacity(0.6), "text": "Гайхамшиг"};
  Map _calendar4 = {"color": Color(0xff73BBB6).withOpacity(0.4), "text": "Гайхамшиг"};
  Map _calendar5 = {"color": Color(0xff73BBB6).withOpacity(0.2), "text": "Бөглөгүй"};
  List _calendarDesc = [];
  @override
  void initState() {
    _calendarDesc = [_calendar1, _calendar2, _calendar3, _calendar4, _calendar5];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomText(
            LocaleKeys.myProcess,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          SizedBox(height: 15),
          _myProcess(),
          SizedBox(height: 15),
          CustomText(
            LocaleKeys.myFeeling,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          SizedBox(height: 15),
          _myFeeling(),
          SizedBox(height: 15),
          _calender(),
          SizedBox(height: 20),
          InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.bottomRight,
              child: Text(
                "Түүх харах",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: customColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          _feelingLast(),
        ],
      ),
    );
  }

  Widget _myProcess() {
    return Container(
        height: 180,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                height: 1,
                width: double.infinity,
                color: customColors.greyBackground,
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24),
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
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    childAspectRatio: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    children: [
                      _processItem(
                        index: 0,
                        title: "10 дадал",
                        text: 'Нийт төлөвлөсөн',
                      ),
                      _processItem(
                        index: 1,
                        title: "10 дадал",
                        text: 'Нийт төлөвлөсөн',
                      ),
                      _processItem(
                        index: 2,
                        title: "10 дадал",
                        text: 'Нийт төлөвлөсөн',
                      ),
                      _processItem(
                        index: 3,
                        title: "10 дадал",
                        text: 'Нийт төлөвлөсөн',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _processItem({required int index, required String title, required String text}) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/profile/process${index}.svg',
            height: 18,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 10),
          CustomText(
            title,
            fontSize: 11,
            fontWeight: FontWeight.w400,
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

  Widget _myFeeling() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: customColors.primaryButtonDisabledContent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CustomText(
                              "Эерэг",
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              alignment: Alignment.center,
                            ),
                          )),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: customColors.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: CustomText(
                                "Сөрөг",
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    CustomText(
                      "20/30",
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      alignment: Alignment.center,
                    ),
                    CustomText(
                      "Нийт бүртгэсэн ",
                      color: customColors.primary,
                      fontWeight: FontWeight.w500,
                      alignment: Alignment.center,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Гэр бүл",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          "10",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Гэр бүл",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          "10",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Гэр бүл",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          "10",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Гэр бүл",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          "10",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Гэр бүл",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        CustomText(
                          "10",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _feelingLast() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: customColors.greyBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: CachedNetworkImage(
                  imageUrl: "http://assets.stickpng.com/images/61d183263a856e0004c6334a.png",
                  placeholder: (context, url) => Container(),
                  //CustomLoader(),
                  errorWidget: (context, url, error) => Container(),
                  height: 40.0,
                  // width: 40.0,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  CustomText(
                    "Гайхалтай",
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    decoration: BoxDecoration(
                      color: customColors.primaryButtonDisabledContent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CustomText(
                      "Ажил",
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          HorizontalLine(
            color: customColors.primaryButtonDisabledContent,
          ),
          const SizedBox(height: 10),
          CustomText(
            "Таны хэвшүүлэхээр бүртгэсэн бүх цаг үеийн дадлуудаас  зөвхөн өнөөдөр болон маргааш хийгдэх дадлуудын",
            maxLines: 2,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 10),
          CustomText(
            "2022.03.01  15:37",
            color: customColors.cornflowerText,
            fontWeight: FontWeight.w500,
            fontSize: 11,
            alignment: Alignment.bottomRight,
          )
        ],
      ),
    );
  }

  Widget _calender() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 15,
                width: 15,
              ),
              CustomText(
                "4 сар",
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              InkWell(
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

                              /// Body
                              CustomText(
                                "Тухайн өдрийн мэдрэмжийг өнгөөр илтгэн харуулж байгаа юм.",
                                maxLines: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                // margin: EdgeInsets.only(bottom: 20.0),
                              ),
                            CustomText(
                              "Жишээ нь: Тухайн өдөр “Мэдэхгүй ээ”, “Онцгүй байсан” гэх мэтээр тэмдэглэвэл бүдэг өнгөөр, харин аз “Гайхалтай”, “Дажгүй шүү” гэж бүртгэх тусам өнгө нь тодрох юм. ",
                              maxLines: 5,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              // margin: EdgeInsets.only(bottom: 20.0),
                            ),
                            CustomText(
                              "Ингэснээр сарын сүүлээр өөрийн тухайн сарын сэтгэл зүйн байдлаа  ажиглах боломжтой юм.",
                              maxLines: 5,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              // margin: EdgeInsets.only(bottom: 20.0),
                            ),
                            SizedBox(height: 20),
                            // Column(
                            //   children: [],
                            // )
                            for (var i = 0; i < _calendarDesc.length; i++)
                              _dayItemBottomSheet(color: _calendarDesc[i]['color'], text: _calendarDesc[i]['text']),
                            const SizedBox(height: 40),

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
                  child: SvgPicture.asset(Assets.warning_calendar))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                Assets.arrow_back,
                color: customColors.secondaryButtonContent,
                height: 10,
                width: 10,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: [
                      for (var i = 0; i < _data[0]["days"].length; i++) _dayItem(_colorsOpacity[_data[0]["days"][i]["process"] - 1]),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              SvgPicture.asset(
                Assets.arrow_forward,
                color: customColors.secondaryButtonContent,
                height: 10,
                width: 10,
              ),
            ],
          )
        ],
      ),
    );
  }

  _dayItem(Color color) {
    return Container(
      color: color,
      width: 30,
      height: 10,
    );
  }

  _dayItemBottomSheet({required Color color, required String text}) {
    return Container(
      child: Row(
        children: [
          Container(
            color: color,
            width: 30,
            height: 10,
          ),
          SizedBox(width: 10),
          CustomText(
            text,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }
}
