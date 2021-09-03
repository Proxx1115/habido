import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class RankWidget extends StatefulWidget {
  const RankWidget({Key? key}) : super(key: key);

  @override
  _RankWidgetState createState() => _RankWidgetState();
}

class _RankWidgetState extends State<RankWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.userBloc,
      child: BlocListener<UserBloc, UserState>(
        listener: _blocListener,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return (globals.userData != null && globals.userData!.rankId != null)
                ? StadiumContainer(
                    borderRadius: SizeHelper.borderRadiusOdd,
                    padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.padding),
                    child: Stack(
                      children: [
                        /// Background
                        if (Func.isNotEmpty(globals.userData!.rankPhoto))
                          Positioned(
                            top: 0,
                            child: Opacity(
                              opacity: 0.3,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    // BoxShadow(
                                    //   color: Colors.red,
                                    //   spreadRadius: -100.0,
                                    //   blurRadius: 100.0,
                                    // ),
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  Assets.rank_background,
                                ),
                              ),
                            ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //       // boxShadow: [
                            //       //   BoxShadow(
                            //       //     color: Colors.transparent,
                            //       //   ),
                            //       //   BoxShadow(
                            //       //     color: Colors.blue,
                            //       //     spreadRadius: -12.0,
                            //       //     blurRadius: 12.0,
                            //       //   ),
                            //       // ],
                            //       ),
                            //   child: ,
                            // ),
                          ),

                        Container(
                          padding: EdgeInsets.only(top: SizeHelper.padding),
                          child: Column(
                            children: [
                              /// Rank image
                              if (Func.isNotEmpty(globals.userData!.rankPhoto))
                                CachedNetworkImage(
                                  imageUrl: globals.userData!.rankPhoto!,
                                  fit: BoxFit.fitWidth,
                                  width: 115.0,
                                  placeholder: (context, url) => Container(),
                                  errorWidget: (context, url, error) => Container(),
                                ),

                              /// Rank name
                              if (Func.isNotEmpty(globals.userData!.rankName))
                                CustomText(
                                  globals.userData!.rankName,
                                  margin: EdgeInsets.only(top: 15.0),
                                  alignment: Alignment.center,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w500,
                                ),

                              /// Rank name
                              if (Func.isNotEmpty(globals.userData!.rankBody))
                                Container(
                                  margin: EdgeInsets.only(top: 15.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    color: customColors.primaryBackground,
                                  ),
                                  child: CustomText(
                                    globals.userData!.rankBody,
                                    alignment: Alignment.center,
                                    maxLines: 5,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        /// Next button
                        Positioned(
                          top: 15.0,
                          right: 0,
                          child: ButtonStadium(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.yourRank);
                            },
                            size: 40.0,
                            backgroundColor: customColors.primaryBackground,
                            asset: Assets.arrow_forward,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container();
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserState state) {
    if (state is UserDataSuccess) {
      print('');
    }
  }
}