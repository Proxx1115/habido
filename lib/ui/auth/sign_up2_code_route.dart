import 'package:flutter/material.dart';
import 'package:habido_app/models/verify_code_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/code_input.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

/// Sign up step 2
class SignUp2CodeRoute extends StatefulWidget {
  final VerifyCodeRequest verifyCodeRequest;

  const SignUp2CodeRoute({Key? key, required this.verifyCodeRequest}) : super(key: key);

  @override
  _SignUp2CodeRouteState createState() => _SignUp2CodeRouteState();
}

class _SignUp2CodeRouteState extends State<SignUp2CodeRoute> {
  // UI
  final _signUp2CodeKey = GlobalKey<ScaffoldState>();

  // Code input
  String? _code = '';

  // Button next
  bool _enabledBtnNext = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _signUp2CodeKey,
      appBarTitle: LocaleKeys.yourRegistration,
      padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
      child: Column(
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

        _onPressedBtnNext();
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
      asset: Assets.long_arrow_next,
      onPressed: _enabledBtnNext
          ? () {
              _onPressedBtnNext();
            }
          : null,
    );
  }

  _onPressedBtnNext() {
    if (!_enabledBtnNext) return;

    VerifyCodeRequest verifyCodeRequest = widget.verifyCodeRequest;
    verifyCodeRequest.code = _code;

    Navigator.pushNamed(context, Routes.signUp3Profile, arguments: {
      'verifyCodeRequest': verifyCodeRequest,
    });
  }
}
