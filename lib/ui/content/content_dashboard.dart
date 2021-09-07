import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/ui/content/content_bloc.dart';
import 'package:habido_app/ui/content/content_card.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/app_bars/app_bars.dart';
import 'package:habido_app/widgets/app_bars/dashboard_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class ContentDashboard extends StatefulWidget {
  const ContentDashboard({Key? key}) : super(key: key);

  @override
  _ContentDashboardState createState() => _ContentDashboardState();
}

class _ContentDashboardState extends State<ContentDashboard> {
  // UI
  late ContentBloc _contentBloc;
  double _contentMargin = 15.0;

  // Content
  List<Content>? _contentList;
  double? _contentWidth;

  @override
  void initState() {
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
    return CustomScaffold(
      body: BlocProvider.value(
        value: _contentBloc,
        child: BlocListener<ContentBloc, ContentState>(
          listener: _blocListener,
          child: BlocBuilder<ContentBloc, ContentState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  /// App bar
                  DashboardSliverAppBar(title: LocaleKeys.content),

                  /// Search
                  SliverToBoxAdapter(
                    child: _searchBar(),
                  ),

                  /// Tags
                  SliverToBoxAdapter(
                    child: _tagsList(),
                  ),

                  /// Content list
                  if (_contentList != null && _contentList!.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return _contentRow(index);
                        },
                        childCount: Func.toInt(_contentList!.length / 2) + (_contentList!.length.isEven ? 0 : 1),
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
    );
  }

  void _blocListener(BuildContext context, ContentState state) {
    if (state is ContentListSuccess) {
      _contentList = state.contentList;
    } else if (state is ContentListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _searchBar() {
    return Container();
  }

  Widget _tagsList() {
    return Container();
  }

  Widget _contentRow(int index) {
    _contentWidth = _contentWidth ?? (MediaQuery.of(context).size.width - _contentMargin - SizeHelper.margin * 2) / 2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Content 1
        Expanded(
          child: VerticalContentCard(
            content: _contentList![index * 2],
            width: _contentWidth!,
            margin: EdgeInsets.fromLTRB(SizeHelper.margin, SizeHelper.margin, 0.0, 0.0),
          ),
        ),

        SizedBox(width: _contentMargin),

        /// Content 2
        Expanded(
          child: (index * 2 + 1 < _contentList!.length)
              ? VerticalContentCard(
                  content: _contentList![index * 2 + 1],
                  width: _contentWidth!,
                  margin: EdgeInsets.fromLTRB(0.0, SizeHelper.margin, SizeHelper.margin, 0.0),
                )
              : Container(),
        ),
      ],
    );
  }

// Widget _contentGridView2() {
//   _contentImageWidth = _contentImageWidth ??
//       (MediaQuery.of(context).size.width - _gridViewPadding - _gridViewCrossAxisSpacing * 2) / 2;
//   _contentImageHeight = _contentImageHeight ?? (_contentImageWidth! * 0.7);
//
//   return (_contentList != null && _contentList!.isNotEmpty && _contentImageHeight != null)
//       ? GridView.count(
//           primary: false,
//           padding: EdgeInsets.all(_gridViewPadding),
//           crossAxisSpacing: _gridViewCrossAxisSpacing,
//           mainAxisSpacing: _gridViewCrossAxisSpacing,
//           crossAxisCount: 2,
//           childAspectRatio: 0.58,
//           children: <Widget>[
//             for (var el in _contentList!)
//               VerticalContentCard22222(
//                 content: el,
//                 imageHeight: _contentImageHeight!,
//               ),
//           ],
//         )
//       : Container();
// }

// Widget _contentGridView() {
//   _contentImageWidth = _contentImageWidth ??
//       (MediaQuery.of(context).size.width - _gridViewPadding - _gridViewCrossAxisSpacing * 2) / 2;
//   _contentImageHeight = _contentImageHeight ?? (_contentImageWidth! * 0.7);
//
//   return (_contentList != null && _contentList!.isNotEmpty && _contentImageHeight != null)
//       ? GridView.count(
//           primary: false,
//           padding: EdgeInsets.all(_gridViewPadding),
//           crossAxisSpacing: _gridViewCrossAxisSpacing,
//           mainAxisSpacing: _gridViewCrossAxisSpacing,
//           crossAxisCount: 2,
//           childAspectRatio: 0.58,
//           children: <Widget>[
//             for (var el in _contentList!)
//               VerticalContentCard22222(
//                 content: el,
//                 imageHeight: _contentImageHeight!,
//               ),
//           ],
//         )
//       : Container();
// }

// List<Widget> _list() {
// if (_contentList != null && _contentList!.length > 0) {
//   for (var el in _contentList!)
//     VerticalContent(content: el)
//
// return List<Widget> [];
// }
}
