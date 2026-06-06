import 'package:poems_planks/data/models/catalog_model.dart';

/// Заглушка под будущую загрузку с CDN/сервера.
/// Контракт JSON — тот же, что `assets/catalog/catalog.json`.
class RemoteContentDataSource {
  const RemoteContentDataSource({required this.baseUrl});

  final String baseUrl;

  Future<CatalogModel> fetchCatalog() async {
    throw UnimplementedError(
      'Remote content not wired yet. Set ContentConfig.source = local.',
    );
  }
}
