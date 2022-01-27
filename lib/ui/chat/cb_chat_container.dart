import 'package:flutter/material.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class CBChatContainer extends StatelessWidget {
  final String? prefixAsset;
  final Widget child;
  final String? suffixTime;
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
  final int? color;

  const CBChatContainer({
    Key? key,
    this.prefixAsset,
    required this.child,
    this.suffixTime,
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
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoveInAnimation(
      tweenStart: tweenStart,
      tweenEnd: tweenEnd,
      isAxisHorizontal: false,
      delay: delay,
      child: Align(
        alignment: alignment,
        child: NoSplashContainer(
          child: InkWell(
            onTap: onTap,
            child: Container(
              margin: margin,
              child: Func.isNotEmpty(prefixAsset)
                  ? Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// Bot profile pic
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: EdgeInsets.only(right: 5.0),
                            child: Image.asset(
                              prefixAsset!,
                              height: 20.0,
                              width: 20.0,
                              alignment: Alignment.bottomLeft,
                            ),
                          ),
                        ),

                        /// Body
                        _body(context),

                        if (Func.isNotEmpty(suffixTime))
                          CustomText(
                            suffixTime,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 10.0),
                            fontSize: 13.0,
                            color: customColors.greyText,
                          ),
                      ],
                    )
                  : _body(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(10.0),
      width: width ?? MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(10.0)),
        color: _getColor(),
      ),
      child: child,
    );
  }

  _getColor() {
    switch (color) {
      case 1:
        return HexColor.fromHex('#F4F6F8');
      case 2:
        return HexColor.fromHex('#FA6C51');
      default:
        return Colors.white;
    }
  }
}
