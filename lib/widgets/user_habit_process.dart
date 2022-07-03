import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class UserHabitProcessWidget extends StatefulWidget {
  final List? processDataList;

  const UserHabitProcessWidget({
    Key? key,
    this.processDataList,
  }) : super(key: key);

  @override
  State<UserHabitProcessWidget> createState() => _UserHabitProcessWidgetState();
}

class _UserHabitProcessWidgetState extends State<UserHabitProcessWidget> {
  @override
  Widget build(BuildContext context) {
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
                      for (var el in widget.processDataList!)
                        _processItem(
                          image: Assets.calendar2,
                          title: "100 удаа",
                          text: "Амжилттай хэвшүүлсэн",
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _processItem({required String image, required String title, required String text}) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          SvgPicture.asset(
            image,
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
}
