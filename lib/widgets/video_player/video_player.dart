import 'package:flutter/material.dart';
import 'package:habido_app/utils/theme/custom_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String videoURL;
  final double? height;
  const VideoPlayer({Key? key, required this.videoURL, this.height}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  _convertUrlToId() {
    try {
      return YoutubePlayer.convertUrlToId(widget.videoURL)!;
    } on Exception catch (exception) {
      return "";
    } catch (error) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: _convertUrlToId(),
          flags: YoutubePlayerFlags(
            hideControls: false,
            controlsVisibleAtStart: true,
            autoPlay: false,
            mute: false,
          ),
        ),
        showVideoProgressIndicator: true,
        aspectRatio: 16 / 9,
        progressIndicatorColor: customColors.primary,
      ),
    );
  }
}
