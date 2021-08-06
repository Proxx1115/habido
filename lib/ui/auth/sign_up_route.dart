import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class SignUpRoute extends StatefulWidget {
  @override
  _SignUpRouteState createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  // UI
  final _signUpKey = GlobalKey<ScaffoldState>();

  // Утасны дугаар
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  // Button next
  bool _enabledBtnNext = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _validateForm());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _signUpKey,
      appBarTitle: LocaleKeys.yourRegistration,
      padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
      child: Column(
        children: [
          /// Та өөрийн утасны дугаараа оруулна уу.
          CustomText(LocaleKeys.enterPhoneNumber, alignment: Alignment.center, maxLines: 2),

          /// Утасны дугаар
          CustomTextField(
            controller: _controller,
            focusNode: _focusNode,
            hintText: LocaleKeys.phoneNumber,
            margin: EdgeInsets.only(top: 35.0),
            maxLength: 8,
            textInputType: TextInputType.number,
          ),

          Spacer(),

          /// Button next
          CustomButton(
            style: CustomButtonStyle.Secondary,
            asset: Assets.arrow_next,
            onPressed: _enabledBtnNext
                ? () {
                    // Api
                  }
                : null,
          ), //_enabledBtnNext
        ],
      ),
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = Func.isValidPhoneNumber(_controller.text);
    });
  }
}
