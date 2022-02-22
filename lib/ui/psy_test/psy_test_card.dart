import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/models/psy_test_result.dart';
import 'package:habido_app/models/user_psy_test_result.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text.dart';

class VerticalPsyTestCard extends StatelessWidget {
  final PsyTest test;
  final EdgeInsets? margin;
  final double width;
  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(SizeHelper.borderRadius));
  final int duration;

  VerticalPsyTestCard({
    Key? key,
    required this.test,
    required this.width,
    this.margin,
    this.duration = 500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: duration,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          color: customColors.whiteBackground,
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.psyTest, arguments: {
              'test': test,
            });
          },
          borderRadius: _borderRadius,
          child: Hero(
            tag: Func.toStr(test.testId),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    /// Cover image
                    Container(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                        child: CachedNetworkImage(
                          imageUrl: test.coverPhoto ?? '',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          height: width * SizeHelper.contentImageRatio,
                          alignment: Alignment.topCenter,
                          placeholder: (context, url) => CustomLoader(),
                          errorWidget: (context, url, error) => Container(),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  height: 90.0,
                  child: Column(
                    children: [
                      /// Title
                      CustomText(
                        test.name,
                        fontWeight: FontWeight.w500,
                        maxLines: 2,
                      ),

                      /// Body
                      CustomText(test.description, margin: EdgeInsets.only(top: 15.0), maxLines: 2),
                    ],
                  ),
                ),
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
                        child: SvgPicture.asset(Assets.clock),
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

class HorizontalPsyTestCard extends StatelessWidget {
  final PsyTest? test;
  final PsyTestResult? testResult;
  final EdgeInsets? margin;
  final VoidCallback? callback;
  final Color? backgroundColor;

  final BorderRadius _borderRadius = BorderRadius.all(Radius.circular(SizeHelper.borderRadius));
  final double _height = 140.0;

  HorizontalPsyTestCard({
    Key? key,
    required this.test,
    this.testResult,
    this.margin,
    this.callback,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: InkWell(
        onTap: () {
          if (callback != null) callback!();

          testResult == null
              ? Navigator.pushNamed(context, Routes.psyIntro, arguments: {
                  'psyTest': test,
                })
              : Navigator.pushNamed(context, Routes.psyTestResult, arguments: {
                  'psyTestResult': testResult,
                });
        },
        borderRadius: _borderRadius,
        child: Hero(
          tag: Func.toStr(test!.testId),
          child: Container(
            margin: margin,
            height: _height,
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
              color: backgroundColor ?? customColors.whiteBackground,
            ),
            child: Row(
              children: [
                /// Cover image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(10.0)),
                      child: CachedNetworkImage(
                        imageUrl: test!.coverPhoto ?? '',
                        fit: BoxFit.fitHeight,
                        height: _height,
                        // width: MediaQuery.of(context).size.width * 0.3,
                        width: 115.0,
                        placeholder: (context, url) => CustomLoader(),
                        errorWidget: (context, url, error) => Container(),
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                            color: HexColor.fromHex('#fa6c51'),
                          ),
                          height: 30,
                          width: 50,
                          child: CustomText(
                            LocaleKeys.newPsyTest,
                            alignment: Alignment.center,
                            color: Colors.white,
                            fontFamily: FontAsset.FiraSansCondensed,
                            fontWeight: FontWeight.w500,
                          )),
                    )
                  ],
                ),

                // 174
                // flex: 35, // 105/289
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: Column(
                      children: [
                        /// Title
                        CustomText(
                          test!.name,
                          fontWeight: FontWeight.w500,
                          maxLines: 3,
                        ),

                        /// Body
                        Expanded(
                          child: CustomText(test!.description, margin: EdgeInsets.only(top: 15.0), maxLines: 2),
                        ),
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
