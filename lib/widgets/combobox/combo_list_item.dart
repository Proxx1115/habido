import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class ComboListItem extends StatefulWidget {
  final String? title;
  final String? assetName;
  final Icon? icon;
  final String? body;
  final bool isSelected;
  final bool selectable;
  final Color? primaryColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? iconBackground;
  final VoidCallback? onPressed;

  const ComboListItem({
    this.title,
    this.assetName,
    this.icon,
    this.body,
    this.isSelected = false,
    this.primaryColor,
    this.iconColor,
    this.onPressed,
    this.selectable = false,
    this.backgroundColor,
    this.iconBackground,
  });

  @override
  _ComboListItemState createState() => _ComboListItemState();
}

class _ComboListItemState extends State<ComboListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: widget.backgroundColor != null ? widget.backgroundColor : Colors.white),
        child: Row(
          children: [
            /// icon
            if (widget.assetName != null)
              _roundedContainer(
                child: Image.asset(
                  widget.assetName!,
                  height: 20,
                  width: 20,
                  color: widget.iconColor,
                ),
              ),

            if (widget.icon != null)
              _roundedContainer(
                child: SizedBox(
                  child: widget.icon,
                  height: 20,
                  width: 20,
                ),
              ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Title
                  widget.title != null
                      ? CustomText(widget.title!, fontWeight: FontWeight.w500, fontSize: 15)
                      : Container(),

                  /// Body
                  widget.body != null
                      ? CustomText(widget.body!, fontSize: 13, color: customColors.greyText)
                      : Container(),
                ],
              ),
            ),

            /// Check
            widget.selectable
                ? Container(
                    margin: EdgeInsets.only(left: 10.0),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isSelected ? (widget.primaryColor ?? customColors.primary) : Color(0xFFE4E8EB),
                        width: 7,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _roundedContainer({
    Widget? child,
  }) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.only(right: 15.0),
      decoration: BoxDecoration(
          border: Border.all(color: customColors.primaryBorder, width: 3),
          borderRadius: BorderRadius.circular(16),
          color: widget.iconBackground),
      child: child ?? Container(),
    );
  }
}
