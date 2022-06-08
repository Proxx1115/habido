import 'package:flutter/material.dart';
import 'package:habido_app/models/send_feedback_request.dart';
import 'package:habido_app/utils/api/api_helper.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
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
      child: Column(
        children: [
          RoundedCornerListView(
            padding: EdgeInsets.fromLTRB(SizeHelper.padding, 0.0, SizeHelper.padding, SizeHelper.padding),
            children: [
              /// HabiDo-тай холбоотой санал, сэтгэгдлээ бидэнд илгээгээрэй
              CustomTextField(
                controller: _feedbackController,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeHelper.borderRadius),
                  topRight: Radius.circular(SizeHelper.borderRadius),
                ),
                // suffixAsset: Assets.edit,
                hintText: LocaleKeys.feedbackHint,
                maxLines: 10,
                autofocus: true,
              ),
            ],
          ),
          CustomButton(
            style: CustomButtonStyle.secondary,
            text: LocaleKeys.send,
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
          ),
        ],
      ),
    );
  }
}
