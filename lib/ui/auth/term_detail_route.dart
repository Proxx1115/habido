import 'package:flutter/material.dart';
import 'package:habido_app/models/param_response.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/scaffold.dart';

class TermDetailRoute extends StatefulWidget {
  final TermsOfService termsOfService;

  const TermDetailRoute({Key? key, required this.termsOfService}) : super(key: key);

  @override
  _TermDetailRouteState createState() => _TermDetailRouteState();
}

class _TermDetailRouteState extends State<TermDetailRoute> {
  // UI
  final _termDetailKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _termDetailKey,
      appBarTitle: LocaleKeys.termsOfService,
      padding: EdgeInsets.fromLTRB(25.0, 30.0, 25.0, SizeHelper.marginBottom),
      child: SingleChildScrollView(
        child: InfoContainer(
          title: widget.termsOfService.title ?? '',
          body: widget.termsOfService.body ?? '',
        ),
      ),
    );
  }
}
