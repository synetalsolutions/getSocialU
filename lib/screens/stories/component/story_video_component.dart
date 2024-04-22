import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/stories/screen/story_page.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:video_player/video_player.dart' as vc;
import 'package:visibility_detector/visibility_detector.dart';

class CreateVideoStory extends StatefulWidget {
  final File videoFile;
  final bool isShowControllers;

  CreateVideoStory({required this.videoFile, this.isShowControllers = true});

  @override
  State<CreateVideoStory> createState() => _CreateVideoStoryState();
}

class _CreateVideoStoryState extends State<CreateVideoStory> {
  late CachedVideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  GlobalKey storyVisibilityKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    videoPlayerController = CachedVideoPlayerController.file(widget.videoFile)..initialize().then((value) => setState(() {}));
    videoPlayerController.play();

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        enterFullscreenButton: Image.asset(ic_full_screen, color: Colors.white, width: 16, height: 16).paddingAll(4),
        exitFullscreenButton: Image.asset(ic_exit_full_screen, color: Colors.white, width: 16, height: 16).paddingAll(4),
        playButton: Image.asset(ic_play_button, color: Colors.white, width: 16, height: 16).paddingAll(4),
        pauseButton: Image.asset(ic_pause, color: Colors.white, width: 16, height: 16).paddingAll(4),
        playbackSpeedButtonAvailable: false,
        settingsButtonAvailable: false,
        playOnlyOnce: false,
      ),
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      height: context.height(),
      decoration: BoxDecoration(color: Colors.black),
      padding: EdgeInsets.only(bottom: 180),
      child: CustomVideoPlayer(
        customVideoPlayerController: _customVideoPlayerController,
      ),
    );
  }
}

class CreateVideoThumbnail extends StatefulWidget {
  final File? videoFile;

  const CreateVideoThumbnail({this.videoFile});

  @override
  State<CreateVideoThumbnail> createState() => _CreateVideoThumbnailState();
}

class _CreateVideoThumbnailState extends State<CreateVideoThumbnail> {
  late vc.VideoPlayerController controller;

  @override
  void initState() {
    controller = vc.VideoPlayerController.file(widget.videoFile!)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (controller.value.isInitialized) {
      return vc.VideoPlayer(controller).cornerRadiusWithClipRRect(defaultAppButtonRadius);
    } else {
      return Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: radius(defaultAppButtonRadius),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Image.asset(ic_video, height: 20, width: 20, fit: BoxFit.contain),
      );
    }
  }
}

class ShowVideoThumbnail extends StatefulWidget {
  final String? videoUrl;

  const ShowVideoThumbnail({this.videoUrl});

  @override
  State<ShowVideoThumbnail> createState() => ShowVideoThumbnailState();
}

class ShowVideoThumbnailState extends State<ShowVideoThumbnail> {
  String videoUrl = '';

  late vc.VideoPlayerController controller;

  @override
  void initState() {
    videoUrl = widget.videoUrl.validate();

    super.initState();
    init();
  }

  void init() {
    controller = vc.VideoPlayerController.network(widget.videoUrl.validate())
      ..initialize().then((_) {
        setState(() {});
      });
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl != videoUrl) {
      init();
      videoUrl = widget.videoUrl.validate();
    }
    return controller.value.isInitialized ? vc.VideoPlayer(controller).cornerRadiusWithClipRRect(24) : Image.asset(ic_video, height: 18, width: 18, fit: BoxFit.cover).paddingAll(8);
  }
}

class StoryVideoPostComponent extends StatefulWidget {
  final String videoURl;
  final bool isShowControllers;

  StoryVideoPostComponent({
    super.key,
    required this.videoURl,
    this.isShowControllers = true,
  });

  @override
  State<StoryVideoPostComponent> createState() => _StoryVideoPostComponentState();
}

class _StoryVideoPostComponentState extends State<StoryVideoPostComponent> {
  late vc.VideoPlayerController videoPlayerController;
  bool isVideoVisible = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    videoPlayerController = vc.VideoPlayerController.network(
      widget.videoURl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false, allowBackgroundPlayback: true),
    );

    globalVideoPlayerController = videoPlayerController;

    videoPlayerController.initialize();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    videoPlayerController.pause();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (visibilityInfo) {
        if (widget.videoURl != videoPlayerController.dataSource) {
          videoPlayerController.pause();
          init();
          videoPlayerController.play();
          videoPlayerController.setLooping(true);
        } else {
          videoPlayerController.pause();
        }

        setState(() {
          isVideoVisible = visibilityInfo.visibleFraction > 0.5;
        });

        if (!isVideoVisible) {
          videoPlayerController.pause();
        } else if (!videoPlayerController.value.isPlaying) {
          if (mounted) videoPlayerController.play();
        }
      },
      child: SizedBox(
        width: context.width(),
        height: context.height() * 0.8,
        child: AspectRatio(
          aspectRatio: videoPlayerController.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              vc.VideoPlayer(videoPlayerController),

              vc.VideoProgressIndicator(videoPlayerController, allowScrubbing: true),
            ],
          ),
        ),
      ).center(),
    );
  }
}
