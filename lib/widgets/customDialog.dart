import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

void showCustomListDialog(BuildContext context,
    {required Widget child, bool isDismissible = false}) {
  Func.hideKeyboard(context);

  showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return child;
    },
  );
}

class CustomListDialog extends StatelessWidget {
  final Color? primaryColor;
  final String? asset;
  final String? text;
  final Widget? child;
  final String? buttonText;
  final VoidCallback? onPressedButton;

  const CustomListDialog({
    Key? key,
    this.primaryColor,
    this.asset,
    this.text,
    this.buttonText,
    this.onPressedButton,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: MediaQuery.of(context).viewInsets,
        height: 400,
        decoration: new BoxDecoration(
          color: customColors.whiteBackground,
          borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
        ),
        child: child);
  }
}

enum DialogType { normal, success, error, warning }
