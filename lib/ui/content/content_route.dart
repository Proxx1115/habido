import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers/containers.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:habido_app/widgets/text.dart';

class ContentRoute extends StatefulWidget {
  final Content content;

  const ContentRoute({Key? key, required this.content}) : super(key: key);

  @override
  _ContentRouteState createState() => _ContentRouteState();
}

class _ContentRouteState extends State<ContentRoute> {
  double? _imageWidth;
  final double _margin = 15.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _imageWidth =
        _imageWidth ?? MediaQuery.of(context).size.width - _margin * 2;

    return SafeArea(
      child: CustomScaffold(
        appBarTitle: LocaleKeys.advice,
        child: SingleChildScrollView(
          padding: SizeHelper.screenPadding,
          child: Column(
            children: [
              /// Cover image
              Hero(
                tag: Func.toStr(widget.content.contentId),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  child: CachedNetworkImage(
                    imageUrl: widget.content.contentPhoto!,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    // height: _imageWidth! * SizeHelper.contentImageRatio,
                    alignment: Alignment.topCenter,
                    placeholder: (context, url) => CustomLoader(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
              ),

              /// Text
              FadeInAnimation(
                delay: 1.5,
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(SizeHelper.borderRadius)),
                    color: customColors.whiteBackground,
                  ),
                  padding: SizeHelper.boxPadding,
                  child: Column(
                    children: [
                      /// Title
                      CustomText(
                        widget.content.title ?? '',
                        fontWeight: FontWeight.w600,
                        maxLines: 3,
                        alignment: Alignment.center,
                      ),

                      /// Body
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Html(
                          shrinkWrap: true,
                          data: widget.content.text ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
