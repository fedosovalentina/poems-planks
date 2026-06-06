import 'package:poems_planks/data/datasources/local/asset_content_datasource.dart';
import 'package:poems_planks/domain/entities/poem.dart';
import 'package:poems_planks/domain/entities/video_clip.dart';
import 'package:poems_planks/domain/repositories/content_repository.dart';

class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl(this._local);

  final AssetContentDataSource _local;

  @override
  Future<List<Poem>> getPoems() => _local.getPoems();

  @override
  Future<List<VideoClip>> getVideos() => _local.getVideos();

  @override
  Future<Poem?> getPoemById(String id) async {
    final poems = await getPoems();
    for (final poem in poems) {
      if (poem.id == id) return poem;
    }
    return null;
  }
}
