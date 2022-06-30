import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/models/badge_module.dart';
import 'package:habido_app/ui/profile_v2/badge/badge_bloc.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/responsive_flutter/responsive_flutter.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/text.dart';

class Badge extends StatefulWidget {
  const Badge({Key? key}) : super(key: key);

  @override
  State<Badge> createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  /// CONTENT
  List<BadgeModule>? badgeList;

  @override
  void initState() {
    BlocManager.badgeBloc.add(GetBadgeListEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: BlocProvider.value(
        value: BlocManager.badgeBloc,
        child: BlocListener<BadgeBloc, BadgeState>(
          listener: _blocListener,
          child: BlocBuilder<BadgeBloc, BadgeState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, BadgeState state) {
    if (state is BadgeListSuccess) {
      badgeList = state.badgeList;
      print(state.badgeList[0].imageLink);
    } else if (state is BadgeListFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, BadgeState state) {
    return badgeList != null
        ? Column(
            children: [
              Container(
                height: ResponsiveFlutter.of(context).hp(45),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GridView.builder(
                  itemCount: badgeList!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 5 / 7),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        showCustomDialog(
                          context,
                          child: CustomDialogBody(
                            // buttonText: "Цонхыг хаах",
                            primaryColor: customColors.greyBackground,
                            child: Column(
                              children: [
                                /// Image
                                // if (Func.isNotEmpty(_notifList[index].photo))
                                if (Func.isNotEmpty(badgeList![index].imageLink!)) //todo yela
                                  Container(
                                    // margin: EdgeInsets.only(right: 15.0),
                                    // padding: EdgeInsets.all(10.0),
                                    height: 80.0,
                                    width: 80.0,
                                    child: CachedNetworkImage(
                                      imageUrl: badgeList![index].imageLink!,
                                      placeholder: (context, url) => Container(),
                                      //CustomLoader(),
                                      errorWidget: (context, url, error) => Container(),
                                      height: 80.0,
                                      width: 80.0,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),

                                /// Title
                                CustomText(
                                  "Тэмдэг авах заавар",
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: customColors.primary,
                                ),

                                /// Body
                                CustomText(
                                  badgeList![index].requirement,
                                  maxLines: 10,
                                  margin: EdgeInsets.only(bottom: 20.0),
                                ),

                                CustomButton(
                                  text: "Хаах",
                                  contentColor: customColors.primaryText,
                                  backgroundColor: customColors.greyBackground,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                            onPressedButton: () {},
                          ),
                        );
                      },
                      child: Container(
                          margin: EdgeInsets.all(5),
                          color: Colors.white,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image:
                                        DecorationImage(image: new CachedNetworkImageProvider(badgeList![index].imageLink!), fit: BoxFit.fitHeight),
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                        height: MediaQuery.of(context).size.height / 40,
                                        width: MediaQuery.of(context).size.width / 11,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(width: 1, color: Color(0xffCCFFF2)),
                                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width / 30)),
                                        margin: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).size.height / 30, left: MediaQuery.of(context).size.width / 100),
                                        child: CustomText(
                                          '${badgeList![index].acquiredCount}',
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(),
                                        )),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  badgeList![index].name,
                                  maxLines: 2,
                                  alignment: Alignment.topCenter,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )),
                    );
                  },
                ),
              ),
            ],
          )
        : Container();
  }
}
