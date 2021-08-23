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
import 'package:habido_app/widgets/text.dart';

class VerticalContent extends StatelessWidget {
  final Content content;
  final VoidCallback? onPressed;
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(SizeHelper.borderRadius));

  VerticalContent({
    Key? key,
    required this.content,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: InkWell(
        onTap: onPressed,
        borderRadius: _borderRadius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            color: customColors.secondaryBackground,
          ),
          child: Column(
            children: [
              /// Image
              if (Func.isNotEmpty(content.contentPhoto))
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                  child: CachedNetworkImage(
                    imageUrl: content.contentPhoto!,
                    fit: BoxFit.fill,
                    // width: double.infinity,
                    placeholder: (context, url) => Container(
                        // height: width * 0.66,
                        // child: CustomLoader(),
                        ),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),

              /// Title
              CustomText(
                content.title,
                margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                fontWeight: FontWeight.w500,
                maxLines: 2,
              ),

              /// Body
              CustomText(content.text, margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0), maxLines: 2),

              if (content.readTime != null)
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Clock icon
                      Container(
                        child: SvgPicture.asset(Assets.clock),
                      ),

                      /// Read time
                      Expanded(
                        child: CustomText('${content.readTime} ${LocaleKeys.readMin}', margin: EdgeInsets.only(left: 7.0)),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 15.0),
            ],
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
