import 'package:flutter/material.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'assets.dart';
import 'func.dart';

class DeeplinkUtils {
  static Future<void> launchDeeplink(BuildContext context, {String? url}) async {
    try {
      if (Func.isEmpty(url) || !await canLaunch(url!)) {
        showFailedDialog(context);
      } else {
        await launch(url);
      }
    } catch (e) {
      showFailedDialog(context);
      print(e);
    }
  }

  static showFailedDialog(BuildContext context) {
    showCustomDialog(
      context,
      child: CustomDialogBody(asset: Assets.error, text: LocaleKeys.failed, button1Text: LocaleKeys.ok),
    );
  }
}
