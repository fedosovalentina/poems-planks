import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:poems_planks/core/theme/app_theme.dart';

class AudioFadeController {
  AudioFadeController(this._player);

  final AudioPlayer _player;
  Timer? _fadeTimer;
  double _fadeElapsed = 0;

  Future<void> playFromSource(String source) async {
    if (source.startsWith('http')) {
      await _player.setUrl(source);
    } else {
      await _player.setAsset(source);
    }
    await _player.setVolume(AppDurations.lowAudioVolume);
    _fadeElapsed = 0;
    await _player.play();
    _startFade();
  }

  void _startFade() {
    _fadeTimer?.cancel();
    _fadeTimer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
      _fadeElapsed += 0.1;
      if (_fadeElapsed >= AppDurations.audioFadeSeconds) {
        await _player.setVolume(1);
        _fadeTimer?.cancel();
        return;
      }
      final t = _fadeElapsed / AppDurations.audioFadeSeconds;
      final volume =
          AppDurations.lowAudioVolume + (1 - AppDurations.lowAudioVolume) * t;
      await _player.setVolume(volume.clamp(0, 1));
    });
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();

  Future<void> dispose() async {
    _fadeTimer?.cancel();
    await _player.dispose();
  }
}
