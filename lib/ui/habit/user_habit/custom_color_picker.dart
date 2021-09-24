import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/custom_habit_settings_response.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/utils/theme/hex_color.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';

class CustomColorPicker extends StatefulWidget {
  final List<CustomHabitColor> colorList;
  final Function(CustomHabitColor)? onColorSelected;
  final EdgeInsets? margin;

  const CustomColorPicker({
    Key? key,
    required this.colorList,
    this.onColorSelected,
    this.margin,
  }) : super(key: key);

  @override
  _CustomColorPickerState createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  // Color list
  int get _rowCount =>
      widget.colorList.length % 4 == 0 ? widget.colorList.length ~/ 4 : widget.colorList.length ~/ 4 + 1;

  // Selected color
  CustomHabitColor? _selectedCustomHabitColor;

  @override
  void initState() {
    if (widget.colorList.isNotEmpty) {
      _selectedCustomHabitColor = widget.colorList.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      margin: widget.margin,
      padding: SizeHelper.boxPadding,
      child: Row(
        children: [
          /// Icon
          SvgPicture.asset(
            Assets.brush,
            color: HexColor.fromHex(_selectedCustomHabitColor?.color ?? ColorCodes.primary),
          ),

          /// Өнгө сонгох
          Expanded(
            child: CustomText(
              LocaleKeys.pickColor,
              fontWeight: FontWeight.w500,
              margin: EdgeInsets.only(left: 15.0),
            ),
          ),

          /// Color
          if (_selectedCustomHabitColor != null)
            Container(
              height: 18.0,
              width: 18.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                color: HexColor.fromHex(_selectedCustomHabitColor?.color ?? ColorCodes.primary),
              ),
            ),
        ],
      ),
      onTap: () {
        showCustomDialog(
          context,
          isDismissible: true,
          child: CustomDialogBody(
            child: Column(
              children: [
                // Note: GridView статик өргөн өндөр тохируулж чаддаггүй учир ашиглах хэрэггүй
                for (int i = 0; i < _rowCount; i++) _rowItem(i),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _rowItem(int rowIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Col 1
          Expanded(child: _gridItem(widget.colorList[rowIndex * 4])),

          SizedBox(width: 15.0),

          /// Col 2
          Expanded(
            child: (rowIndex * 4 + 1 < widget.colorList.length)
                ? _gridItem(widget.colorList[rowIndex * 4 + 1])
                : Container(),
          ),

          SizedBox(width: 15.0),

          /// Col 3
          Expanded(
            child: (rowIndex * 4 + 2 < widget.colorList.length)
                ? _gridItem(widget.colorList[rowIndex * 4 + 2])
                : Container(),
          ),

          SizedBox(width: 15.0),

          /// Col 4
          Expanded(
            child: (rowIndex * 4 + 3 < widget.colorList.length)
                ? _gridItem(widget.colorList[rowIndex * 4 + 3])
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _gridItem(CustomHabitColor customHabitColor) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCustomHabitColor = customHabitColor;
          if (widget.onColorSelected != null) widget.onColorSelected!(customHabitColor);
        });
        Navigator.pop(context);
      },
      child: Container(
        width: 65.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            width: _selectedCustomHabitColor?.color == customHabitColor.color ? 0.0 : SizeHelper.borderWidth,
            color: customColors.roseWhiteBorder,
          ),
          color: _selectedCustomHabitColor?.color == customHabitColor.color
              ? customColors.greyBackground
              : customColors.secondaryBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            Container(
              child: Image.asset(
                Assets.color_picker_png,
                height: 18.0,
                width: 18.0,
                color: HexColor.fromHex(customHabitColor.color ?? ColorCodes.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
