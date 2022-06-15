import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/content_tag_v2.dart';
import 'package:habido_app/models/content_v2.dart';
import 'package:habido_app/models/test_name_with_tests.dart';
import 'package:habido_app/ui/content_v2/content_bloc_v2.dart';
import 'package:habido_app/ui/content_v2/content_card_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/app_bars/dashboard_sliver_app_bar.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class ContentDashboardV2 extends StatefulWidget {
  const ContentDashboardV2({Key? key}) : super(key: key);

  @override
  State<ContentDashboardV2> createState() => _ContentDashboardV2State();
}

class _ContentDashboardV2State extends State<ContentDashboardV2> {
  late ContentBlocV2 _contentBlocV2;

  // Search bar
  final _searchController = TextEditingController();

  // Tags
  List<ContentTagV2> _tagList = [];

  List<TestNameWithTests>? _testNameWithTests;

  String? _selectedTag = "Танд";

  var forYou = new ContentTagV2(name: "Танд", filterValue: "Танд");

  // Content
  List<ContentV2>? _contentList;
  List<ContentV2>? _contentFilter;
  ContentV2? content;

  int pSize = 100;

  @override
  void initState() {
    // Search
    // _searchController.addListener(() => _filter());

    _contentBlocV2 = ContentBlocV2();
    _contentBlocV2.add(GetHighlightedListEvent());
    _tagList.add(forYou);
    _getData();
    _contentBlocV2.add(GetContentTags());
    _getData2();
    super.initState();
  }

  _getData() {
    _contentBlocV2.add(GetContentFilter(_selectedTag ?? "", 1, pSize));
  }

  _getData2() {
    _contentBlocV2.add(GetTestListEvent());
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
        child: BlocListener<ContentBlocV2, ContentHighlightedState>(
          listener: _blocListener,
          child: BlocBuilder<ContentBlocV2, ContentHighlightedState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  /// App bar
                  DashboardSliverAppBar(title: LocaleKeys.advice),

                  /// Search
                  _searchBar(),

                  SliverToBoxAdapter(
                    child: _tagListWidget(),
                  ),
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
                                print("okeyNice:${_testNameWithTests![0].tests?[0].photo}");
                              },
                              child: CustomText("okey")),
                          SizedBox(height: 10),
                          if (_contentList != null)
                            //   for (var el in _contentList!) _contentColumn(el),
                            // for (var i = 0; i < _contentList!.length; i++) _contentColumn(_contentList![i]),
                            for (var i = 0; i < _contentList!.length; i++) ContentCardV2(content: _contentList![i]),
                          SizedBox(height: 3),
                          CustomText(
                            _selectedTag ?? "Танд",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: customColors.primaryText,
                          ),
                          SizedBox(height: 12),
                          if (_contentFilter != null)
                            // for (var contentFilter in _contentFilter!) _contentColumn(contentFilter),
                            // for (var i = 0; i < _contentFilter!.length; i++) _contentColumn(_contentFilter![i])
                            for (var i = 0; i < _contentFilter!.length; i++) ContentCardV2(content: _contentFilter![i]),
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

  void _blocListener(BuildContext context, ContentHighlightedState state) {
    if (state is ContentHighlightedListSuccess) {
      _contentList = state.contentList;
    } else if (state is ContentHighlightedListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is ContentTagsSuccess) {
      _tagList.addAll(state.tagList);
    } else if (state is ContentTagsFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is ContentFilterSuccess) {
      _contentFilter = state.contentList;
    } else if (state is ContentFilterFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    } else if (state is TestListSuccess) {
      _testNameWithTests = state.testNameWithTests;
    } else if (state is TestListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _tagListWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(left: 15),
        child: Row(
          children: [for (var tag in _tagList) _tagItem(tag)],
        ),
      ),
    );
  }

  _tagItem(ContentTagV2 tag) {
    bool _selected = tag.name == _selectedTag;
    // print('tagsss:${tag.name} ');
    return InkWell(
      onTap: () {
        // print('tag:${tag.name!} ${tag.filterValue!}');
        _selectedTag = tag.filterValue!;
        pSize = 4;
        _getData();
        _getData2();

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
          tag.name.toString(),
          color: _selected ? Colors.white : customColors.primaryText,
          fontSize: 15,
          fontWeight: FontWeight.w400,
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
