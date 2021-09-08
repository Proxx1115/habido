import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_bloc.dart';
import 'package:habido_app/models/rank.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class YourRankRoute extends StatefulWidget {
  const YourRankRoute({Key? key}) : super(key: key);

  @override
  _YourRankRouteState createState() => _YourRankRouteState();
}

class _YourRankRouteState extends State<YourRankRoute> {
  // Page view
  CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  //
  List<Rank>? _rankList;

  @override
  void initState() {
    BlocManager.userBloc.add(GetRankList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.yourRank,
      body: BlocProvider.value(
        value: BlocManager.userBloc,
        child: BlocListener<UserBloc, UserState>(
          listener: _blocListener,
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              // return (globals.userData != null && globals.userData!.rankId != null)
              return (_rankList != null && _rankList!.isNotEmpty)
                  ? Stack(
                      children: [
                        /// Background
                        // todo test
                        // SvgPicture.asset(
                        //   Assets.rank_background2,
                        //   fit: BoxFit.fitWidth,
                        // ),

                        Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),

                            // todo test zoom
                            CarouselSlider(
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                  // autoPlay: true,
                                  aspectRatio: 2.0,
                                  enlargeCenterPage: true,
                                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                                  viewportFraction: 0.4,
                                  onPageChanged: (index, asd) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  }),
                              items: [
                                for (var el in _rankList!) _pageViewItem(el),
                              ],
                            ),

                            /// Medal slider
                            // Expanded(
                            //   flex: 2,
                            //   child: CarouselSlider(
                            //     items: [
                            //       for (var el in _rankList!) _pageViewItem(el),
                            //     ],
                            //     carouselController: _carouselController,
                            //     options: CarouselOptions(
                            //       aspectRatio: 2.0,
                            //       enlargeCenterPage: true,
                            //       enlargeStrategy: CenterPageEnlargeStrategy.height,
                            //       viewportFraction: 0.5,
                            //       // height: 125,
                            //       // autoPlay: false,
                            //       // enlargeCenterPage: true,
                            //       // viewportFraction: 0.8,
                            //       // aspectRatio: 2.0,
                            //       // // enlargeCenterPage: true,
                            //       // // aspectRatio: 1,
                            //       // initialPage: 0,
                            //       onPageChanged: (index, reason) {
                            //         setState(() {
                            //           _currentIndex = index;
                            //         });
                            //       },
                            //     ),
                            //   ),
                            // ),

                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  /// Rank
                                  CustomText(
                                    _rankList![_currentIndex].name,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19.0,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(vertical: 25.0),
                                  ),

                                  /// Text
                                  CustomText(
                                    _rankList![_currentIndex].body,
                                    alignment: Alignment.center,
                                    maxLines: 5,
                                    margin: EdgeInsets.symmetric(horizontal: 60.0),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Container(),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container();
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserState state) {
    if (state is RankListSuccess) {
      _rankList = state.rankList;

      if (_rankList != null) {
        for (int i = 0; i < _rankList!.length; i++) {
          if (_rankList![i].rankId == globals.userData?.rankId) {
            if (_currentIndex != i) {
              _currentIndex = i;
              Future.delayed(Duration(milliseconds: 100), () {
                BlocManager.userBloc.add(NavigateRankEvent(3));
              });
            }
          }
        }
      }
    } else if (state is RankListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
          asset: Assets.error,
          text: state.message,
          buttonText: LocaleKeys.ok,
          onPressedButton: () {
            Navigator.pop(context);
          },
        ),
      );
    } else if (state is NavigateRankState) {
      _carouselController.animateToPage(state.index);
    }
  }

  Widget _pageViewItem(Rank rank) {
    return CachedNetworkImage(
      imageUrl: rank.photo!,
      fit: BoxFit.fitWidth,
      width: 115.0,
      height: 125.0,
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => Container(),
    );
  }
}
