import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/indicatorItem.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/video_player/video_player.dart';

class TipRoute extends StatefulWidget {
  const TipRoute({Key? key}) : super(key: key);

  @override
  State<TipRoute> createState() => _TipRouteState();
}

class _TipRouteState extends State<TipRoute> {
  // Main
  final _tipKey = GlobalKey<ScaffoldState>();

  // PageView
  PageController _pageController = PageController();
  int _currentIndex = 0;

  // Testing data
  final String _title = "Чатбот хэрхэн ашиглах вэ?";
  final List _tipData = [
    {
      "subTitle": "Чамтай харилцах болно",
      "text":
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore.st Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore e et dolore. nonumy eirmod tempor invidunt ut labore et dolore.nonumy eirmod tempor invidunt ut labore et doloreet dolore. nonumy eirmod tempor invidunt ut labore et dolore.nonumy eirmod tempor invidunt ut labore et dolore."
    },
    {
      "subTitle": "Чиний сайн найз байх болно",
      "text":
          "Судалгааны баг нь өвөл, зуны улиралд 334 оролцогчдыг нийт 1,838 өдрийн турш даган, хэрэглэсэн бүх хоол хүнс, ундыг жинлэн тодорхойлж, хооллолтын бүртгэлийг олон улсад хүлээн зөвшөөрөгдсөн хоол хүнсний хэрэглээг тодорхойлох арга аргачлалаар үнэлсэн. Судалгааны баг нь дээрх мэдээллийг ашиглан хоол хүнсний хэрэглээг тодорхойлж, хүн амын дундах шимт бодисын дутагдлын тархалтыг тооцон, өвөл, зуны улиралд судалгаанд оролцогчдын өндөр жинг хэмжин, цусан дах зарим шим тэжээл, эрдэс бодисын түвшинг тодорхойлсон. Энэхүү судалгаа нь бүрэн эхээрээ шинжлэх ухааны Nutrients сэтгүүлд 2020 оны 5 сард нийтлэгдсэн."
    },
    {
      "subTitle": "Асуудлыг чинь сонсох болно",
      "text":
          "Эрүүл амьдрахад шаардлагатай шим тэжээлийг хоол хүнснээс өөрийн биед шингээн авах нь эрүүл мэндийн хамгийн чухал хүчин зүйлсийн нэг юм. Чанартай хооллолт гэдэг нь эрүүл, идэвхтэй амьдрахад шаардлагатай төрөл бүрийн шим тэжээлийг хангалттай хэмжээгээр агуулсан олон төрлийн хүнсний бүтээгдэхүүн хэрэглэх, эрүүл мэндэд сөрөг нөлөөтэй хүнсний бүтээгдэхүүний хэт их хэрэглээг хязгаарлахыг хэлнэ. Хүнсний хэрэглээний олон талт болон тэнцвэртэй байдал нь эрүүл хооллолтод чухал ач холбогдолтой"
    },
    {
      "subTitle": "Надад найдаж болно",
      "text":
          "Эрүүл амьдрахад шаардлагатай шим тэжээлийг хоол хүнснээс өөрийн биед шингээн авах нь эрүүл мэндийн хамгийн чухал хүчин зүйлсийн нэг юм. Чанартай хооллолт гэдэг нь эрүүл, идэвхтэй амьдрахад шаардлагатай төрөл бүрийн шим тэжээлийг хангалттай хэмжээгээр агуулсан олон төрлийн хүнсний бүтээгдэхүүн хэрэглэх, эрүүл мэндэд сөрөг нөлөөтэй хүнсний бүтээгдэхүүний хэт их хэрэглээг хязгаарлахыг хэлнэ. Хүнсний хэрэглээний олон талт болон тэнцвэртэй байдал нь эрүүл хооллолтод чухал ач холбогдолтой"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _tipKey,
      appBarTitle: _title,
      backgroundColor: customColors.whiteBackground,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              children: [
                for (var el in _tipData) _tipDetail(el),
              ],
            ),
          ),
          SizedBox(height: SizeHelper.margin),

          /// Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _tipData.length; i++)
                IndicatorItem(
                  index: i,
                  currentIndex: _currentIndex,
                )
            ],
          ),
          SizedBox(height: SizeHelper.margin),
        ],
      ),
    );
  }

  Widget _tipDetail(data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeHelper.padding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.0),

            /// Image
            SvgPicture.asset(
              Assets.instruction_dev,
              height: 422,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 50.0),

            /// Sub Title
            CustomText(
              data["subTitle"], // todo
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
            ),
            SizedBox(height: 10.0),

            /// Text
            CustomText(
              data["text"],
              fontSize: 13.0,
              maxLines: 100,
            ),
          ],
        ),
      ),
    );
  }
}
