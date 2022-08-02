import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/utils/image_utils.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/dialogs.dart';
import 'package:image_picker/image_picker.dart';

class SatisfactionPhoto extends StatefulWidget {
  final Color primaryColor;
  final Function(String base64Image)? onImageCaptured;

  const SatisfactionPhoto({Key? key, required this.primaryColor, this.onImageCaptured}) : super(key: key);

  @override
  _SatisfactionPhotoState createState() => _SatisfactionPhotoState();
}

class _SatisfactionPhotoState extends State<SatisfactionPhoto> {
  final _size = 137.0;
  String? _base64Image;

  @override
  Widget build(BuildContext context) {
    return NoSplashContainer(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(_size)),
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
                  setState(() {
                    _base64Image = base64Image;
                    if (widget.onImageCaptured != null) widget.onImageCaptured!(base64Image);
                  });
                }
              },
              onPressedButton2: () async {
                String base64Image = await ImageUtils.getBase64Image(context, ImageSource.gallery);
                if (base64Image.isNotEmpty) {
                  setState(() {
                    _base64Image = base64Image;
                    if (widget.onImageCaptured != null) widget.onImageCaptured!(base64Image);
                  });
                }
              },
            ),
          );
        },
        child: Container(
          height: _size,
          width: _size,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            color: customColors.whiteBackground,
            borderRadius: BorderRadius.circular(SizeHelper.borderRadius),
            border: Border.all(width: SizeHelper.borderWidth, color: customColors.primaryBorder),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Camera
              Center(
                child: Container(
                  height: 48.0,
                  width: 48.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.primaryColor,
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: SvgPicture.asset(Assets.camera),
                ),
              ),

              /// Base 64 image
              if (_base64Image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(_size / 2),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.memory(
                      base64Decode(_base64Image!),
                      fit: BoxFit.fitWidth,
                      height: _size,
                      width: _size,
                    ),
                  ),
                ),

              // ImageUtils.base64ToImage(_base64Image!, height: _size, width: _size, fit: BoxFit.fitWidth),
            ],
          ),
        ),
      ),
    );
  }
}
