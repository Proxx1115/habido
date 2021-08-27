import 'package:flutter/material.dart';
import 'package:habido_app/models/psy_test_result.dart';
import 'package:habido_app/widgets/scaffold.dart';

class PsyTestResultRoute extends StatefulWidget {
  final PsyTestResult psyTestResult;

  const PsyTestResultRoute({Key? key, required this.psyTestResult}) : super(key: key);

  @override
  _PsyTestResultRouteState createState() => _PsyTestResultRouteState();
}

class _PsyTestResultRouteState extends State<PsyTestResultRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'test',
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
          ],
        ),
      ),
    );
  }
}
