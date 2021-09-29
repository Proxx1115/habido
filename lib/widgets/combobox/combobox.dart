import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:habido_app/widgets/text_field/text_fields.dart';
import 'combo_helper.dart';
import 'combo_list_item.dart';

class CustomCombobox extends StatefulWidget {
  /// UI
  final String label;
  final EdgeInsets? margin;
  final bool enabled;
  final Color? primaryColor;
  final Color? backgroundColor;

  /// Data
  final String? initialText;
  final List<ComboItem>? list;
  final ComboItem? selectedItem;
  final Function(ComboItem)? onItemSelected; // Return selected item

  const CustomCombobox({
    Key? key,
    this.list,
    required this.onItemSelected,
    this.initialText,
    this.label = '',
    this.margin,
    this.enabled = true,
    this.primaryColor,
    this.backgroundColor,
    this.selectedItem,
  }) : super(key: key);

  @override
  _CustomComboboxState createState() => _CustomComboboxState();
}

class _CustomComboboxState extends State<CustomCombobox> {
  ComboItem? _selectedItem;

  @override
  void initState() {
    _selectedItem = widget.selectedItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Func.hideKeyboard(context);
        _showBottomSheetDialog();
      },
      child: Container(
        margin: widget.margin,
        height: SizeHelper.boxHeight,
        padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
          color: widget.backgroundColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                _selectedItem != null ? _selectedItem!.txt : Func.toStr(widget.initialText),
                color: _selectedItem != null ? widget.primaryColor : customColors.greyText,
                fontWeight: _selectedItem != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: SvgPicture.asset(
                Assets.drop_down,
                color: widget.primaryColor ?? customColors.iconGrey,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showBottomSheetDialog() {
    if ((widget.list == null || widget.list!.isEmpty) || !widget.enabled) return;

    showCustomDialog(
      context,
      isDismissible: true,
      child: CustomDialogBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.list != null)
              // ?
              for (int i = 0; i < widget.list!.length; i++)
                ComboListItem(
                  primaryColor: widget.primaryColor,
                  backgroundColor: customColors.greyBackground,
                  iconBackground: Colors.white,
                  title: widget.list![i].txt,
                  selectable: true,
                  isSelected: _selectedItem == widget.list![i],
                  onPressed: () {
                    setState(() {
                      _selectedItem = widget.list![i];
                      if (widget.onItemSelected != null) {
                        widget.onItemSelected!(widget.list![i]);
                      }
                    });
                    Navigator.pop(context);
                  },
                )
          ],
        ),
      ),
    );
  }
}
