import 'package:flutter/material.dart';
import 'package:habido_app/models/feedback_category_list_response.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/scaffold.dart';

class FeedBackCategoryListRoute extends StatefulWidget {
  const FeedBackCategoryListRoute({Key? key}) : super(key: key);

  @override
  _FeedBackCategoryListRouteState createState() =>
      _FeedBackCategoryListRouteState();
}

class _FeedBackCategoryListRouteState extends State<FeedBackCategoryListRoute> {

  List<FeedBackCategoryListResponse>? _feedBackCategories;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.feedback,
        padding: SizeHelper.screenPadding,
        child: Column());
  }
}
