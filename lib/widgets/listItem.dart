import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  final String title;
  final String? body;
  final bool? primary;
  final bool? selectAble;
  final Color? iconColor;
  final BoxDecoration? decoration;
  final Color? backGroundColor;
  final Color? iconBackground;
  final Function()? onPressed;

  const ListItem({
    required this.title,
    this.body,
    this.primary = false,
    this.iconColor,
    this.onPressed,
    this.selectAble = false,
    this.backGroundColor,
    this.iconBackground,
    this.decoration,
  });

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(15),
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: widget.backGroundColor != null ? widget.backGroundColor : Colors.white),
        decoration: widget.decoration?.copyWith(
            borderRadius: BorderRadius.circular(25),
            color: widget.backGroundColor != null
                ? widget.backGroundColor
                : Colors.white),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Title
                  widget.title != null
                      ? Text(
                          widget.title,
                          // fontWeight: FontWeight.w500,
                          // fontSize: 15,
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
