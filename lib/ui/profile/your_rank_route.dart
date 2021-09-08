import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_bloc.dart';
import 'package:habido_app/models/rank.dart';
import 'package:habido_app/utils/assets.dart';
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
  final PageController _pageController = PageController(initialPage: 0, viewportFraction: 0.2);
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
                        SvgPicture.asset(
                          Assets.rank_background2,
                          fit: BoxFit.fitWidth,
                        ),

                        Container(
                          // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),

                              /// Page view
                              Expanded(
                                flex: 2,
                                child: PageView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                  children: <Widget>[
                                    for (var el in _rankList!) _pageViewItem(el),
                                  ],
                                ),
                              ),

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
    }
  }

  Widget _pageViewItem(Rank rank) {
    return CachedNetworkImage(
      imageUrl: rank.photo!,
      width: 115.0,
      height: 125.0,
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => Container(),
    );
  }
}
