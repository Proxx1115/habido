import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/content_tag_v2.dart';
import 'package:habido_app/models/content_v2.dart';
import 'package:habido_app/ui/content_v2/content_bloc_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/dashboard_sliver_app_bar.dart';
import 'package:habido_app/widgets/dialogs.dart';
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

  late ContentBlocV2 _contentBlocV2;

  // Tags
  List<ContentTagV2> _tagList = [];

  List<ContentTagV2> _tagList2 = [];

  // Content
  List<ContentV2>? _contentList;
  List<Content>? _filteredContentList;

  @override
  void initState() {
    // Search
    // _searchController.addListener(() => _filter());

    // Data
    _contentBlocV2 = ContentBlocV2();
    _contentBlocV2.add(GetContentListEventV2());
    super.initState();
  }

  @override
  void dispose() {
    _contentBlocV2.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: _contentBlocV2,
        child: BlocListener<ContentBlocV2, ContentStateV2>(
          listener: _blocListener,
          child: BlocBuilder<ContentBlocV2, ContentStateV2>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  /// App bar
                  // DashboardSliverAppBar(title: LocaleKeys.advice),

                  /// Search
                  _searchBar(),
                  // SliverToBoxAdapter(
                  //   child: _tagListNew(),
                  // ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          CustomText(
                            "Онцлох",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: customColors.primaryText,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // print("yelas:${_tagList2.length}");
                              // print("yelas22:${_contentList?[0].text}");
                            },
                            child: CustomText('okey'),
                          ),
                          SizedBox(height: 10),
                          _contentColumn(),
                          _contentColumn(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ContentStateV2 state) {
    if (state is ContentListSuccessV2) {
      _contentList = state.contentList;
      // _contentList = _filteredContentList = state.contentList;

      _tagList = state.tagList;
    } else if (state is ContentListFailedV2) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is ContentTagsSuccess) {
      _tagList2 = state.tagList;
      // showCustomDialog(
      //   context,
      //   child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      // );
    }
  }

  Widget _tagListNew() {
    // print("tagName:${_tagList.length}");
    // print("tagName1:${_tagList[1].name}");
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(left: 15),
        child: Row(
          // children: [for (var el in _tagList) _tagItem(el)], ///text ogdog baisan
          children: [for (var i = 0; i < _tagList.length; i++) _tagItem(i)],
        ),
      ),
    );
  }

  _tagItem(int i) {
    // bool _selected = text == _selectedMenu;

    return InkWell(
      onTap: () {
        // _selectedMenu = text;
        // setState(() {});
        // _tagList[i].isSelected = !(_tagList[i].isSelected ?? false);
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: (_tagList[i].isSelected ?? false) ? customColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: CustomText(
          _tagList[i].name.toString(),
          color: (_tagList[i].isSelected ?? false) ? Colors.white : customColors.primaryText,
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
        margin: EdgeInsets.only(
          bottom: 15,
        ),
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
