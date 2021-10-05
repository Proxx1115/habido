import 'package:flutter/material.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

Future<TimeOfDay?> showCustomTimePicker(BuildContext context, Color? primaryColor) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    helpText: LocaleKeys.selectTime,
    cancelText: LocaleKeys.cancel,
    confirmText: LocaleKeys.ok,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: primaryColor ?? customColors.primary),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        ),
      );
    },
  );
}
