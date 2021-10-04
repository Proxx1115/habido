import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/habit_progress_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/audio_manager.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class HabitSuccessRoute extends StatefulWidget {
  final HabitProgressResponse habitProgressResponse;
  final Color? primaryColor;
  final VoidCallback? callback;

  const HabitSuccessRoute({
    Key? key,
    required this.habitProgressResponse,
    this.primaryColor,
    this.callback,
  }) : super(key: key);

  @override
  _HabitSuccessRouteState createState() => _HabitSuccessRouteState();
}

class _HabitSuccessRouteState extends State<HabitSuccessRoute> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    WidgetsBinding.instance?.addPostFrameCallback((_) => _init());
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background
        Container(color: customColors.primaryBackground),

        CircularRevealAnimation(
          animation: animation,
          centerOffset: Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2),
          child: Stack(
            children: [
              /// Image
              Image.asset(
                Assets.success_background_png,
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),

              /// Body
              CustomScaffold(
                padding: SizeHelper.screenPadding,
                backgroundColor: Colors.transparent,
                onWillPop: () {
                  print('nothing');
                },
                child: Column(
                  children: [
                    Expanded(child: Container()),

                    Column(
                      children: [
                        (widget.habitProgressResponse.rank != null)
                            ?

                            /// Rank up
                            Column(
                                children: [
                                  /// Rank image
                                  if (Func.isNotEmpty(widget.habitProgressResponse.rank?.photo))
                                    CachedNetworkImage(
                                      imageUrl: widget.habitProgressResponse.rank!.photo!,
                                      placeholder: (context, url) => Container(),
                                      errorWidget: (context, url, error) => Container(),
                                      height: 150.0,
                                      fit: BoxFit.fill,
                                    ),

                                  if (Func.isNotEmpty(widget.habitProgressResponse.rank?.name))
                                    CustomText(
                                      widget.habitProgressResponse.rank?.name,
                                      alignment: Alignment.center,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w500,
                                      margin: EdgeInsets.only(top: 25.0),
                                    ),
                                ],
                              )
                            : Stack(
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
                                  Func.isNotEmpty(widget.habitProgressResponse.iconLink)
                                      ? CachedNetworkImage(
                                          imageUrl: widget.habitProgressResponse.iconLink!,
                                          placeholder: (context, url) => Container(),
                                          errorWidget: (context, url, error) => Container(),
                                          height: 28.0,
                                          width: 28.0,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Center(
                                          child: SvgPicture.asset(
                                            Assets.trophy28,
                                            color: customColors.iconWhite,
                                          ),
                                        ),
                                ],
                              ),

                        /// Title
                        _title(),

                        /// Text
                        if (widget.habitProgressResponse.body != null)
                          CustomText(
                            widget.habitProgressResponse.body!,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 25.0),
                          ),
                      ],
                    ),

                    Expanded(child: Container()),

                    /// Button finish
                    CustomButton(
                      text: LocaleKeys.finish,
                      style: CustomButtonStyle.secondary,
                      onPressed: () {
                        Navigator.pop(context);
                        if (widget.callback != null) widget.callback!();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _title() {
    if (widget.habitProgressResponse.rank != null && widget.habitProgressResponse.title != null) {
      return CustomText(
        widget.habitProgressResponse.title,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 7.0),
        fontSize: 17.0,
      );
    } else if (widget.habitProgressResponse.title != null) {
      return CustomText(
        widget.habitProgressResponse.title,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 25.0),
        fontSize: 19.0,
        fontWeight: FontWeight.w500,
        color: widget.primaryColor ?? customColors.primary,
      );
    } else {
      return Container();
    }
  }

  Future<void> _init() async {
    // Show reveal dialog
    if (animationController.status == AnimationStatus.forward ||
        animationController.status == AnimationStatus.completed) {
      animationController.reverse();
    } else {
      animationController.forward();
    }

    // Audio
    if (widget.habitProgressResponse.rank != null) {
      // Rank up
      AudioManager.playAsset(AudioAsset.fanfare);
    } else {
      // Habit finished
      AudioManager.playAsset(AudioAsset.success);
    }
  }
}
