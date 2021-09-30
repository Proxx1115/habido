import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/text.dart';

class MarginVertical extends StatelessWidget {
  final double height;

  const MarginVertical({Key? key, this.height = SizeHelper.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class MarginHorizontal extends StatelessWidget {
  final double width;

  const MarginHorizontal({Key? key, this.width = SizeHelper.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class HorizontalLine extends StatelessWidget {
  final EdgeInsets? margin;

  const HorizontalLine({Key? key, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: SizeHelper.borderWidth,
      color: customColors.primaryBorder,
    );
  }
}

class NoSplashContainer extends StatelessWidget {
  NoSplashContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: child,
    );
  }
}

class StadiumContainer extends StatelessWidget {
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Widget child;

  const StadiumContainer({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.height,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: InkWell(
        child: Container(
          height: height,
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor ?? customColors.whiteBackground,
            borderRadius: borderRadius ?? BorderRadius.circular(SizeHelper.borderRadius),
          ),
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  final EdgeInsets? margin;
  final double height;

  const CustomDivider({
    Key? key,
    this.margin = const EdgeInsets.symmetric(vertical: 15.0),
    this.height = SizeHelper.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Divider(
        height: height,
        color: customColors.primaryBorder,
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  final String title;
  final Alignment? titleAlignment;
  final String body;
  final String? footer;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const InfoContainer({
    Key? key,
    required this.title,
    this.titleAlignment,
    required this.body,
    this.footer,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      margin: margin,
      padding: padding ?? SizeHelper.boxPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          CustomText(title, fontWeight: FontWeight.w500, maxLines: 2, alignment: titleAlignment),

          /// Divider
          HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

          /// Body
          CustomText(body, maxLines: 200, textAlign: TextAlign.justify),

          /// Divider
          if (footer != null) HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

          /// Footer
          if (footer != null)
            CustomText(
              footer,
              alignment: Alignment.center,
              color: customColors.primary,
              fontWeight: FontWeight.w500,
            ),
        ],
      ),
    );
  }
}

class ChatContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Alignment alignment;
  final double? tweenStart;
  final double? tweenEnd;
  final double? delay;

  const ChatContainer({
    Key? key,
    required this.child,
    this.onTap,
    this.margin = const EdgeInsets.only(bottom: 10.0),
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.alignment = Alignment.centerLeft,
    this.tweenStart,
    this.tweenEnd,
    this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoveInAnimation(
      tweenStart: tweenStart,
      tweenEnd: tweenEnd,
      delay: delay,
      child: Align(
        alignment: alignment,
        child: NoSplashContainer(
          child: InkWell(
            onTap: onTap,
            child: Container(
              margin: margin,
              padding: padding ?? const EdgeInsets.all(10.0),
              height: height,
              width: width ?? MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(10.0)),
                color: customColors.whiteBackground,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class GridItemContainer extends StatelessWidget {
  final String? imageUrl;
  final String? backgroundColor;
  final String? text;
  final VoidCallback? onPressed;

  const GridItemContainer({
    Key? key,
    required this.imageUrl, // 'https://habido-test.s3-ap-southeast-1.amazonaws.com/test-category/3f010def-93c4-425a-bce3-9df854a2f73b.png'
    required this.backgroundColor, // '#EB86BE'
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      padding: EdgeInsets.all(SizeHelper.margin),
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Icon
          if (imageUrl != null)
            Flexible(
              flex: 20,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius)),
                ),
                padding: EdgeInsets.all(10.0),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(),
                  fit: BoxFit.fill,
                ),
              ),
            ),

          SizedBox(height: 15.0),

          /// Text
          if (text != null)
            Flexible(
              flex: 15,
              child: CustomText(
                text,
                fontWeight: FontWeight.w500,
                alignment: Alignment.center,
                maxLines: 2,
              ),
            ),
        ],
      ),
    );
  }

  _getBackgroundColor() {
    if (Func.isNotEmpty(backgroundColor)) {
      return HexColor.fromHex(backgroundColor!);
    } else {
      return customColors.primary;
    }
  }
}

class ListItemContainer extends StatelessWidget {
  final VoidCallback? onPressed;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? height;
  final String? leadingImageUrl;
  final String? leadingAsset;
  final Color? leadingBackgroundColor;
  final String title;
  final String? body;
  final String? suffixAsset;

  const ListItemContainer({
    Key? key,
    this.onPressed,
    this.margin,
    this.padding,
    this.borderRadius,
    this.height,
    this.leadingImageUrl,
    this.leadingAsset,
    this.leadingBackgroundColor,
    required this.title,
    this.body,
    this.suffixAsset,
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
                    CustomText(title, fontWeight: FontWeight.w500),

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
              if (suffixAsset != null) SvgPicture.asset(suffixAsset!),
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
        fit: BoxFit.fitWidth,
        width: 20.0,
        height: 20.0,
        placeholder: (context, url) => Container(),
        errorWidget: (context, url, error) => Container(),
      );
    } else if (leadingAsset != null) {
      return SvgPicture.asset(leadingAsset!);
    } else {
      return Container();
    }
  }
}

class SelectableListItem extends StatelessWidget {
  final EdgeInsets? margin;
  final String? text;
  final bool? isSelected;
  final Function(bool)? onPressed;

  const SelectableListItem({
    Key? key,
    this.margin,
    this.text,
    this.isSelected,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      height: SizeHelper.boxHeight,
      decoration: BoxDecoration(
        borderRadius: SizeHelper.borderRadiusOdd,
        color: customColors.whiteBackground,
      ),
      child: InkWell(
        borderRadius: SizeHelper.borderRadiusOdd,
        onTap: () {
          if (onPressed != null) {
            bool value = !(isSelected ?? false);
            onPressed!(value);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Text
            Expanded(child: CustomText(text)),

            /// Icon
            SvgPicture.asset(
              Assets.circle_check,
              color: (isSelected ?? false) ? customColors.primary : customColors.iconGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedCornerListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;

  const RoundedCornerListView({Key? key, required this.children, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          child: ListView(
            children: children,
          ),
        ),
      ),
    );
  }
}
