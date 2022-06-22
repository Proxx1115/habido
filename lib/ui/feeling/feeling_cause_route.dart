import 'package:flutter/material.dart';
import 'package:habido_app/ui/feeling/btn_back_widget.dart';
import 'package:habido_app/ui/feeling/btn_next_widget.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class FeelingCauseRoute extends StatefulWidget {
  final selectedFeelingData;
  const FeelingCauseRoute({Key? key, this.selectedFeelingData}) : super(key: key);

  @override
  State<FeelingCauseRoute> createState() => _FeelingCauseRouteState();
}

class _FeelingCauseRouteState extends State<FeelingCauseRoute> {
  // UI
  final _feelingCauseKey = GlobalKey<ScaffoldState>();

  List _feelingCause = [
    LocaleKeys.family,
    LocaleKeys.relationship,
    LocaleKeys.children,
    LocaleKeys.friends,
    LocaleKeys.work,
    LocaleKeys.school,
    LocaleKeys.health,
    LocaleKeys.mentalHealth,
    LocaleKeys.sleep,
    LocaleKeys.mySelf,
    LocaleKeys.finance,
  ];

  List<String> _selectedCauses = [];

  _onSelectCause(String value) {
    if (_selectedCauses.contains(value)) {
      _selectedCauses.remove(value);
    } else {
      if (_selectedCauses.length < 2) {
        _selectedCauses.add(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffoldKey: _feelingCauseKey,
      child: Container(
        padding: EdgeInsets.fromLTRB(SizeHelper.margin, SizeHelper.margin, SizeHelper.margin, 0.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [customColors.feelingCauseTop, customColors.feelingCauseBtm],
        )),
        child: Column(
          children: [
            ButtonBackWidget(onTap: _navigatePop),

            SizedBox(height: 28.0),

            /// Question
            Container(
              child: CustomText(
                LocaleKeys.whatCausesThisFeeling,
                color: customColors.whiteText,
                fontWeight: FontWeight.w700,
                fontSize: 27.0,
                maxLines: 3,
              ),
            ),

            SizedBox(height: 86.0),

            Expanded(
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 14.0,
                runSpacing: 8.0,
                children: [
                  for (var el in _feelingCause) _causeItem(el),
                ],
              ),
            ),

            ButtonNextWidget(
              onTap: _navigateToFeelingDetailRoute,
              isVisible: _selectedCauses.length != 0,
              progressValue: 0.75,
            ),

            SizedBox(height: 30.0)
          ],
        ),
      ),
    );
  }

  Widget _causeItem(causeName) {
    return InkWell(
      onTap: () {
        setState(() {
          _onSelectCause(causeName);
        });
      },
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: _selectedCauses.contains(causeName) ? customColors.primary : customColors.feelingCauseItem, // todo change color
        ),
        child: Text(
          causeName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: customColors.whiteText,
            fontWeight: FontWeight.w500,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  _navigateToFeelingDetailRoute() {
    Navigator.pushNamed(
      context,
      Routes.feelingDetail,
      arguments: {
        'selectedFeelingData': widget.selectedFeelingData,
        'selectedCauses': _selectedCauses,
      },
    );
  }

  _navigatePop() {
    Navigator.popUntil(context, ModalRoute.withName(Routes.feelingEmoji));
  }
}
