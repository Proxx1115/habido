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
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';

class UserInfoRoute extends StatefulWidget {
  const UserInfoRoute({Key? key}) : super(key: key);

  @override
  _UserInfoRouteState createState() => _UserInfoRouteState();
}

class _UserInfoRouteState extends State<UserInfoRoute> {
  // Profile picture
  double _profilePictureSize = 105.0;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: LocaleKeys.userInfo,
      child: BlocProvider.value(
        value: BlocManager.userBloc,
        child: BlocListener<UserBloc, UserState>(
          listener: _blocListener,
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: SizeHelper.paddingScreen,
                child: Column(
                  children: [
                    /// Profile pic
                    _profilePicture(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, UserState state) {
    if (state is UpdateUserDataSuccess || state is UpdateProfilePictureSuccess) {
      BlocManager.userBloc.add(GetUserDataEvent());
    } else if (state is UpdateUserDataFailed) {
      showCustomDialog(
        context,
        child: CustomDialogBody(asset: Assets.error, text: state.message, buttonText: LocaleKeys.ok),
      );
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
        String base64Image = await ImageUtils.getBase64Image(context);
        if (base64Image.isNotEmpty) {
          var request = UpdateProfilePictureRequest()..photoBase64 = base64Image;
          BlocManager.userBloc.add(UpdateProfilePictureEvent(request));
        }
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          /// Image
          if (Func.isNotEmpty(globals.userData!.photo))
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(_profilePictureSize)),
                child: CachedNetworkImage(
                  imageUrl: globals.userData!.photo!,
                  fit: BoxFit.fill,
                  width: _profilePictureSize,
                  height: _profilePictureSize,
                  placeholder: (context, url) => CustomLoader(size: _profilePictureSize),
                  // placeholder: (context, url, error) => Container(),
                  errorWidget: (context, url, error) => Container(),
                ),
              ),
            ),

          /// Overlay
          Align(
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: 0.75,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(_profilePictureSize)),
                child: Container(
                  padding: EdgeInsets.all(41.0),
                  height: _profilePictureSize,
                  width: _profilePictureSize,
                  decoration: BoxDecoration(color: customColors.primary),
                  child: SvgPicture.asset(Assets.camera, color: customColors.iconWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
