import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/models/test_info.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_containers/info_container_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class PsyIntroRouteV2 extends StatefulWidget {
  final TestInfo testInfo;
  const PsyIntroRouteV2({
    Key? key,
    required this.testInfo,
  }) : super(key: key);

  @override
  _PsyIntroRouteV2State createState() => _PsyIntroRouteV2State();
}

class _PsyIntroRouteV2State extends State<PsyIntroRouteV2> {
  // UI
  final _psyIntroKey = GlobalKey<ScaffoldState>();
  double _height = 0.0;
  double _minHeight = 600;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        if (_height < constraints.maxHeight) _height = constraints.maxHeight;
        if (_height < _minHeight) _height = _minHeight;

        return SingleChildScrollView(
          child: Container(
            height: _height,
            padding: SizeHelper.screenPadding,
            child: Column(
              children: [
                // if (Func.isNotEmpty(widget.psyTest.description))
                if (true) // todo yela
                  Expanded(
                    child: ListView(
                      children: [
                        /// COVER IMAGE
                        if (Func.isNotEmpty(widget.testInfo.coverPhoto))
                          ClipRRect(
                            borderRadius: SizeHelper.borderRadiusOdd,
                            child: CachedNetworkImage(
                              imageUrl: widget.testInfo.coverPhoto!,
                              fit: BoxFit.fitWidth,
                              width: double.infinity,
                              placeholder: (context, url) => CustomLoader(),
                              errorWidget: (context, url, error) => Container(),
                            ),
                          ),

                        /// TEST INFO CONTAINER
                        _testInfoContainer()
                      ],
                    ),
                  ),

                /// Button next
                _buttonNext(),
                //_enabledBtnNext
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _testInfoContainer() {
    return InfoContainerV2(
      margin: EdgeInsets.only(top: 15.0),
      title: widget.testInfo.name!,
      body: widget.testInfo.description!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.clock_test,
                height: 15,
                width: 15,
              ),
              SizedBox(width: 10),
              CustomText(
                "Зарцуулах хугацаа - ${widget.testInfo.duration!}мин",
                fontSize: 15,
                fontWeight: FontWeight.w300,
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                Assets.question_number,
                height: 15,
                width: 15,
              ),
              SizedBox(width: 10),
              CustomText(
                "Асуултын тоо - ${widget.testInfo.totalQuestionCnt!}",
                fontSize: 15,
                fontWeight: FontWeight.w300,
              )
            ],
          )
        ],
      ),
    );
  }

  _buttonNext() {
    return CustomButton(
      margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
      text: LocaleKeys.beginTestV2,
      onPressed: widget.testInfo.canStart!
          ? () {
              Navigator.pop(context);
            }
          : null,
    );
  }
// _buttonNext() {
//   return CustomButton(
//     visible: true,
//     style: CustomButtonStyle.secondary,
//     text: LocaleKeys.beginTest,
//     margin: EdgeInsets.only(top: 20.0),
//     onPressed: () {
//       // Navigator.pushNamed(context, Routes.psyTest, arguments: {
//       //   'psyTest': widget.psyTest,
//       // });
//     },
//   );
// }
}
