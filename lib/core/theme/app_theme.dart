import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const neon = Color(0xFF39FF7A);
  static const paper = Color(0xFFE8E3DA);
  static const background = Color(0xFF111111);

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: neon,
        surface: background,
        onSurface: paper,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: paper),
      ),
    );
  }
}

abstract final class AppDurations {
  static const getReadySeconds = 10;
  static const audioFadeSeconds = 10;
  static const poemMatchMinOffsetSeconds = 10;
  static const poemMatchMaxOffsetSeconds = 60;
  static const lowAudioVolume = 0.2;
}
