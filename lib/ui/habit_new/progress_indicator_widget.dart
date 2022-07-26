import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/text.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double value;
  final String? status;
  const ProgressIndicatorWidget({Key? key, required this.value, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: value == 0 ? 1 : value / 100,
          valueColor: new AlwaysStoppedAnimation<Color>(_getColor()),
          backgroundColor: customColors.whiteBackground,
          strokeWidth: 2.0,
        ),
        CustomText(
          '${value.toInt()}%',
          color: _getColor(),
          fontWeight: FontWeight.w700,
          fontSize: 8.0,
        ),
      ],
    );
  }

  Color _getColor() {
    switch (status) {
      case "Failed":
        return customColors.iconRed;
      case "Completed":
        return customColors.iconSeaGreen;
      case "StartedNotCompleted":
        return customColors.iconYellow;
      case "New":
        return customColors.iconRed;
      case "Started":
        return customColors.iconYellow;
      case "Done":
        return customColors.iconSeaGreen;
      default:
        return customColors.iconRed;
    }
  }
}
