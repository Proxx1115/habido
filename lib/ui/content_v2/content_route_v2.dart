import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class ContentRouteV2 extends StatefulWidget {
  const ContentRouteV2({Key? key}) : super(key: key);

  @override
  State<ContentRouteV2> createState() => _ContentRouteV2State();
}

class _ContentRouteV2State extends State<ContentRouteV2> {
  late ScrollController _scrollController;

  String title = 'Зөвлөмж';
  double _scrollPosition = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    _scrollPosition = _scrollController.position.pixels;
    if (_scrollPosition > 30) {
      title = "Бие хүний онцлог MBTI";
    } else {
      title = "Зөвлөмж";
    }
    setState(() {});
  }
  // _scrollListener() {
  //   if (_controller.offset >= _controller.position.maxScrollExtent &&
  //       !_controller.position.outOfRange) {
  //     setState(() {
  //       message = "reach the bottom";
  //     });
  //   }
  //   if (_controller.offset <= _controller.position.minScrollExtent &&
  //       !_controller.position.outOfRange) {
  //     setState(() {
  //       message = "reach the top";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      Assets.arrow_back,
                      fit: BoxFit.scaleDown,
                      color: customColors.iconGrey,
                      height: 15,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomText(
                    title,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return _init();
                },
              ),
            ),
          ],
        ));
  }

  Widget _init() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 15),

          /// Title
          CustomText(
            'Бие хүний онцлог MBTI',
            fontWeight: FontWeight.w600,
            maxLines: 2,
            fontSize: 19,
            color: customColors.primaryText,
          ),
          SizedBox(height: 10),

          /// Cover image
          Hero(
            tag: Func.toStr(1),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
              child: CachedNetworkImage(
                imageUrl: "https://pbs.twimg.com/media/FSLNXAZX0AA6RlL.jpg",
                fit: BoxFit.fitWidth,
                width: double.infinity,
                height: 175,
                // height: _imageWidth! * SizeHelper.contentImageRatio,
                alignment: Alignment.topCenter,
                placeholder: (context, url) => CustomLoader(),
                errorWidget: (context, url, error) => Container(),
              ),
            ),
          ),

          /// Text
          FadeInAnimation(
            delay: 1.5,
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              // padding: SizeHelper.boxPadding,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "Нийтэлсэн: ${'2022.03.01  17:00'}",
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: customColors.lightText,
                      ),
                      Row(
                        children: [
                          CustomText(
                            "Сэтгэл зүй",
                            maxLines: 2,
                            fontSize: 11,
                            color: customColors.primary,
                            fontWeight: FontWeight.w300,
                          ),
                          CustomText(
                            " |  2 мин",
                            maxLines: 2,
                            fontSize: 11,
                            color: customColors.primaryText,
                            fontWeight: FontWeight.w300,
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: customColors.greyBackground,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),

                  /// Body
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Html(
                        shrinkWrap: true,
                        style: {
                          'html': Style(
                            textAlign: TextAlign.justify,
                          ),
                        },
                        data:
                            "<pre><strong>Lorem Ipsum</strong>&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer when an unknown printer when an unknown printer when an unknown printer when an unknown printer when an unknown  when an unknown printer when an unknown printer when an unknown printer when an unknown printer when an unknown printer when an unknown printer when an unknown printer printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</pre>"),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(Assets.heart),
                      Row(
                        children: [
                          CustomText(
                            "Нийтэлсэн: ${'2022.03.01  17:00'}",
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: customColors.lightText,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 34),
        ],
      ),
    );
  }
}
