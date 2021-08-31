import 'package:flutter/material.dart';
import 'package:habido_app/utils/localization/localization.dart';

Future<TimeOfDay?> showCustomTimePicker(BuildContext context) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    helpText: LocaleKeys.selectTime,
    cancelText: LocaleKeys.cancel,
    confirmText: LocaleKeys.ok,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );
}
