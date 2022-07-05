import 'package:flutter/material.dart';
import 'package:habido_app/models/advice_video_response.dart';
import 'package:habido_app/widgets/scaffold.dart';
import 'package:habido_app/widgets/video_player/video_player.dart';

class AdviceRoute extends StatefulWidget {
  final AdviceVideoResponse adviceVideo;
  const AdviceRoute({Key? key, required this.adviceVideo}) : super(key: key);

  @override
  State<AdviceRoute> createState() => _AdviceRouteState();
}

class _AdviceRouteState extends State<AdviceRoute> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => VideoPlayer(
          videoURL: widget.adviceVideo.video!,
          height: MediaQuery.of(context).size.width * 16 / 9,
        ),
      ),
    );
  }
}
