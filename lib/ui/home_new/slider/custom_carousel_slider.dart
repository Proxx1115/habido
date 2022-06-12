import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/custom_banner.dart';
import 'package:habido_app/utils/deeplink_utils.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/indicatorItem.dart';

import 'carousel_slider_bloc.dart';

class CustomCarouselSlider extends StatefulWidget {
  final double aspectRatio;
  final double sliderHeight;
  final EdgeInsets sliderMargin;
  final EdgeInsets indicatorMargin;

  const CustomCarouselSlider({
    Key? key,
    this.aspectRatio = 2.0,
    required this.sliderHeight,
    this.sliderMargin = const EdgeInsets.only(top: 25.0),
    this.indicatorMargin = const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
  }) : super(key: key);

  @override
  _CustomCarouselSliderState createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  // Size
  double indicatorHeight = 6.0;
  double indicatorWidth = 6.0;

  // UI
  final _carouselSliderBloc = CarSliderBloc();

  // Data
  List<CustomBanner>? _bannerList;

  // Slider - Banners
  CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carouselSliderBloc.add(GetBannersEvent());
  }

  @override
  void dispose() {
    _carouselSliderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider.value(
        value: _carouselSliderBloc,
        child: BlocListener<CarSliderBloc, CarSliderState>(
          listener: _blocListener,
          child: BlocBuilder<CarSliderBloc, CarSliderState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, CarSliderState state) {
    if (state is BannersSuccess) {
      _bannerList = state.bannerList;
    } else if (state is BannersFailed) {
      print('Banners failed');
    }
  }

  Widget _blocBuilder(BuildContext context, CarSliderState state) {
    return Column(
      children: [
        /// Slider
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: customColors.primary,
            ),
            child: CarouselSlider(
              items: [
                if (_bannerList != null && _bannerList!.length > 0)
                  for (var el in _bannerList!)
                    if (Func.isNotEmpty(el.link)) _sliderItem(el),
              ],
              carouselController: _carouselController,
              options: CarouselOptions(
                height: widget.sliderHeight,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 7),
                enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: widget.aspectRatio,
                initialPage: 0,
                pauseAutoPlayOnTouch: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),

        SizedBox(height: 14.5),

        /// Indicator
        (_bannerList != null && _bannerList!.length > 0)
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _bannerList!.map((url) {
                    int index = _bannerList!.indexOf(url);
                    return IndicatorItem(
                      index: index,
                      currentIndex: _currentIndex,
                    );
                  }).toList(),
                ),
              )
            : IndicatorItem(), // Indicator holder
      ],
    );
  }

  Widget _sliderItem(CustomBanner el) {
    return Container(
      child: NoSplashContainer(
        child: InkWell(
          onTap: () {
            if (el.deeplink != null) {
              DeeplinkUtils.launchDeeplink(context, url: el.deeplink);
            }
          },
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: el.link!,
              placeholder: (context, url) => Container(), //CustomLoader(),
              errorWidget: (context, url, error) => Container(),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
