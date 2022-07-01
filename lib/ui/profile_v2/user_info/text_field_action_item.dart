import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';

class TextFieldActionItem extends StatelessWidget {
  final String asset;
  final Function()? onClick;
  const   TextFieldActionItem({Key? key, required this.asset, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: onClick,
        child: SvgPicture.asset(
          asset,
          height: 13,
          width: 13,
          color: customColors.primary,
        ),
      ),
    );
  }
}
