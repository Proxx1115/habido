import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/utils/func.dart';
import 'package:habido_app/utils/size_helper.dart';
import 'package:habido_app/widgets/animations/animations.dart';
import 'package:habido_app/widgets/containers.dart';
import 'package:habido_app/widgets/loaders.dart';
import 'package:habido_app/widgets/scaffold.dart';

class ContentRoute extends StatefulWidget {
  final Content content;

  const ContentRoute({Key? key, required this.content}) : super(key: key);

  @override
  _ContentRouteState createState() => _ContentRouteState();
}

class _ContentRouteState extends State<ContentRoute> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Content',
      body: SingleChildScrollView(
        child: Container(
          padding: SizeHelper.paddingScreen,
          child: Column(
            children: [
              /// Cover image
              Hero(
                tag: Func.toStr(widget.content.contentId),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                  child: CachedNetworkImage(
                    imageUrl: widget.content.contentPhoto!,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    placeholder: (context, url) => CustomLoader(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
              ),

              /// Text
              FadeInAnimation(
                delay: 2,
                child: InfoContainer(
                  margin: EdgeInsets.only(top: 15.0),
                  title: widget.content.text ?? '',
                  body: widget.content.title ?? '',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
