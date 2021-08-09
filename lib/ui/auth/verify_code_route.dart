import 'package:flutter/material.dart';
import 'package:habido_app/models/sign_up_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/code_input.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class VerifyCodeRoute extends StatefulWidget {
  final SignUpResponse signUpResponse;

  const VerifyCodeRoute({Key? key, required this.signUpResponse}) : super(key: key);

  @override
  _VerifyCodeRouteState createState() => _VerifyCodeRouteState();
}

class _VerifyCodeRouteState extends State<VerifyCodeRoute> {
  // UI
  final _verifyCodeKey = GlobalKey<ScaffoldState>();

  // Code input
  String? _code = '';

  // Button next
  bool _enabledBtnNext = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _verifyCodeKey,
      appBarTitle: LocaleKeys.yourRegistration,
      padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
      body: Column(
        children: [
          /// Танд мессежээр ирсэн 4-н оронтой кодыг оруулна уу.
          CustomText(LocaleKeys.enterCode, alignment: Alignment.center, maxLines: 2),

          /// Code input
          _codeInput(),

          Spacer(),

          /// Button next
          _buttonNext(),
          //_enabledBtnNext
        ],
      ),
    );
  }

  _codeInput() {
    return CustomCodeInput(
      margin: EdgeInsets.only(top: 35.0),
      onChanged: (value) {
        _code = value;
        _validateForm();
      },
      onFilled: (value) {
        _code = value;
        _validateForm();

        Func.hideKeyboard(context);
      },
    );
  }

  _validateForm() {
    setState(() {
      _enabledBtnNext = (_code != null && _code?.length == 4);
    });
  }

  _buttonNext() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      asset: Assets.arrow_next,
      onPressed: _enabledBtnNext
          ? () {
              Navigator.pushNamed(context, Routes.signUpProfile, arguments: {
                'signUpResponse': widget.signUpResponse,
                'code': _code,
              });
            }
          : null,
    );
  }
}
