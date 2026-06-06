class VideoClip {
  const VideoClip({
    required this.id,
    required this.durationSeconds,
    required this.source,
  });

  final String id;
  final int durationSeconds;
  final String source;

  bool get isRemote => source.startsWith('http');
}
