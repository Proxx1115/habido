import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

class ExampleRoute extends StatefulWidget {
  @override
  _ExampleRouteState createState() => _ExampleRouteState();
}

class _ExampleRouteState extends State<ExampleRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Test',
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomButton(
              text: 'Show dialog',
              onPressed: () {
                _onPressedButtonDialog();
              },
            ),
            Text(MediaQuery.of(context).size.height.toString()),
          ],
        ),
      ),
    );
  }

  _onPressedButtonDialog() {
    showCustomDialog(
      context,
      isDismissible: true,
      child: CustomDialogBody(
        asset: Assets.success,
        text: 'test',
        buttonText: 'OK',
        // child: Container(
        //   color: Colors.red,
        //   height: 1.0,
        // ),
        onPressedButton: () {
          //
        },
        // button2Text: 'NO',
        onPressedButton2: () {
          //
        },
      ),
    );
  }
}
