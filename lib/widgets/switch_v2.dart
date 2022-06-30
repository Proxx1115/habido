import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/ui/habit/user_habit/reminder/reminder_bloc.dart';
import 'package:habido_app/ui/habit_new/tag_item_widget_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/time_picker.dart';

class CustomSwitchV2 extends StatefulWidget {
  final ReminderBloc reminderBloc;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final EdgeInsets? margin;

  final String? leadingAsset;
  final Color? leadingAssetColor;

  final Color? activeColor; //: Colors.transparent,
  final Color? inactiveThumbColor; //: Colors.transparent,
  final Color? activeTrackColor; //: Colors.grey,
  final Color? inactiveTrackColor; //: Colors.grey,
  final Color? primaryColor;

  final String? activeText;
  final String? inactiveText;
  final String? activeAsset;
  final String? inactiveAsset;

  const CustomSwitchV2(
      {Key? key,
      this.value = false,
      required this.onChanged,
      this.enabled = true,
      this.margin,
      this.leadingAsset,
      this.leadingAssetColor,
      this.activeColor,
      this.inactiveThumbColor,
      this.activeTrackColor,
      this.inactiveTrackColor,
      this.activeText,
      this.inactiveText,
      this.activeAsset,
      this.inactiveAsset,
      this.primaryColor,
      required this.reminderBloc})
      : super(key: key);

  @override
  _CustomSwitchV2State createState() => _CustomSwitchV2State();
}

class _CustomSwitchV2State extends State<CustomSwitchV2> {
  TimeOfDay? selectedTimeOfDay;
  bool _value = false;
  late int index;
  bool isMaxRemTime = false;
  String? text;

  @override
  void initState() {
    // Value
    _value = widget.value;

    // Text
    _toggleText();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: widget.margin,
      padding:
          EdgeInsets.only(left: 18.0, top: 15.0, right: 15.0, bottom: 18.0),
      child: (widget.leadingAsset != null || text != null)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Icon
                      if (widget.leadingAsset != null)
                        SvgPicture.asset(
                          widget.leadingAsset!,
                          color:
                              widget.leadingAssetColor ?? customColors.iconGrey,
                          fit: BoxFit.fitHeight,
                        ),

                      SizedBox(width: 10.0),

                      Expanded(
                        child: Wrap(
                          spacing: 5.0, // gap between adjacent chips
                          runSpacing: 10.0,
                          children: [
                            if (widget.reminderBloc.switchValue)
                              for (int i = 0;
                                  i < widget.reminderBloc.timeOfDayList.length;
                                  i++)
                                _reminderItem(
                                    widget.reminderBloc.timeOfDayList[i]),
                            if (widget.reminderBloc.timeOfDayList.length != 8)
                              _buttonAdd()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),

                /// Switch
                _switch(),
              ],
            )
          : _switch(),
    );
  }

  Widget _switch() {
    return Container(
      height: 20,
      width: 36,
      child: Switch(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: _value,
        activeColor: widget.activeColor ?? customColors.primary,
        inactiveThumbColor: widget.inactiveThumbColor,
        activeTrackColor: widget.activeTrackColor,
        inactiveTrackColor: widget.inactiveTrackColor,
        activeThumbImage: widget.activeAsset != null
            ? AssetImage(
                widget.activeAsset!,
              )
            : null,
        inactiveThumbImage: widget.inactiveAsset != null
            ? AssetImage(widget.inactiveAsset!)
            : null,
        onChanged: widget.enabled
            ? (newValue) {
                setState(() {
                  _value = newValue;
                  _toggleText();
                });

                widget.onChanged(newValue);

                print('Switch value: $newValue');
              }
            : null,
      ),
    );
  }

  Widget _reminderItem(TimeOfDay timeOfDay) {
    // _onPressedDeleteItem(timeOfDay);
    return TagItemWidgetV2(
      fontSize: 12.0,
      width: 52.0,
      height: 22.0,
      color: widget.activeColor ?? customColors.primary,
      text: '${timeOfDay.hour}:${timeOfDay.minute}',
      onPressed: () {
        widget.reminderBloc.add(RemoveReminderEvent(timeOfDay));
      },
    );
  }

  Widget _buttonAdd() {
    return Container(
      // margin: EdgeInsets.only(left: 5.0),
      child: TagItemWidgetV2(
        color: customColors.addIconBackground,
        asset: Assets.add,
        width: 52.0,
        height: 22.0,
        fontSize: 10.0,
        onPressed:
            widget.reminderBloc.switchValue ? _onPressedButtonAdd : () {},
      ),
    );
  }

  void _onPressedButtonAdd() async {
    TimeOfDay? selectedTimeOfDay =
        await showCustomTimePicker(context, widget.primaryColor);
    if (selectedTimeOfDay != null) {
      widget.reminderBloc.add(AddReminderEvent(selectedTimeOfDay));
      print(widget.reminderBloc.timeOfDayList.length);
    }
  }

  _toggleText() {
    if (_value && widget.activeText != null) {
      text = widget.activeText;
    } else if (!_value && widget.inactiveText != null) {
      text = widget.inactiveText;
    } else if (widget.activeText != null && widget.inactiveText == null) {
      text = widget.activeText;
    }
  }
}
