import 'package:poems_planks/domain/entities/poem.dart';
import 'package:poems_planks/domain/entities/video_clip.dart';

class CatalogModel {
  CatalogModel({required this.poems, required this.videos});

  factory CatalogModel.fromJson(Map<String, dynamic> json) {
    return CatalogModel(
      poems: (json['poems'] as List<dynamic>)
          .map((e) => Poem(
                id: e['id'] as String,
                title: e['title'] as String,
                author: e['author'] as String,
                durationSeconds: e['durationSeconds'] as int,
                audioSource: e['audioSource'] as String,
                lines: (e['lines'] as List<dynamic>).cast<String>(),
              ))
          .toList(),
      videos: (json['videos'] as List<dynamic>)
          .map((e) => VideoClip(
                id: e['id'] as String,
                durationSeconds: e['durationSeconds'] as int,
                source: e['source'] as String,
              ))
          .toList(),
    );
  }

  final List<Poem> poems;
  final List<VideoClip> videos;
}
