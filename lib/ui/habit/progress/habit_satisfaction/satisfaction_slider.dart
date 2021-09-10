import 'package:flutter/material.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';

class SatisfactionSlider extends StatefulWidget {
  final String text;
  final Function(int)? onChanged;
  final EdgeInsets? margin;

  const SatisfactionSlider({
    Key? key,
    required this.text,
    this.onChanged,
    this.margin,
  }) : super(key: key);

  @override
  _SatisfactionSliderState createState() => _SatisfactionSliderState();
}

class _SatisfactionSliderState extends State<SatisfactionSlider> {
  @override
  Widget build(BuildContext context) {
    return StadiumContainer(
      margin: widget.margin,
      padding: SizeHelper.boxPadding,
      child: Column(
        children: [
          /// Text
          CustomText(widget.text, alignment: Alignment.center),

          /// Divider
          HorizontalLine(margin: EdgeInsets.symmetric(vertical: 15.0)),

          /// Slider
          //
        ],
      ),
    );
  }
}
