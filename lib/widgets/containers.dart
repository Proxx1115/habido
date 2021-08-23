import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/text.dart';
import 'loaders.dart';

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
  final Widget child;

  const StadiumContainer({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.height,
    this.onTap,
    required this.child,
    this.backgroundColor,
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
            color: backgroundColor ?? customColors.secondaryBackground,
            borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
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
    this.height = 1.0,
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
  final String body;

  const InfoContainer({Key? key, required this.title, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      padding: SizeHelper.boxPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          CustomText(title, fontWeight: FontWeight.w500),

          /// Divider
          CustomDivider(),

          /// Body
          CustomText(body, maxLines: 100),
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
                color: customColors.secondaryBackground,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final String? imageUrl;
  final String? backgroundColor;
  final String? text;
  final VoidCallback? onPressed;

  const CategoryContainer({
    Key? key,
    required this.imageUrl,
    required this.backgroundColor,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StadiumContainer(
      padding: EdgeInsets.all(SizeHelper.margin),
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Icon
          if (imageUrl != null)
            Flexible(
              flex: 2,
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
              flex: 1,
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
