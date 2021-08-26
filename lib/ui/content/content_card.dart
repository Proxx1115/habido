import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text.dart';

class VerticalContentCard extends StatelessWidget {
  final Content content;
  final VoidCallback? onPressed;
  final double imageHeight;

  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(SizeHelper.borderRadius));

  VerticalContentCard({
    Key? key,
    required this.content,
    this.onPressed,
    required this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: InkWell(
        onTap: onPressed,
        borderRadius: _borderRadius,
        child: Hero(
          tag: Func.toStr(content.contentId),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
              color: customColors.secondaryBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Cover image
                // flex: 45,
                Func.isNotEmpty(content.contentPhoto)
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                            child: CachedNetworkImage(
                              imageUrl: content.contentPhoto!,
                              fit: BoxFit.fitHeight,
                              height: imageHeight,
                              placeholder: (context, url) => CustomLoader(),
                              errorWidget: (context, url, error) => Container(),
                            ),
                          ),
                        ],
                      )
                    : Container(),

                // flex: 35, // 105/289
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10.0, 15.0, 15.0, 0.0),
                    child: Column(
                      children: [
                        /// Title
                        CustomText(
                          content.title,
                          fontWeight: FontWeight.w500,
                          maxLines: 2,
                        ),

                        /// Body
                        CustomText(content.text, margin: EdgeInsets.only(top: 15.0), maxLines: 2),
                      ],
                    ),
                  ),
                ),

                // flex: 20,
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      /// Clock icon
                      Container(
                        height: 24.0,
                        width: 24.0,
                        padding: EdgeInsets.all(5.0),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          color: customColors.greyBackground,
                        ),
                        child: SvgPicture.asset(Assets.clock),
                      ),

                      /// Read time
                      if (content.readTime != null)
                        Expanded(
                          child: CustomText(
                            '${content.readTime} ${LocaleKeys.readMin}',
                            margin: EdgeInsets.only(left: 7.0),
                            alignment: Alignment.bottomLeft,
                          ),
                        ),
                    ],
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

// class HorizontalContent extends StatelessWidget {
//   const HorizontalContent({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeInAnimation(
//       tweenStart: tweenStart,
//       tweenEnd: tweenEnd,
//       delay: delay,
//       child: Align(
//         alignment: alignment,
//         child: NoSplashContainer(
//           child: InkWell(
//             onTap: onTap,
//             child: Container(
//               margin: margin,
//               padding: padding ?? const EdgeInsets.all(10.0),
//               height: height,
//               width: width ?? MediaQuery.of(context).size.width * 0.6,
//               decoration: BoxDecoration(
//                 borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(10.0)),
//                 color: customColors.secondaryBackground,
//               ),
//               child: child,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// Widget _contentItem(Content content) {
//   return ChatContainer(
//     padding: EdgeInsets.zero,
//     width: width,
//     child: Column(
//       children: [
//         /// Image
//         if (Func.isNotEmpty(content.contentPhoto))
//           ClipRRect(
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
//             child: CachedNetworkImage(
//               imageUrl: content.contentPhoto!,
//               fit: BoxFit.fill,
//               width: width,
//               placeholder: (context, url) => Container(
//                 height: width * 0.66,
//                 child: CustomLoader(),
//               ),
//               errorWidget: (context, url, error) => Container(),
//             ),
//           ),
//
//         /// Title
//         CustomText(
//           content.title,
//           margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
//           fontWeight: FontWeight.w500,
//           maxLines: 2,
//         ),
//
//         /// Body
//         CustomText(content.text, margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0), maxLines: 2),
//
//         if (content.readTime != null)
//           Container(
//             margin: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 0.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 /// Clock icon
//                 SvgPicture.asset(Assets.clock),
//
//                 /// Read time
//                 Expanded(
//                   child: CustomText('${content.readTime} ${LocaleKeys.readMin}', margin: EdgeInsets.only(left: 7.0)),
//                 ),
//               ],
//             ),
//           ),
//
//         SizedBox(height: 15.0),
//       ],
//     ),
//   );
// }
