import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/dashboard_sliver_app_bar.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class ContentDashboardV2 extends StatefulWidget {
  const ContentDashboardV2({Key? key}) : super(key: key);

  @override
  State<ContentDashboardV2> createState() => _ContentDashboardV2State();
}

class _ContentDashboardV2State extends State<ContentDashboardV2> {
  // Search bar
  final _searchController = TextEditingController();
  List _contentTagName = [
    "Танд",
    "Сэтгэл зүй",
    "Хувийн хөгжил",
    "Эрүүл мэнд",
  ];
  String _selectedMenu = "Танд";

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        /// App bar
        // DashboardSliverAppBar(title: LocaleKeys.advice),

        /// Search
        _searchBar(),
        SliverToBoxAdapter(
          child: _tagList(),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              CustomText(
                "Онцлох",
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: customColors.primaryText,
              ),
              SizedBox(height: 10),
              _contentColumn(),
              _contentColumn(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tagList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(left: 15),
        child: Row(
          children: [for (var el in _contentTagName) _tagItem(el)],
        ),
      ),
    );
  }

  _tagItem(String text) {
    bool _selected = text == _selectedMenu;

    return InkWell(
      onTap: () {
        _selectedMenu = text;
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: _selected ? customColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: CustomText(
          text,
          color: _selected ? Colors.white : customColors.primaryText,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _contentColumn() {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(context, Routes.contentV2);
      },
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
              ),
              child: SvgPicture.asset(
                Assets.intro1,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    CustomText(
                      "Бидний харилцаа хэр удаан үргэлжлэх үргэлжлэх вэ? ",
                      maxLines: 2,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: customColors.primaryText,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              "Сэтгэл зүй ",
                              color: customColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            ),
                            CustomText(
                              " | ${"2 мин"} ",
                              color: customColors.primaryText,
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            SvgPicture.asset(Assets.eyeContent),
                            SizedBox(width: 3),
                            CustomText(
                              "100",
                              color: customColors.primaryText,
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return SliverAppBar(
      pinned: true,
      snap: true,
      floating: true,
      expandedHeight: 70.0,
      collapsedHeight: 70.0,
      backgroundColor: customColors.primaryBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Container(
        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: CustomTextField(
          controller: _searchController,
          hintText: LocaleKeys.search2,
          // suffixAsset: Assets.edit,
          prefixAsset: Assets.search,
        ),
      ),
    );
  }
}
