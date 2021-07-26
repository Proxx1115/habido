import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
PreferredSize AppBarEmpty({
  required BuildContext context,
  Brightness brightness = Brightness.light,
  Color backgroundColor = Colors.transparent,
  double elevation = 0.0,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(0.0), // here the desired height
    child: AppBar(
      backgroundColor: backgroundColor,
      brightness: brightness,
      leading: Container(),
      elevation: elevation,
      actions: <Widget>[],
    ),
  );
}
