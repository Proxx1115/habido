import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/custom_banner.dart';
import 'package:habido_app/ui/home/slider/slider_bloc.dart';
import 'package:habido_app/utils/deeplink_utils.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers.dart';

class CustomSlider extends StatefulWidget {
  final EdgeInsets? margin;

  const CustomSlider({Key? key, this.margin}) : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  // UI
  final _sliderBloc = SliderBloc();

  // Data
  List<CustomBanner>? _bannerList;

  // Slider - Banners
  CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _sliderBloc.add(GetBannersEvent());
  }

  @override
  void dispose() {
    _sliderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _sliderBloc,
      child: BlocListener<SliderBloc, SliderState>(
        listener: _blocListener,
        child: BlocBuilder<SliderBloc, SliderState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, SliderState state) {
    if (state is BannersSuccess) {
      _bannerList = state.bannerList;
    } else if (state is BannersFailed) {
      print('Banners failed');
    }
  }

  Widget _blocBuilder(BuildContext context, SliderState state) {
    return Container(
      margin: widget.margin,
      child: Column(
        children: [
          /// Slider
          CarouselSlider(
            items: [
              if (_bannerList != null && _bannerList!.length > 0)
                for (var el in _bannerList!)
                  if (Func.isNotEmpty(el.link)) _sliderItem(el),
            ],
            carouselController: _carouselController,
            options: CarouselOptions(
              height: (MediaQuery.of(context).size.width - SizeHelper.margin * 2) / 2,
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 1,
              aspectRatio: 2.0,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),

          /// Indicator
          (_bannerList != null && _bannerList!.length > 0)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _bannerList!.map((url) {
                    int index = _bannerList!.indexOf(url);
                    return _indicatorItem(index: index);
                  }).toList(),
                )
              : _indicatorItem(), // Indicator holder
        ],
      ),
    );
  }

  Widget _sliderItem(CustomBanner el) {
    return NoSplashContainer(
      child: InkWell(
        onTap: () {
          if (el.deeplink != null) {
            DeeplinkUtils.launchDeeplink(context, url: el.deeplink);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: el.link!,
            placeholder: (context, url) => Container(), //CustomLoader(),
            errorWidget: (context, url, error) => Container(),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _indicatorItem({int? index}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
      width: 8.0,
      height: 15.0,
      decoration: (index == null)
          ? null
          : BoxDecoration(
              // shape: BoxShape.circle,
              color: _currentIndex == index ? customColors.secondaryBackground : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(width: 2, color: customColors.secondaryBorder),
            ),
    );
  }
}
