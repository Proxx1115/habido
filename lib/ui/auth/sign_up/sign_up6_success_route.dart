import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/auth_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/login_request.dart';
import 'package:habido_app/models/sign_up_register_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

/// Sign up step 6
class SignUp6SuccessRoute extends StatefulWidget {
  final SignUpRegisterRequest verifyCodeRequest;

  const SignUp6SuccessRoute({Key? key, required this.verifyCodeRequest}) : super(key: key);

  @override
  _SignUp6SuccessRouteState createState() => _SignUp6SuccessRouteState();
}

class _SignUp6SuccessRouteState extends State<SignUp6SuccessRoute> {
  // UI
  final _signUp5SuccessKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: _blocListener,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, AuthState state) {
    if (state is LoginSuccess) {
      // todo test
      // if(globals.userData.asd)
      if (!true) {
        Navigator.pushNamed(context, Routes.home);
      } else {
        /// Судалгаа бөглөх
        Navigator.pushNamed(context, Routes.home);
      }
    } else if (state is LoginFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, AuthState state) {
    return CustomScaffold(
      scaffoldKey: _signUp5SuccessKey,
      backgroundColor: customColors.primary,
      child: Container(
        padding: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, SizeHelper.marginBottom),
        child: Stack(
          children: [
            /// Cover image
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 70),
                child: Image.asset(
                  Assets.auth_success,
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),

            /// Text
            CustomText(
              LocaleKeys.beginTogether,
              alignment: Alignment.topCenter,
              textAlign: TextAlign.center,
              color: customColors.whiteText,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              maxLines: 3,
              margin: EdgeInsets.fromLTRB(50.0, 125.0, 50.0, 0.0),
            ),

            /// Button next
            CustomButton(
              alignment: Alignment.bottomRight,
              style: CustomButtonStyle.Secondary,
              asset: Assets.long_arrow_next,
              backgroundColor: customColors.whiteBackground,
              contentColor: customColors.primaryButtonDisabledContent,
              onPressed: () {
                var request = LoginRequest()
                  ..username = widget.verifyCodeRequest.phoneNumber
                  ..password = widget.verifyCodeRequest.password
                  ..isBiometric = false
                  ..deviceId = ''; // todo test

                BlocManager.authBloc.add(LoginEvent(request));

                Navigator.of(context).popUntil((route) => route.isFirst); // Navigate to first route
                // Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
