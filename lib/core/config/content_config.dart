enum ContentSource { local, remote, hybrid }

abstract final class ContentConfig {
  /// Переключатель источника контента. Позже: remote / hybrid.
  static const source = ContentSource.local;
}
