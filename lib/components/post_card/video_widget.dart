import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/models.dart';
import 'package:video_player/video_player.dart';

bool isMute = false;

class VideoPostTile extends StatefulWidget {
  final PostGallery? media;
  final double width;
  final String url;
  final bool isLocalFile;
  final bool play;
  final VoidCallback onTapActionHandler;

  const VideoPostTile({
    super.key,
    this.media,
    required this.width,
    required this.url,
    required this.isLocalFile,
    required this.play,
    required this.onTapActionHandler,
  });

  @override
  State<VideoPostTile> createState() => _VideoPostTileState();
}

class _VideoPostTileState extends State<VideoPostTile> {
  late Future<void> initializeVideoPlayerFuture;
  VideoPlayerController? videoPlayerController;
  late bool playVideo;

  @override
  void initState() {
    super.initState();
    playVideo = widget.play;
    _prepareVideo(url: widget.url, isLocalFile: widget.isLocalFile);
  }

  @override
  void didUpdateWidget(covariant VideoPostTile oldWidget) {
    _prepareVideo(url: widget.url, isLocalFile: widget.isLocalFile);
    playVideo = widget.play;

    if (playVideo) {
      _play();
    } else {
      _pause();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _clear();
    super.dispose();
  }

  void _clear() {
    videoPlayerController?.pause();
    videoPlayerController?.dispose();
    videoPlayerController?.removeListener(_checkVideoProgress);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        child: Stack(
          children: [
            _buildVideoPlayer(),
            _buildMuteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            height: widget.width / videoPlayerController!.value.aspectRatio,
            key: PageStorageKey(widget.url),
            child: Chewie(
              key: PageStorageKey(widget.url),
              controller: ChewieController(
                videoPlayerController: videoPlayerController!,
                aspectRatio: videoPlayerController!.value.aspectRatio,
                showControls: false,
                autoInitialize: true,
                looping: false,
                autoPlay: false,
                allowMuting: true,
                placeholder: _buildPlaceholder(),
                errorBuilder: (context, errorMessage) {
                  return Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return _buildPlaceholder();
        }
      },
    );
  }

  Widget _buildPlaceholder() {
    return widget.media == null
        ? Container()
        : CachedNetworkImage(
            imageUrl: widget.media!.thumbnail,
            fit: BoxFit.cover,
            width: Get.width,
          );
  }

  Widget _buildMuteButton() {
    return Positioned(
      right: 10,
      bottom: 10,
      child: Container(
        height: 25,
        width: 25,
        color: Colors.black38,
        child: ThemeIconWidget(
          isMute ? ThemeIcon.micOff : ThemeIcon.mic,
          size: 15,
          color: Colors.white,
        ),
      ).circular,
    );
  }

  void _handleTap() {
    if (isMute) {
      _unMuteAudio();
    } else {
      _muteAudio();
    }
    widget.onTapActionHandler();
  }

  void _prepareVideo({required String url, required bool isLocalFile}) {
    _clear();
    videoPlayerController?.pause();

    videoPlayerController = isLocalFile
        ? VideoPlayerController.file(File(url))
        : VideoPlayerController.networkUrl(Uri.parse(url));

    initializeVideoPlayerFuture = videoPlayerController!.initialize().then((_) {
      setState(() {});
    });

    videoPlayerController!.addListener(_checkVideoProgress);
  }

  void _unMuteAudio() {
    videoPlayerController!.setVolume(1);
    setState(() => isMute = false);
  }

  void _muteAudio() {
    videoPlayerController!.setVolume(0);
    setState(() => isMute = true);
  }

  void _play() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => playVideo = true);
    });

    videoPlayerController!.play().then(
          (value) => videoPlayerController!.addListener(_checkVideoProgress),
        );

    if (isMute) {
      videoPlayerController!.setVolume(0);
    }
  }

  void _pause() {
    videoPlayerController!.pause();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void _checkVideoProgress() {
    if (videoPlayerController!.value.position ==
            videoPlayerController!.value.duration &&
        videoPlayerController!.value.duration >
            const Duration(milliseconds: 1)) {
      if (!mounted) return;

      setState(() {
        videoPlayerController!.removeListener(_checkVideoProgress);
      });
    }
  }
}

class FullScreenVideoPostTile extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const FullScreenVideoPostTile({
    super.key,
    required this.videoPlayerController,
  });

  @override
  State<FullScreenVideoPostTile> createState() =>
      _FullScreenVideoPostTileState();
}

class _FullScreenVideoPostTileState extends State<FullScreenVideoPostTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        _buildVideoPlayer(),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ThemeIconWidget(
          ThemeIcon.backArrow,
          size: 20,
        ).ripple(() => Navigator.of(context).pop()),
      ),
    ).hp(DesignConstants.horizontalPadding);
  }

  Widget _buildVideoPlayer() {
    return Expanded(
      key: UniqueKey(),
      child: Chewie(
        key: UniqueKey(),
        controller: ChewieController(
          videoPlayerController: widget.videoPlayerController,
          aspectRatio: widget.videoPlayerController.value.aspectRatio,
          showControls: false,
          autoInitialize: true,
          looping: false,
          autoPlay: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
