import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/send_feedback_request.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';

class FeedbackRouteV2 extends StatefulWidget {
  const FeedbackRouteV2({Key? key}) : super(key: key);

  @override
  _FeedbackRouteV2State createState() => _FeedbackRouteV2State();
}

class _FeedbackRouteV2State extends State<FeedbackRouteV2> {
  // TextField
  final _feedbackController = TextEditingController();

  // Button
  bool _enabledButton = false;

  @override
  void initState() {
    super.initState();

    _feedbackController.addListener(() {
      setState(() {
        _enabledButton = _feedbackController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.feedback,
      padding: SizeHelper.screenPadding,
      child: _feelingDetailTextField(),
      floatingActionButton: _buttonFinish(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _buttonFinish() {
    return !Func.visibleKeyboard(context)
        ? CustomButton(
            margin: EdgeInsets.fromLTRB(45.0, 0, 45.0, 30.0),
            fontWeight: FontWeight.w700,
            alignment: Alignment.bottomCenter,
            text: LocaleKeys.send,
            borderRadius: BorderRadius.circular(15.0),
            onPressed: _enabledButton
                ? () async {
                    var request = SendFeedbackRequest()
                      ..phone = globals.userData?.phone ?? ''
                      ..userId = 0
                      ..feedBackId = 0
                      ..text = _feedbackController.text;

                    var res = await ApiManager.sendFeedback(request);
                    if (res.code == ResponseCode.Success) {
                      // Success
                      showCustomDialog(
                        context,
                        child: CustomDialogBody(
                          asset: Assets.success,
                          text: LocaleKeys.success,
                          buttonText: LocaleKeys.ok,
                          onPressedButton: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    } else {
                      // Failed
                      showCustomDialog(
                        context,
                        child: CustomDialogBody(
                          asset: Assets.error,
                          text: LocaleKeys.failed,
                          buttonText: LocaleKeys.ok,
                        ),
                      );
                    }
                  }
                : null,
          )
        : Container();
  }

  Widget _feelingDetailTextField() {
    return Container(
      height: 200,
      padding: EdgeInsets.fromLTRB(18.0, 9.0, 18.0, 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: customColors.whiteBackground,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.warning_calendar,
                height: 20.0,
                width: 20.0,
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: CustomText(
                  "HabiDo-тэй холбоотой санал, сэтгэгдлээ бидэнд илгээгээрэй",
                  fontSize: 11.0,
                  color: customColors.primaryText,
                  maxLines: 2,
                ),
              ),
            ],
          ),

          /// Divider
          HorizontalLine(margin: EdgeInsets.only(top: 9.0)),

          Expanded(
            child: TextField(
              controller: _feedbackController,
              maxLines: null,
              cursorColor: customColors.whiteText,
              style: TextStyle(color: customColors.primaryText),
              decoration: InputDecoration(
                hintText: LocaleKeys.feelingDetailHint,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: customColors.disabledText,
                ),
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
