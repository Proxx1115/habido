import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

// class AlwaysDisabledFocusNode extends FocusNode {
//   @override
//   bool get hasFocus => false;
// }

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onSelectedDate;
  final String? hintText;
  final EdgeInsets? margin;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePicker({
    Key? key,
    this.initialDate,
    required this.onSelectedDate,
    this.hintText,
    this.margin = EdgeInsets.zero,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  // Data
  DateTime? _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.initialDate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      onTap: () {
        _onTap();
      },
      margin: widget.margin,
      height: SizeHelper.boxHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Hint
          Expanded(
            child: CustomText(
              _text(),
              color: _color(),
              margin: EdgeInsets.only(left: 18.0),
              fontWeight: FontWeight.w500,
            ),
          ),

          /// Icon
          Container(
            margin: EdgeInsets.only(right: 18.0),
            child: SvgPicture.asset(Assets.expand),
          ),
        ],
      ),
    );
  }

  _text() {
    if (_selectedDate != null) {
      return Func.dateTimeToDateStr(_selectedDate);
    } else if (widget.hintText != null) {
      return widget.hintText!;
    } else {
      return '';
    }
  }

  _color() {
    if (_selectedDate != null) {
      return customColors.primaryText;
    } else {
      return customColors.secondaryText;
    }
  }

  _onTap() async {
    print('clicked');

    _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    print(_selectedDate);

    setState(() {
      if (_selectedDate != null) {
        widget.onSelectedDate(_selectedDate!);
      }
    });
  }
}
