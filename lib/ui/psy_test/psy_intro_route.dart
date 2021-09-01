import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/models/psy_test.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';

class PsyIntroRoute extends StatefulWidget {
  final PsyTest psyTest;

  const PsyIntroRoute({
    Key? key,
    required this.psyTest,
  }) : super(key: key);

  @override
  _PsyIntroRouteState createState() => _PsyIntroRouteState();
}

class _PsyIntroRouteState extends State<PsyIntroRoute> {
  // UI
  final _psyIntroKey = GlobalKey<ScaffoldState>();
  double _height = 0.0;
  double _minHeight = 600;



  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _psyIntroKey,
      appBarTitle: LocaleKeys.doTest,
      body: LayoutBuilder(builder: (context, constraints) {
        if (_height < constraints.maxHeight) _height = constraints.maxHeight;
        if (_height < _minHeight) _height = _minHeight;

        return SingleChildScrollView(
          child: Container(
            height: _height,
            padding: SizeHelper.paddingScreen,
            child: Column(
              children: [
                if (Func.isNotEmpty(widget.psyTest.description))
                  Expanded(
                    child: ListView(
                      children: [
                        /// Cover image
                        if (Func.isNotEmpty(widget.psyTest.photo))
                          ClipRRect(
                            borderRadius: SizeHelper.borderRadiusOdd,
                            child: CachedNetworkImage(
                              imageUrl: widget.psyTest.photo!,
                              fit: BoxFit.fitWidth,
                              width: double.infinity,
                              placeholder: (context, url) => CustomLoader(),
                              errorWidget: (context, url, error) => Container(),
                            ),
                          ),

                        /// Info container
                        InfoContainer(
                          margin: EdgeInsets.only(top: 15.0),
                          title: widget.psyTest.name ?? '',
                          body: widget.psyTest.description ?? '',
                        ),
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

  _buttonNext() {
    return CustomButton(
      style: CustomButtonStyle.Secondary,
      text: LocaleKeys.beginTest,
      margin: EdgeInsets.only(top: 20.0),
      onPressed: () {
        Navigator.pushNamed(context, Routes.psyTest, arguments: {
          'psyTest': widget.psyTest,
        });
      },
    );
  }
}
