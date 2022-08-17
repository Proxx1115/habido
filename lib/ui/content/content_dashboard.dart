import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/models/content_tag.dart';
import 'package:habido_app/ui/content/content_bloc.dart';
import 'package:habido_app/ui/content/content_card.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/app_bars.dart';
import 'package:habido_app/ui/home/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/app_bars/dashboard_sliver_app_bar.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class ContentDashboard extends StatefulWidget {
  const ContentDashboard({Key? key}) : super(key: key);

  @override
  _ContentDashboardState createState() => _ContentDashboardState();
}

class _ContentDashboardState extends State<ContentDashboard> {
  // UI
  late ContentBloc _contentBloc;
  double _contentMargin = 15.0;

  // Search bar
  final _searchController = TextEditingController();

  // Tags
  List<ContentTag> _tagList = [];

  // Content
  List<Content>? _contentList;
  List<Content>? _filteredContentList;

  double? _contentWidth;

  @override
  void initState() {
    // Search
    _searchController.addListener(() => _filter());

    // Data
    _contentBloc = ContentBloc();
    _contentBloc.add(GetContentListEvent());
    super.initState();
  }

  @override
  void dispose() {
    _contentBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        child: BlocProvider.value(
          value: _contentBloc,
          child: BlocListener<ContentBloc, ContentState>(
            listener: _blocListener,
            child: BlocBuilder<ContentBloc, ContentState>(
              builder: (context, state) {
                return CustomScrollView(
                  slivers: [
                    /// App bar
                    DashboardSliverAppBar(title: LocaleKeys.advice),

                    /// Search
                    _searchBar(),

                    /// Tags
                    SliverToBoxAdapter(
                      child: _tagListWidget(),
                    ),

                    /// Content list
                    if (_filteredContentList != null && _filteredContentList!.isNotEmpty)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return _contentRow(index);
                          },
                          childCount: Func.toInt(_filteredContentList!.length / 2) + (_filteredContentList!.length.isEven ? 0 : 1),
                        ),
                      ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: SizeHelper.marginBottom),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ContentState state) {
    if (state is ContentListSuccess) {
      _contentList = _filteredContentList = state.contentList;
      _tagList = state.tagList;
    } else if (state is ContentListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
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

  Widget _tagListWidget() {
    return _tagList.isNotEmpty
        ? Container(
            padding: EdgeInsets.fromLTRB(SizeHelper.margin, 0.0, SizeHelper.margin, 0.0),
            child: Wrap(
              spacing: 5.0,
              runSpacing: 0.0,
              children: [
                for (int i = 0; i < _tagList.length; i++) _tagItem(i),
              ],
            ),
          )
        : Container();
  }

  Widget _tagItem(int i) {
    return StadiumContainer(
      margin: EdgeInsets.symmetric(vertical: 2.5),
      onTap: () {
        _tagList[i].isSelected = !(_tagList[i].isSelected ?? false);
        _filter();
      },
      borderRadius: SizeHelper.borderRadiusOdd,
      padding: EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 12.0),
      backgroundColor: (_tagList[i].isSelected ?? false) ? customColors.primary : customColors.whiteBackground,
      child: Text(
        '#' + _tagList[i].name.toString(),
        style: TextStyle(
          color: (_tagList[i].isSelected ?? false) ? customColors.whiteText : customColors.greyText,
          fontSize: 13.0,
        ),
      ),
    );
  }

  _filter() {
    // Search
    var searchContentList = <Content>[];
    if (_searchController.text.isEmpty) {
      searchContentList.addAll(_contentList ?? []);
    } else {
      for (Content el in (_contentList ?? [])) {
        if (Func.toStr(el.title).toLowerCase().contains(_searchController.text.toLowerCase())) {
          searchContentList.add(el);
        }
      }
    }

    // Tag
    var tagContentList = <Content>[];
    bool selectedTagFound = false;
    for (var el in _tagList) {
      if (el.isSelected ?? false) {
        selectedTagFound = true;
        break;
      }
    }

    if (!selectedTagFound) {
      tagContentList = searchContentList;
    } else {
      for (var tag in _tagList) {
        if (tag.isSelected ?? false) {
          for (var content in searchContentList) {
            for (var innerTag in (content.tags ?? [])) {
              if (tag.name == innerTag.name && !_tagList.contains(innerTag)) {
                tagContentList.add(content);
              }
            }
          }
        }
      }
    }

    setState(() {
      print('filtered');
      _filteredContentList = tagContentList;
    });
  }

  Widget _contentRow(int index) {
    _contentWidth = _contentWidth ?? (MediaQuery.of(context).size.width - _contentMargin - SizeHelper.margin * 2) / 2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Content 1
        Expanded(
          child: VerticalContentCard(
            duration: 200,
            content: _filteredContentList![index * 2],
            width: _contentWidth!,
            margin: EdgeInsets.fromLTRB(SizeHelper.margin, SizeHelper.margin, 0.0, 0.0),
          ),
        ),

        SizedBox(width: _contentMargin),

        /// Content 2
        Expanded(
          child: (index * 2 + 1 < _filteredContentList!.length)
              ? VerticalContentCard(
                  duration: 200,
                  content: _filteredContentList![index * 2 + 1],
                  width: _contentWidth!,
                  margin: EdgeInsets.fromLTRB(0.0, SizeHelper.margin, SizeHelper.margin, 0.0),
                )
              : Container(),
        ),
      ],
    );
  }
}
