import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/ui/content/content_bloc.dart';
import 'package:habido_app/ui/content/content_widget.dart';
import 'package:habido_app/ui/home/home_app_bar.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
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
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(SizeHelper.padding),
      crossAxisSpacing: 15.0,
      mainAxisSpacing: 15.0,
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      children: <Widget>[
        VerticalContent(content: _contentList![0]),
        // _list(),
        if (_contentList != null && _contentList!.length > 0)
          for (var el in _contentList!)
            VerticalContent(
              content: el,
              onPressed: () {
                //
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
