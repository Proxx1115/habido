import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/utils/func.dart';
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
      body: Container(
        child: Hero(
          tag: Func.toStr(widget.content.contentId),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            child: CachedNetworkImage(
              imageUrl: widget.content.contentPhoto!,
              fit: BoxFit.fitHeight,
              // width: double.infinity,
              // height: imageHeight,
              placeholder: (context, url) => CustomLoader(),
              errorWidget: (context, url, error) => Container(),
            ),
          ),
        ),
      ),
    );
  }
}
