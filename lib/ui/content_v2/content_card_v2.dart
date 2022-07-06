import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/content_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text.dart';

class ContentCardV2 extends StatelessWidget {
  final ContentV2 content;
  const ContentCardV2({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: 500,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.contentV2, arguments: {
            'contentId': content.contentId,
          });
        },
        borderRadius: BorderRadius.circular(15),
        child: Hero(
          tag: Func.toStr(content.contentId),
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: customColors.whiteBackground,
            ),
            child: Row(
              children: [
                /// Cover image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: content.contentPhoto ?? '',
                    fit: BoxFit.fitHeight,
                    height: 80,
                    width: 80.0,
                    placeholder: (context, url) => CustomLoader(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),

                // 174
                // flex: 35, // 105/289
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        /// Title
                        Expanded(
                          child: CustomText(
                            content.title ?? '',
                            maxLines: 2,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: customColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  "Сэтгэл зүй ",
                                  color: customColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                ),
                                CustomText(
                                  " | ${content.readTime} мин ",
                                  color: customColors.primaryText,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                SvgPicture.asset(Assets.eyeContent),
                                SizedBox(width: 3),
                                CustomText(
                                  "${content.view}",
                                  color: customColors.primaryText,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
