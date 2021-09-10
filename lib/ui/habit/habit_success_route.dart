import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitSuccessRoute extends StatefulWidget {
  final String? title;
  final String? text;
  final Color? primaryColor;
  final VoidCallback? callback;

  const HabitSuccessRoute({
    Key? key,
    this.title,
    this.text,
    this.primaryColor,
    this.callback,
  }) : super(key: key);

  @override
  _HabitSuccessRouteState createState() => _HabitSuccessRouteState();
}

class _HabitSuccessRouteState extends State<HabitSuccessRoute> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background
        SvgPicture.asset(
          Assets.success_background_png,
          fit: BoxFit.fitWidth,
        ),

        /// Body
        CustomScaffold(
          padding: SizeHelper.paddingScreen,
          // backgroundColor: Colors.transparent,
          onWillPop: () {
            print('nothing');
          },
          child: Column(
            children: [
              /// Background
              SvgPicture.asset(
                Assets.success_background_png,
                fit: BoxFit.fitWidth,
              ),

              Expanded(child: Container()),

              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /// Circle
                      Center(
                        child: Opacity(
                          opacity: 0.25,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.primaryColor ?? customColors.primary,
                            ),
                            width: 120.0,
                            height: 120.0,
                            child: Container(),
                          ),
                        ),
                      ),

                      /// Circle
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.primaryColor ?? customColors.primary,
                          ),
                          width: 100.0,
                          height: 100.0,
                          child: Container(),
                        ),
                      ),

                      /// Icon
                      Center(
                        child: SvgPicture.asset(
                          Assets.trophy28,
                          color: customColors.iconWhite,
                        ),
                      ),
                    ],
                  ),

                  /// Title
                  if (widget.title != null)
                    CustomText(
                      widget.title,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 25.0),
                      fontSize: 19.0,
                      fontWeight: FontWeight.w500,
                      color: widget.primaryColor ?? customColors.primary,
                    ),

                  /// Text
                  if (widget.text != null)
                    CustomText(
                      widget.text,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 25.0),
                    ),
                ],
              ),

              Expanded(child: Container()),

              /// Button finish
              CustomButton(
                text: LocaleKeys.finish,
                style: CustomButtonStyle.Secondary,
                onPressed: () {
                  Navigator.pop(context);
                  if (widget.callback != null) widget.callback!();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
