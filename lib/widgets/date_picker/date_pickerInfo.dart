import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/text.dart';
import 'date_picker_bloc.dart';

class InfoDatePicker extends StatefulWidget {
  final DatePickerBloc bloc;
  final DateTime? initialDate;
  final Function(DateTime?) callback;
  final String? hintText;
  final EdgeInsets? margin;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Color? primaryColor;

  const InfoDatePicker({
    Key? key,
    required this.bloc,
    this.initialDate,
    required this.callback,
    this.hintText,
    this.margin = EdgeInsets.zero,
    this.firstDate,
    this.lastDate,
    this.primaryColor,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<InfoDatePicker> {
  // Data
  DateTime? _pickedDate;

  @override
  void initState() {
    _pickedDate = widget.initialDate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocListener<DatePickerBloc, DatePickerState>(
        listener: (context, state) {
          if (state is DatePickedState) {
            _pickedDate = state.pickedDate;
            widget.callback(_pickedDate);
          }
        },
        child: BlocBuilder<DatePickerBloc, DatePickerState>(
          builder: (context, state) {
            return StadiumContainer(
              backgroundColor: Colors.transparent,
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
                      // margin: EdgeInsets.only(left: 18.0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  /// Icon
                  // Container(
                  //   // margin: EdgeInsets.only(right: 18.0),
                  //   child: SvgPicture.asset(Assets.expand),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _text() {
    if (_pickedDate != null) {
      return Func.dateTimeToDateStr(_pickedDate);
    } else if (widget.hintText != null) {
      return widget.hintText!;
    } else {
      return '';
    }
  }

  _color() {
    if (_pickedDate != null) {
      return customColors.primaryText;
    } else {
      return customColors.greyText;
    }
  }

  _onTap() async {
    print('clicked');

    _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
                primary: widget.primaryColor ?? customColors.primary),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (mounted)
      setState(() {
        print(_pickedDate);
        widget.callback(_pickedDate);
      });
  }
}
