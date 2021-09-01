import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/ui/content/content_bloc.dart';
import 'package:habido_app/ui/content/content_card.dart';
import 'package:habido_app/widgets/app_bars/home_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

class ContentDashboard extends StatefulWidget {
  const ContentDashboard({Key? key}) : super(key: key);

  @override
  _ContentDashboardState createState() => _ContentDashboardState();
}

class _ContentDashboardState extends State<ContentDashboard> {
  late ContentBloc _contentBloc;

  // Data
  List<Content>? _contentList;

  // Gridview
  final double _gridViewPadding = SizeHelper.padding;
  final double _gridViewCrossAxisSpacing = 15.0;

  // Content
  double? _contentImageWidth;
  double? _contentImageHeight;

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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Calendar, Title, Notification
                  HomeAppBar(title: LocaleKeys.content),

                  /// Search bar
                  _searchBar(),

                  /// Tags
                  _tagsList(),

                  /// Content list
                  if (_contentList != null && _contentList!.length > 0)
                    Expanded(
                      child: _contentGridView(),
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

  Widget _contentGridView() {
    _contentImageWidth = _contentImageWidth ?? (MediaQuery.of(context).size.width - _gridViewPadding - _gridViewCrossAxisSpacing * 2) / 2;
    _contentImageHeight = _contentImageHeight ?? (_contentImageWidth! * 0.7);

    return (_contentList != null && _contentList!.isNotEmpty && _contentImageHeight != null)
        ? GridView.count(
            primary: false,
            padding: EdgeInsets.all(_gridViewPadding),
            crossAxisSpacing: _gridViewCrossAxisSpacing,
            mainAxisSpacing: _gridViewCrossAxisSpacing,
            crossAxisCount: 2,
            childAspectRatio: 0.58,
            children: <Widget>[
              for (var el in _contentList!)
                VerticalContentCard(
                  content: el,
                  imageHeight: _contentImageHeight!,
                ),
            ],
          )
        : Container();
  }

// List<Widget> _list() {
// if (_contentList != null && _contentList!.length > 0) {
//   for (var el in _contentList!)
//     VerticalContent(content: el)
//
// return List<Widget> [];
// }
}
