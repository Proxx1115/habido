import 'package:flutter/material.dart';
import 'package:habido_app/ui/habit_new/habit_detail/line_model.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';

class LineChart extends StatefulWidget {
  LineChart({Key? key}) : super(key: key);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  List<String> weekNameList = ['05.22', '05.21', '05.20', '05.19', '05.18', '05.17', '05.16'];

  bool isSevendays = true;
  List<LineModel> _list = [];
  final LineRepo _lineRepo = LineRepo();
  @override
  void initState() {
    _list = List.from(_list)..addAll(_lineRepo.getDays());
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveFlutter.of(context).hp(35),
      width: ResponsiveFlutter.of(context).wp(100),
      color: Colors.red,
      child: Container(
        margin: EdgeInsets.all(ResponsiveFlutter.of(context).fontSize(2)),
        padding: EdgeInsets.all(ResponsiveFlutter.of(context).fontSize(2)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(ResponsiveFlutter.of(context).fontSize(2))),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemExtent: ResponsiveFlutter.of(context).fontSize(3),
                    scrollDirection: Axis.vertical,
                    itemCount: _list.length,
                    primary: false,
                    itemBuilder: (context, index) {
                      return _dayItem(_list[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Row(children: [
                Expanded(
                  child: SizedBox(),
                ),
                SizedBox(
                  width: ResponsiveFlutter.of(context).fontSize(1),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                      margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).fontSize(1), left: ResponsiveFlutter.of(context).fontSize(1)),
                      child: ListView.builder(
                        itemExtent: ResponsiveFlutter.of(context).fontSize(3.2),
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        primary: false,
                        itemBuilder: (context, index) {
                          return Text('${index + 1}');
                        },
                      )),
                )
              ]),
            ),
          ),
          Expanded(
            child: Row(children: [
              Expanded(
                  child: Row(
                children: [
                  Container(
                    width: ResponsiveFlutter.of(context).fontSize(1.9),
                    height: ResponsiveFlutter.of(context).fontSize(1.9),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(ResponsiveFlutter.of(context).fontSize(0.5))),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveFlutter.of(context).wp(1),
                  ),
                  Expanded(
                      child: Text(
                    'Тааламжгүй (1) - Тааламжтай(10)',
                    style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.5)),
                  )),
                  SizedBox(
                    width: ResponsiveFlutter.of(context).wp(1),
                  ),
                  Container(
                    width: ResponsiveFlutter.of(context).fontSize(1.9),
                    height: ResponsiveFlutter.of(context).fontSize(1.9),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(ResponsiveFlutter.of(context).fontSize(0.5))),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveFlutter.of(context).wp(1),
                  ),
                  Text(
                    'Сэтгэл хангамж',
                    style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.5)),
                  )
                ],
              )),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _dayItem(LineModel model) {
    return Container(
      margin: EdgeInsets.only(
        right: ResponsiveFlutter.of(context).fontSize(1),
        left: ResponsiveFlutter.of(context).fontSize(1),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).fontSize(1)),
            child: Text(
              '05.${model.day}',
              style: TextStyle(
                fontSize: ResponsiveFlutter.of(context).fontSize(1.3),
              ),
            ),
          ),
        ),
        SizedBox(
          width: ResponsiveFlutter.of(context).fontSize(1),
        ),
        Expanded(child: Visibility(visible: model.status! >= 1, child: line())),
        Expanded(child: Visibility(visible: model.status! >= 2, child: line())),
        Expanded(child: Visibility(visible: model.status! >= 3, child: line())),
        Expanded(child: Visibility(visible: model.status! >= 4, child: line())),
        Expanded(child: Visibility(visible: model.status! >= 5, child: line())),
        Expanded(child: Visibility(visible: model.status! >= 6, child: line())),
        Expanded(child: Visibility(visible: model.status! >= 7, child: line())),
        Expanded(child: Visibility(visible: model.status! >= 8, child: line())),
        Expanded(child: Visibility(visible: model.status! >= 9, child: line())),
        Expanded(child: Visibility(visible: model.status! >= 10, child: line()))
      ]),
    );
  }

  Widget line() {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).fontSize(0.4)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: ResponsiveFlutter.of(context).fontSize(0.4), color: Colors.orange),
        ),
      ),
    );
  }
}
