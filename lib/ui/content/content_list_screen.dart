import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/ui/content/content_bloc.dart';
import 'package:habido_app/ui/content/content_widget.dart';
import 'package:habido_app/ui/home/home_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

class ContentListScreen extends StatefulWidget {
  const ContentListScreen({Key? key}) : super(key: key);

  @override
  _ContentListScreenState createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {
  late ContentBloc _contentBloc;

  // Data
  List<Content>? _contentList;

  // Gridview
  final double _gridViewPadding = SizeHelper.padding;
  final double _gridViewCrossAxisSpacing = 15.0;

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
                children: [
                  /// Calendar, Title, Notification
                  HomeAppBar(title: 'Test'),

                  /// Search bar
                  _searchBar(),

                  /// Tags
                  _tagsList(),

                  /// Content list
                  if (_contentList != null && _contentList!.length > 0) Expanded(child: _contentListWidget()),
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
        child: CustomDialogBody(asset: Assets.error, text: state.message, button1Text: LocaleKeys.ok),
      );
    }
  }

  Widget _searchBar() {
    return Container();
  }

  Widget _tagsList() {
    return Container();
  }

  Widget _contentListWidget() {
    double imageWidth = (MediaQuery.of(context).size.width - _gridViewPadding - _gridViewCrossAxisSpacing * 2) / 2;
    double imageHeight = imageWidth * 0.7;

    return GridView.count(
      primary: false,
      padding: EdgeInsets.all(_gridViewPadding),
      crossAxisSpacing: _gridViewCrossAxisSpacing,
      mainAxisSpacing: _gridViewCrossAxisSpacing,
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      children: <Widget>[
        if (_contentList != null && _contentList!.length > 0)
          for (var el in _contentList!)
            VerticalContent(
              content: el,
              imageHeight: imageHeight,
              onPressed: () {
                Navigator.pushNamed(context, Routes.content, arguments: {
                  'content': el,
                });

                // Navigator.of(context).pushNamed(
                //   SharedPref.checkIntroLimit() ? Routes.intro : Routes.login,
                //       (Route<dynamic> route) => false,
                // );
              },
            ),
      ],
    );
  }

// List<Widget> _list() {
// if (_contentList != null && _contentList!.length > 0) {
//   for (var el in _contentList!)
//     VerticalContent(content: el)
//
// return List<Widget> [];
// }
}
