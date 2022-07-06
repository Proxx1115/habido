import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/home_new_bloc.dart';
import 'package:habido_app/bloc/home_new_bloc.dart';
import 'package:habido_app/models/tip%20category.dart';
import 'package:habido_app/models/tip.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/indicatorItem.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/video_player/video_player.dart';

class TipRoute extends StatefulWidget {
  final int? tipCategoryId;
  final String? categoryName;
  const TipRoute({Key? key, this.tipCategoryId, this.categoryName})
      : super(key: key);

  @override
  State<TipRoute> createState() => _TipRouteState();
}

class _TipRouteState extends State<TipRoute> {
  // Main
  final _tipKey = GlobalKey<ScaffoldState>();

  // PageView
  PageController _pageController = PageController();
  int _currentIndex = 0;

  List<Tip>? _tips;

  @override
  void initState() {
    super.initState();
    BlocManager.homeNewBloc.add(GetTipsByIdEvent(widget.tipCategoryId!));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.homeNewBloc,
        child: BlocListener<HomeNewBloc, HomeNewState>(
          listener: _blocListener,
          child: BlocBuilder<HomeNewBloc, HomeNewState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  _blocListener(BuildContext context, HomeNewState state) {
    if (state is TipByIdSuccess) {
      _tips = state.tipData.tips;
    } else if (state is TipByIdFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, HomeNewState state) {
    return CustomScaffold(
      scaffoldKey: _tipKey,
      appBarTitle: widget.categoryName,
      backgroundColor: customColors.whiteBackground,
      child: _tips != null
          ? Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        _currentIndex = value;
                      });
                    },
                    children: [
                      for (Tip el in _tips!) _tipDetail(el),
                    ],
                  ),
                ),
                SizedBox(height: SizeHelper.margin),

                /// Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _tips!.length; i++)
                      IndicatorItem(
                        index: i,
                        currentIndex: _currentIndex,
                      )
                  ],
                ),
                SizedBox(height: SizeHelper.margin),
              ],
            )
          : Container(),
    );
  }

  Widget _tipDetail(Tip tipData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeHelper.padding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: 30.0),

            /// Image
            CachedNetworkImage(
              imageUrl: tipData.link!,
              // placeholder: (context, url) => CustomLoader(context, size: 20.0),
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Container(),
              height: MediaQuery.of(context).size.height * 0.65,
              fit: BoxFit.contain,
              // cacheHeight: 200,
            ),

            SizedBox(height: 50.0),

            /// Title
            CustomText(
              tipData.title,
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
            ),
            SizedBox(height: 10.0),

            /// Description
            CustomText(
              tipData.description,
              fontSize: 13.0,
              maxLines: 100,
            ),
          ],
        ),
      ),
    );
  }
}
