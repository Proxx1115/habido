import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/bloc/bloc_manager.dart';
import 'package:habido_app/bloc/user_bloc.dart';
import 'package:habido_app/models/update_profile_picture_request.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/globals.dart';
import 'package:habido_app/utils/image_utils.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/route/routes.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/text.dart';
import 'package:image_picker/image_picker.dart';

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
                ? Container(
                    margin: widget.margin,
                    height: 80.0,
                    padding: EdgeInsets.all(15.0),
                    child: NoSplashContainer(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.userInfo);
                        },
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
                                      (globals.userData!.firstName ?? ''),
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.w500,
                                    ),

                                    /// Rank
                                    if (Func.isNotEmpty(globals.userData!.rankName))
                                      CustomText(
                                        (globals.userData!.rankName ?? ''),
                                        color: customColors.greyText,
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            /// Button edit
                            SvgPicture.asset(Assets.edit),
                          ],
                        ),
                      ),
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
    } else if (state is UpdateProfilePictureSuccess) {
      print('UpdateProfilePictureSuccess');
    } else if (state is UpdateProfilePictureFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
    }
  }

  Widget _profilePicture() {
    return InkWell(
      onTap: () async {
        showCustomDialog(
          context,
          isDismissible: true,
          child: CustomDialogBody(
            asset: Assets.camera,
            text: LocaleKeys.pleaseSelectPicture,
            buttonText: LocaleKeys.camera,
            button2Text: LocaleKeys.gallery,
            onPressedButton: () async {
              String base64Image = await ImageUtils.getBase64Image(context, ImageSource.camera);
              if (base64Image.isNotEmpty) {
                var request = UpdateProfilePictureRequest()..photoBase64 = base64Image;
                BlocManager.userBloc.add(UpdateProfilePictureEvent(request));
              }
            },
            onPressedButton2: () async {
              String base64Image = await ImageUtils.getBase64Image(context, ImageSource.gallery);
              if (base64Image.isNotEmpty) {
                var request = UpdateProfilePictureRequest()..photoBase64 = base64Image;
                BlocManager.userBloc.add(UpdateProfilePictureEvent(request));
              }
            },
          ),
        );
      },
      child: Stack(
        children: [
          /// Background
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            child: Opacity(
              opacity: 0.75,
              child: Container(
                padding: EdgeInsets.all(15.0),
                height: SizeHelper.boxHeight,
                width: SizeHelper.boxHeight,
                decoration: BoxDecoration(
                  color: customColors.primary,
                ),
                child: SvgPicture.asset(Assets.camera, color: customColors.iconWhite),
              ),
            ),
          ),

          /// Image
          if (Func.isNotEmpty(globals.userData!.photo))
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              child: CachedNetworkImage(
                imageUrl: globals.userData!.photo!,
                fit: BoxFit.fill,
                width: SizeHelper.boxHeight,
                height: SizeHelper.boxHeight,
                placeholder: (context, url) => CustomLoader(size: SizeHelper.boxHeight),
                // placeholder: (context, url, error) => Container(),
                errorWidget: (context, url, error) => Container(),
              ),
            )
        ],
      ),
    );
  }
}
