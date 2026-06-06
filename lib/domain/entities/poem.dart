class Poem {
  const Poem({
    required this.id,
    required this.title,
    required this.author,
    required this.durationSeconds,
    required this.audioSource,
    required this.lines,
  });

  final String id;
  final String title;
  final String author;
  final int durationSeconds;
  final String audioSource;
  final List<String> lines;

  bool get isRemote => audioSource.startsWith('http');
}
