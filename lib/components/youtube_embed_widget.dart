import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialv/components/youtube_player_component.dart';

class YouTubeEmbedWidget extends StatelessWidget {
  final String videoId;
  final bool? fullIFrame;

  YouTubeEmbedWidget(this.videoId, {this.fullIFrame});

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerComponent(id: videoId);
  }
}
