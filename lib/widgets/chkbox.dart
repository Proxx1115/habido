import 'package:flutter/material.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/txt.dart';

// ignore: must_be_immutable
class Chkbox extends StatefulWidget {
  bool isChecked;
  String text;
  Function(bool) onChanged;
  EdgeInsets padding;
  double width;
  Color? textColor;
  Color? unselectedWidgetColor;
  final EdgeInsets margin;

  Chkbox({
    this.text = '',
    required this.onChanged,
    this.isChecked = false,
    this.padding = const EdgeInsets.all(0.0),
    this.width = double.infinity,
    this.textColor,
    this.unselectedWidgetColor,
    this.margin = EdgeInsets.zero,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChkboxState(this.isChecked);
  }
}

class _ChkboxState extends State<Chkbox> {
  _ChkboxState(this.isChecked);

  bool isChecked;
  double size = 20.0;

  var shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(SizeHelper.borderRadius5)),
    side: BorderSide(color: customColors.primary, width: 1, style: BorderStyle.solid),
  );

  @override
  Widget build(BuildContext context) {
    Widget checkBox;
    if (!Func.isEmpty(widget.text)) {
      /// Has text
      Widget checkBoxListTile = Row(
        children: [
          SizedBox(
            height: size,
            width: size,
            child: Checkbox(
              value: isChecked,
              activeColor: customColors.primary,
              checkColor: customColors.primary,
              shape: shape,
              onChanged: (isChecked) => _onChanged(isChecked),
            ),
          ),
          MarginHorizontal(width: 15.0),
          Expanded(
            child: BtnTxt(
              text: widget.text,
              color: widget.textColor ?? customColors.txtGrey,
              fontSize: 15.0,
              alignment: Alignment.centerLeft,
              onPressed: () {
                _onChanged(!isChecked);
              },
            ),
          ),
        ],
      );

      checkBox = new ListTileTheme(
        contentPadding: EdgeInsets.zero,
        child: checkBoxListTile,
      );
    } else {
      /// No text
      checkBox = SizedBox(
        height: size,
        width: size,
        child: Checkbox(
          activeColor: customColors.primary,
          checkColor: customColors.primary,
          shape: shape,
          value: isChecked,
          onChanged: (isChecked) => _onChanged(isChecked),
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: widget.unselectedWidgetColor ?? customColors.primary,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        margin: widget.margin,
        width: widget.width,
        child: checkBox,
      ),
    );
  }

  _onChanged(bool? isChecked) {
    setState(() => this.isChecked = isChecked ?? false);
    widget.onChanged(isChecked ?? false);
  }
}
