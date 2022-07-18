import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/content_tag_v2.dart';
import 'package:habido_app/models/content_v2.dart';
import 'package:habido_app/ui/content_v2/content_bloc_v2.dart';
import 'package:habido_app/ui/content_v2/content_card_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:habido_app/ui/home_new/dashboard/dashboard_app_bar.dart';

class ContentDashboardV2 extends StatefulWidget {
  const ContentDashboardV2({Key? key}) : super(key: key);

  @override
  State<ContentDashboardV2> createState() => _ContentDashboardV2State();
}

class _ContentDashboardV2State extends State<ContentDashboardV2> {
  /// REFRESH CONTROLLER
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// SEARCH
  final _searchController = TextEditingController();

  /// TAGS
  List<ContentTagV2> _tagList = [];
  var _forYou = new ContentTagV2(name: "Танд", filterValue: "");
  ContentTagV2? _selectedTag;

  /// CONTENT
  bool _isShow = true;
  List<ContentV2>? _contentHighlightedList;

  /// CONTENT FIRST
  List<ContentV2> _contentList = [];

  @override
  void initState() {
    /// SEARCH
    _searchController.addListener(() => _getContent());

    /// TAG
    _tagList.add(_forYou);
    _selectedTag = _forYou;

    /// HIGHLIGHTED LIST
    BlocManager.contentBlocV2.add(GetHighlightedListEvent());

    /// TAGS
    BlocManager.contentBlocV2.add(GetContentTags());

    /// GET CONTENT
    _getContent();

    super.initState();
  }

  _getContent() {
    (_searchController.text.isEmpty && Func.isEmpty(_selectedTag!.filterValue))
        ? _isShow = true
        : _isShow = false;
    print("ahahha $_isShow");
    BlocManager.contentBlocV2.add(GetContentFirst(
        _selectedTag!.filterValue ?? "", _searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        child: BlocProvider.value(
          value: BlocManager.contentBlocV2,
          child: BlocListener<ContentBlocV2, ContentStateV2>(
            listener: _blocListener,
            child: BlocBuilder<ContentBlocV2, ContentStateV2>(
              builder: _blocBuilder,
            ),
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ContentStateV2 state) {
    if (state is ContentHighlightedListSuccess) {
      _contentHighlightedList = state.contentList;
    } else if (state is ContentHighlightedListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is ContentTagsSuccess) {
      _tagList.addAll(state.tagList);
    } else if (state is ContentTagsFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is ContentFirstSuccess) {
      _contentList = state.contentList;
    } else if (state is ContentFirstFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is ContentThenSuccess) {
      _contentList.addAll(state.contentList);
      // print('First:${state.contentList[0].title}');
    } else if (state is ContentThenFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    } else if (state is ContentLikeSuccess) {
      print('Content Like success');
    } else if (state is ContentLikeFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(
            asset: Assets.error,
            text: state.message,
            buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, ContentStateV2 state) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      header: ClassicHeader(
        refreshStyle: RefreshStyle.Follow,
        idleText: '',
        releaseText: "",
        refreshingText: "",
        completeText: "",
//            completeIcon: null,
      ),
      // header: WaterDropHeader(
      //
      // ),

      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Container(); // pull up load
          } else if (mode == LoadStatus.loading) {
            body = cupertino.CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Container(); // Load Failed! Click retry!
          } else if (mode == LoadStatus.canLoading) {
            body = Container(); // release to load more
          } else {
            body = Container(); // No more Data
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,

      child: _tips(),
    );
  }

  Widget _tips() {
    return CustomScrollView(
      slivers: [
        /// App bar
        SliverToBoxAdapter(
            child: DashboardAppBar(
          title: LocaleKeys.advice,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
        )),

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
                _isShow
                    ? Column(
                        children: [
                          FadeInAnimation(
                            duration: 500,
                            child: CustomText(
                              "Онцлох",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: customColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 10),
                          if (_contentHighlightedList != null)
                            for (var i = 0;
                                i < _contentHighlightedList!.length;
                                i++)
                              ContentCardV2(
                                  content: _contentHighlightedList![i]),
                          SizedBox(height: 3),
                        ],
                      )
                    : Container(),
                FadeInAnimation(
                  duration: 500,
                  child: CustomText(
                    _selectedTag!.name ?? "Танд",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: customColors.primaryText,
                  ),
                ),
                SizedBox(height: 12),
                for (var i = 0; i < _contentList.length; i++)
                  ContentCardV2(content: _contentList[i]),
              ],
            ),
          ),
        ),
      ],
    );
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
    bool _selected = tag.name == _selectedTag!.name;

    return InkWell(
      onTap: () {
        _selectedTag = tag;
        // (Func.isEmpty(_selectedTag!.filterValue)) ? _isShow = true : _isShow = false;
        print("haha st ${_isShow}");

        _getContent();
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

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    // _notifList = [];
    // BlocManager.notifBloc.add(GetFirstNotifsEvent());

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    // _notifList.add((_notifList.length + 1).toString());

    if (_contentList.isNotEmpty) {
      BlocManager.contentBlocV2.add(GetContentThenEvent(
          _selectedTag!.filterValue!,
          _searchController.text,
          _contentList.last.contentId ?? 0));
    }

    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }
}
