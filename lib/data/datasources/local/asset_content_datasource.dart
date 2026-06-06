import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:poems_planks/data/models/catalog_model.dart';
import 'package:poems_planks/domain/entities/poem.dart';
import 'package:poems_planks/domain/entities/video_clip.dart';

class AssetContentDataSource {
  static const catalogPath = 'assets/catalog/catalog.json';

  Future<CatalogModel> loadCatalog() async {
    final raw = await rootBundle.loadString(catalogPath);
    return CatalogModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<List<Poem>> getPoems() async {
    final catalog = await loadCatalog();
    return catalog.poems;
  }

  Future<List<VideoClip>> getVideos() async {
    final catalog = await loadCatalog();
    return catalog.videos;
  }
}
