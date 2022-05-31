import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class Performance extends StatefulWidget {
  const Performance({Key? key}) : super(key: key);

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
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

            /// Grid builder
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.transparent,
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: GridView.builder(
            //     itemCount: 4,
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2,
            //         crossAxisSpacing: 8,
            //         mainAxisSpacing: 8,
            //         childAspectRatio: 2),
            //     itemBuilder: (BuildContext context, int index) {
            //       return Expanded(
            //           child: _processItem(
            //         index: index,
            //         title: "10 дадал",
            //         text: 'Нийт төлөвлөсөн',
            //       ));
            //     },
            //   ),
            // ),
          ],
        ));
  }

  Widget _processItem(
      {required int index, required String title, required String text}) {
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
          ),
          CustomText(
            text,
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
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      alignment: Alignment.center,
                    ),
                    CustomText(
                      "Нийт бүртгэсэн ",
                      color: customColors.primary,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Гэр бүл"),
                        CustomText("10"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Гэр бүл"),
                        CustomText("10"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Гэр бүл"),
                        CustomText("10"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Гэр бүл"),
                        CustomText("10"),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
