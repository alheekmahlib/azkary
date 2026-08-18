part of '../../feedback.dart';

/// معرض وسائط رسالة الملاحظة (صور + فيديو) — يُعرض داخل bubble المحادثة.
///
/// يعرض الصور عبر `Image.network` مع عارض ملء الشاشة عند الضغط،
/// والفيديو عبر مشغل مدمج مبني على `video_player`.
class FeedbackMediaGallery extends StatelessWidget {
  const FeedbackMediaGallery({super.key, required this.urls});

  /// قائمة روابط الوسائط.
  final List<String> urls;

  bool _isVideo(String url) {
    final lower = url.toLowerCase().split('?').first;
    return lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov');
  }

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: urls.map((url) => _mediaThumb(context, url)).toList(),
    );
  }

  Widget _mediaThumb(BuildContext context, String url) {
    final isVideo = _isVideo(url);
    return GestureDetector(
      onTap: () => _openViewer(context, url, isVideo),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)).r,
        child: SizedBox(
          width: 110.w,
          height: 110.w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return ColoredBox(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.1),
                    child: Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stack) => ColoredBox(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.1),
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              if (isVideo)
                Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 36.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openViewer(BuildContext context, String url, bool isVideo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenMedia(url: url, isVideo: isVideo),
      ),
    );
  }
}

/// عارض ملء الشاشة للوسائط: فيديو عبر [_FeedbackVideoPlayer]،
/// صورة عبر `InteractiveViewer` للتكبير/التصغير.
class _FullScreenMedia extends StatelessWidget {
  const _FullScreenMedia({required this.url, required this.isVideo});

  final String url;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: isVideo
            ? Center(child: _FeedbackVideoPlayer(url: url))
            : InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.network(
                    url,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stack) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

/// مشغل فيديو شبكي مبني على `video_player` مع تكرار تلقائي.
class _FeedbackVideoPlayer extends StatefulWidget {
  const _FeedbackVideoPlayer({required this.url});

  final String url;

  @override
  State<_FeedbackVideoPlayer> createState() => _FeedbackVideoPlayerState();
}

class _FeedbackVideoPlayerState extends State<_FeedbackVideoPlayer> {
  late final VideoPlayerController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller.setLooping(true);
    _controller.initialize().then((_) {
      if (mounted) {
        _controller.play();
        setState(() {});
      }
    }).catchError((e) {
      if (mounted) setState(() => _hasError = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.error_outline, color: Colors.grey, size: 40),
        ),
      );
    }
    if (!_controller.value.isInitialized) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        const Gap(8),
      ],
    );
  }
}
