import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit/calendar/calendar_button.dart';
import 'package:habido_app/ui/notification/notif_button.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/text.dart';

class HomeAppBar2 extends StatefulWidget {
  final String? title;

  const HomeAppBar2({Key? key, this.title}) : super(key: key);

  @override
  _HomeAppBar2State createState() => _HomeAppBar2State();
}

class _HomeAppBar2State extends State<HomeAppBar2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(SizeHelper.margin, 10.0, SizeHelper.margin, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Calendar
          CalendarButton(),

          /// Title
          if (Func.isNotEmpty(widget.title))
            Expanded(
              child: CustomText(widget.title, alignment: Alignment.center, fontWeight: FontWeight.w500),
            ),

          /// Notification
          NotifButton(),
        ],
      ),
    );
  }
}
