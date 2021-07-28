import 'package:flutter/material.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
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

  Chkbox({
    this.text = '',
    required this.onChanged,
    this.isChecked = false,
    this.padding = const EdgeInsets.all(0.0),
    this.width = double.infinity,
    this.textColor,
    this.unselectedWidgetColor,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChkboxState(this.isChecked);
  }
}

class _ChkboxState extends State<Chkbox> {
  _ChkboxState(this.isChecked);

  bool isChecked;

  var shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    side: BorderSide(color: customColors.primary, width: 1, style: BorderStyle.solid),
  );

  @override
  Widget build(BuildContext context) {
    Widget checkBox;
    if (!Func.isEmpty(widget.text)) {
      /// Has text
      Widget checkBoxListTile = Row(
        children: [
          Checkbox(
            value: isChecked,
            activeColor: customColors.primary,
            checkColor: customColors.primary,
            shape: shape,
            onChanged: (isChecked) => _onChanged(isChecked),
          ),
          Expanded(
            child: Txt(
              widget.text,
              maxLines: 10,
              color: widget.textColor ?? customColors.txtGrey,
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
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
      checkBox = Checkbox(
        activeColor: customColors.primary,
        checkColor: customColors.primary,
        shape: shape,
        value: isChecked,
        onChanged: (isChecked) => _onChanged(isChecked),
      );
    }
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: widget.unselectedWidgetColor ?? customColors.primary,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
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
