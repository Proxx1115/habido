import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class HelpListItemContainer extends StatelessWidget {
  final VoidCallback? onPressed;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? height;
  final String? leadingImageUrl;
  final String? leadingAsset;
  final Color? leadingColor;
  final Color? leadingBackgroundColor;
  final String title;
  final String? body;
  final String? date;
  final String? suffixAsset;
  final Color? suffixColor;

  const HelpListItemContainer({
    Key? key,
    this.onPressed,
    this.margin,
    this.padding,
    this.borderRadius,
    this.height,
    this.leadingImageUrl,
    this.leadingAsset,
    this.leadingColor,
    this.leadingBackgroundColor,
    required this.title,
    this.body,
    this.date,
    this.suffixAsset,
    this.suffixColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius ?? SizeHelper.borderRadiusOdd,
        child: Container(
          margin: margin,
          padding: padding ?? EdgeInsets.fromLTRB(15.0, 15.0, 20.0, 15.0),
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? SizeHelper.borderRadiusOdd,
            color: customColors.whiteBackground,
          ),
          child: Row(
            children: [
              /// Image
              if (Func.isNotEmpty(leadingImageUrl) || leadingAsset != null)
                Container(
                  margin: EdgeInsets.only(right: 15.0),
                  padding: EdgeInsets.all(10.0),
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
                    color: leadingBackgroundColor ?? customColors.greyBackground,
                  ),
                  child: _leadingImage(),
                ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Title
                    CustomText(
                      title,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                    ),

                    /// Body
                    if (Func.isNotEmpty(body))
                      CustomText(
                        body,
                        fontSize: 13.0,
                        color: customColors.greyText,
                        margin: EdgeInsets.only(top: 5.0),
                      ),
                  ],
                ),
              ),

              /// Arrow
              if (suffixAsset != null)
                SvgPicture.asset(
                  suffixAsset!,
                  color: suffixColor ?? customColors.iconGrey,
                ),

              /// Date
              if (suffixAsset == null && date != null)
                CustomText(
                  Func.toDateStr(Func.toDate(date!)).replaceAll('-', '.'),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 15.0),
                  fontWeight: FontWeight.w500,
                  color: customColors.greyText,
                  fontSize: 13,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leadingImage() {
    if (Func.isNotEmpty(leadingImageUrl)) {
      return CachedNetworkImage(
        imageUrl: leadingImageUrl!,
        fit: BoxFit.fitHeight,
        color: leadingColor,
        width: 20.0,
        height: 20.0,
        placeholder: (context, url) => Container(),
        errorWidget: (context, url, error) => Container(),
      );
    } else if (leadingAsset != null) {
      return SvgPicture.asset(leadingAsset!, color: leadingColor);
    } else {
      return Container();
    }
  }
}
