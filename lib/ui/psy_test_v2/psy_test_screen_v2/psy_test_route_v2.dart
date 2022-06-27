import 'package:flutter/material.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class PsyTestRouteV2 extends StatefulWidget {
  const PsyTestRouteV2({Key? key}) : super(key: key);

  @override
  State<PsyTestRouteV2> createState() => _PsyTestRouteV2State();
}

class _PsyTestRouteV2State extends State<PsyTestRouteV2> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        child: ElevatedButton(
          onPressed: () {},
          child: CustomText('okey'),
        ),
      ),
    );
  }
}
