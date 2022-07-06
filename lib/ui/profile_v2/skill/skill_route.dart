import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/skill.dart';
import 'package:habido_app/ui/profile_v2/skill/skill_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SkillRoute extends StatefulWidget {
  const SkillRoute({Key? key}) : super(key: key);

  @override
  State<SkillRoute> createState() => _SkillRouteState();
}

class _SkillRouteState extends State<SkillRoute> {
  /// CONTENT FIRST
  List<Skill> _skillList = [];

  @override
  void initState() {
    BlocManager.skillBloc.add(GetSkillListEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.skillBloc,
        child: BlocListener<SkillBloc, SkillState>(
          listener: _blocListener,
          child: BlocBuilder<SkillBloc, SkillState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, SkillState state) {
    if (state is SkillListSuccess) {
      print('elaman:${state.badgeList}');
      _skillList = state.badgeList;
    } else if (state is SkillListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, SkillState state) {
    // return SingleChildScrollView(
    //   child: Column(children: [
    //     _ability(
    //       AssetName: "assets/images/test/ability.svg",
    //       title: "Тайван сэтгэл зүй",
    //       text: "Энэ бол тайлбар гаййййййййккя",
    //     ),
    //     _ability(
    //       AssetName: "assets/images/test/ability.svg",
    //       title: "Тайван сэтгэл зүй",
    //       text: "Энэ бол тайлбар гаййййййййккя",
    //     ),
    //   ]),
    // );
    return _skillList.length != 0
        ? ListView.builder(
            itemBuilder: (context, index) => _ability(index),
            // itemExtent: 90.0,
            itemCount: _skillList.length,
          )
        : Container();
    // return ElevatedButton(
    //     onPressed: () {
    //       print('asd:${_skillList}');
    //     },
    //     child: CustomText('okey'));
  }

  Widget _ability(index) {
    return InkWell(
      onTap: () {
        showCustomDialog(
          context,
          child: CustomDialogBody(
            buttonText: "Цонхыг хаах",
            child: Column(
              children: [
                /// Image
                // if (Func.isNotEmpty(_notifList[index].photo))
                if (true) //todo yela
                  Container(
                    margin: EdgeInsets.only(right: 15.0),
                    padding: EdgeInsets.all(10.0),
                    height: 58.0,
                    width: 58.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: customColors.greyBackground,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: _skillList[index].image ?? "",
                      placeholder: (context, url) => Container(),
                      //CustomLoader(),
                      errorWidget: (context, url, error) => Container(),
                      height: 40.0,
                      width: 23.0,
                      fit: BoxFit.fitHeight,
                    ),
                  ),

                /// Title
                CustomText(
                  _skillList[index].name!,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  fontWeight: FontWeight.w500,
                  color: customColors.primary,
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Html(
                      shrinkWrap: true,
                      style: {
                        'html': Style(
                          textAlign: TextAlign.justify,
                        ),
                      },
                      data: _skillList[index].description ?? ''),
                ),
                SizedBox(height: 25),
              ],
            ),
            onPressedButton: () {},
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: customColors.greyBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: _skillList[index].image ?? '',
                    fit: BoxFit.fitHeight,
                    height: 55,
                    width: 33.0,
                    placeholder: (context, url) => CustomLoader(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    CustomText(_skillList[index].name!),
                    SizedBox(height: 10),
                    // Container(
                    //   height: 6,
                    //   decoration: BoxDecoration(
                    //     color: customColors.primary,
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    // ),
                    Container(
                      color: Colors.cyanAccent,
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        lineHeight: 6,
                        percent: _skillList[index].currentValue! / _skillList[index].maxValue!,
                        progressColor: customColors.primary,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(_skillList[index].level!),
                        CustomText('${_skillList[index].currentValue!}/${_skillList[index].maxValue!}'),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
