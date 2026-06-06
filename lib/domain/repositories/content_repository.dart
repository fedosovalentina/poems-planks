import 'package:poems_planks/domain/entities/poem.dart';
import 'package:poems_planks/domain/entities/video_clip.dart';

abstract class ContentRepository {
  Future<List<Poem>> getPoems();
  Future<List<VideoClip>> getVideos();
  Future<Poem?> getPoemById(String id);
}
