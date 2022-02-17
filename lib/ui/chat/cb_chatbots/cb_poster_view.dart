import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habido_app/utils/assets.dart';
import 'package:habido_app/widgets/buttons.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'cb_poster.dart';

class PosterView extends StatefulWidget {
  final PageController pageController;
  final List<CBPoster> posters;
  final int currentIndex;

  PosterView({
    Key? key,
    required this.posters,
    this.currentIndex = 0,
  }) : pageController = PageController(initialPage: currentIndex);

  @override
  _PosterViewState createState() => _PosterViewState();
}

class _PosterViewState extends State<PosterView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topLeft,
          children: [
            PhotoViewGallery.builder(
                pageController: widget.pageController,
                itemCount: widget.posters.length,
                builder: (context, index) {
                  final poster = widget.posters[index];
                  return PhotoViewGalleryPageOptions(imageProvider: NetworkImage(poster.link!));
                }),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ButtonStadium(
                asset: Assets.back,
                onPressed: () {
                  // Btn back
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
