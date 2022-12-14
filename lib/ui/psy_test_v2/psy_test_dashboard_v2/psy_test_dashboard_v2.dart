import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/test.dart';
import 'package:habido_app/models/test_name_with_tests.dart';
import 'package:habido_app/ui/home_new/dashboard/dashboard_app_bar.dart';
import 'package:habido_app/ui/psy_test_v2/psy_test_bloc_v2/psy_test_bloc_v2.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class PsyTestDashboardV2 extends StatefulWidget {
  const PsyTestDashboardV2({Key? key}) : super(key: key);

  @override
  State<PsyTestDashboardV2> createState() => _PsyTestDashboardV2State();
}

class _PsyTestDashboardV2State extends State<PsyTestDashboardV2> {
  List<TestNameWithTests>? _testNameWithTests;

  @override
  void initState() {
    BlocManager.psyTestBlocV2.add(GetTestListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.psyTestBlocV2,
        child: BlocListener<TestsBlocV2, TestsStateV2>(
          listener: _blocListener,
          child: BlocBuilder<TestsBlocV2, TestsStateV2>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, TestsStateV2 state) {
    if (state is TestListSuccess) {
      _testNameWithTests = state.testNameWithTests;
    } else if (state is TestListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, TestsStateV2 state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// App bar
          DashboardAppBar(
            title: LocaleKeys.psyTest,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(SizeHelper.margin, 20.0, SizeHelper.margin, 0.0),
            child: Column(
              children: [
                if (_testNameWithTests != null)
                  for (var el in _testNameWithTests!)
                    Column(
                      children: [
                        CustomText(
                          el.testCatName,
                          color: customColors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 15),
                        for (var data in el.tests!) _psyTest(data),
                      ],
                    )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// TEST LIST
  _psyTest(Test test) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.psyTestsIntroResult, arguments: {
          'test': test,
        });
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15),
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: test.hasTaken! == true
                  ? Border.all(
                      width: 1,
                      color: customColors.shamrockBorder,
                    )
                  : null,
            ),
            child: Container(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: SizeHelper.margin + 65),
                  Expanded(
                    child: CustomText(
                      test.name,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      maxLines: 2,
                      color: customColors.primaryText,
                    ),
                  ),
                  test.hasTaken! == true
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                            height: 16,
                            width: 16,
                            padding: EdgeInsets.symmetric(horizontal: 4.5, vertical: 5.5),
                            color: customColors.shamrockBorder,
                            child: SvgPicture.asset(
                              Assets.check,
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(width: SizeHelper.margin)
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: test.photo ?? '',
              fit: BoxFit.fitHeight,
              height: 65,
              width: 65.0,
              placeholder: (context, url) => CustomLoader(),
              errorWidget: (context, url, error) => Container(),
            ),
          ),
        ],
      ),
    );
  }
}
