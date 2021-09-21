import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';
import 'slider_bloc.dart';

class CustomSlider extends StatefulWidget {
  final SliderBloc sliderBloc;
  final EdgeInsets? margin;
  final Color? primaryColor;
  final String? title;
  final String? quantityText;
  final bool? visibleButtons;

  const CustomSlider({
    Key? key,
    required this.sliderBloc,
    this.margin,
    this.primaryColor,
    this.title,
    this.quantityText,
    this.visibleButtons,
  }) : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: BlocProvider.value(
        value: widget.sliderBloc,
        child: BlocListener<SliderBloc, SliderState>(
          listener: (context, state) {},
          child: BlocBuilder<SliderBloc, SliderState>(
            builder: (context, state) {
              return Column(
                children: [
                  if (widget.title != null || widget.quantityText != null)
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Title
                          if (widget.title != null) CustomText(widget.title, color: customColors.secondaryText),

                          /// Quantity
                          if (widget.quantityText != null)
                            Expanded(
                              child: CustomText(
                                '${Func.toInt(widget.sliderBloc.value)} ${widget.quantityText!.toLowerCase()}',
                                fontWeight: FontWeight.w500,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                        ],
                      ),
                    ),

                  // Slider
                  (widget.visibleButtons ?? false)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Decrease
                            CircleButton(
                              asset: Assets.negative,
                              backgroundColor: widget.primaryColor,
                              onPressed: () {
                                widget.sliderBloc.add(SliderDecreaseEvent(widget.sliderBloc.value));
                              },
                            ),

                            /// Slider
                            Expanded(
                              child: _slider(),
                            ),

                            /// Increase
                            CircleButton(
                              asset: Assets.positive,
                              backgroundColor: widget.primaryColor,
                              onPressed: () {
                                widget.sliderBloc.add(SliderIncreaseEvent(widget.sliderBloc.value));
                              },
                            ),
                          ],
                        )
                      : _slider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _slider() {
    return Slider(
      value: widget.sliderBloc.value,
      min: widget.sliderBloc.minValue,
      max: widget.sliderBloc.maxValue,
      divisions: Func.toInt((widget.sliderBloc.maxValue - widget.sliderBloc.minValue) / widget.sliderBloc.step),
      label: widget.sliderBloc.value.round().toString(),
      activeColor: widget.primaryColor ?? customColors.primary,
      onChanged: (double value) {
        widget.sliderBloc.add(SliderChangedEvent(value));
      },
    );
  }
}
