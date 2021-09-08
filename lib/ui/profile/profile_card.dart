import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_bloc.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text.dart';

class ProfileCard extends StatefulWidget {
  final EdgeInsets? margin;

  const ProfileCard({Key? key, this.margin}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocManager.userBloc,
      child: BlocListener<UserBloc, UserState>(
        listener: _blocListener,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return (globals.userData != null && globals.userData!.rankId != null)
                ? StadiumContainer(
                    margin: widget.margin,
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.userInfo); // todo test
                    },
                    height: 80.0,
                    padding: EdgeInsets.all(15.0),
                    borderRadius: SizeHelper.borderRadiusOdd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Profile picture
                        _profilePicture(),

                        Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Name
                                CustomText(
                                  (globals.userData!.firstName ?? '') + ' ' + (globals.userData!.lastName ?? ''),
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w500,
                                ),

                                /// Rank
                                if (Func.isNotEmpty(globals.userData!.rankName))
                                  CustomText(
                                    (globals.userData!.rankName ?? '') + ' ' + 'member',
                                    color: customColors.secondaryText,
                                  ),
                              ],
                            ),
                          ),
                        ),

                        /// Button edit
                        // SvgPicture.asset(Assets.edit), // todo test
                      ],
                    ),
                  )
                : Container();
          },
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserState state) {
    if (state is UserDataSuccess) {
      print('');
    }
  }

  Widget _profilePicture() {
    return Func.isNotEmpty(globals.userData!.photo)
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            child: CachedNetworkImage(
              // imageUrl: globals.userData!.photo!, // todo test
              imageUrl:
                  'https://habido-test.s3-ap-southeast-1.amazonaws.com/test-category/3f010def-93c4-425a-bce3-9df854a2f73b.png',
              fit: BoxFit.fill,
              width: SizeHelper.boxHeight,
              height: SizeHelper.boxHeight,
              placeholder: (context, url) => CustomLoader(size: SizeHelper.boxHeight),
              errorWidget: (context, url, error) => Container(),
            ),
          )
        : Container();
  }
}
