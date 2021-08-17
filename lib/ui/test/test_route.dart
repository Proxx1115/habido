import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';

class TestRoute extends StatefulWidget {
  @override
  _TestRouteState createState() => _TestRouteState();
}

class _TestRouteState extends State<TestRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Test',
      body: Column(
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
    );
  }

  _onPressedButtonDialog() {
    showCustomDialog(
      context,
      isDismissible: true,
      child: CustomDialogBody(
        asset: Assets.success,
        text: 'test',
        button1Text: 'OK',
        // child: Container(
        //   color: Colors.red,
        //   height: 1.0,
        // ),
        onPressedButton1: () {
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
