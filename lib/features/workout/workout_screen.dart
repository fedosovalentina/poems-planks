import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:poems_planks/app/app.dart';
import 'package:poems_planks/core/theme/app_theme.dart';
import 'package:poems_planks/domain/entities/poem.dart';
import 'package:poems_planks/domain/entities/workout_config.dart';
import 'package:poems_planks/domain/entities/workout_phase.dart';
import 'package:poems_planks/domain/repositories/content_repository.dart';
import 'package:poems_planks/domain/repositories/streak_repository.dart';
import 'package:poems_planks/domain/services/audio_fade_controller.dart';
import 'package:poems_planks/domain/services/workout_timer.dart';

typedef OnWorkoutFinished = void Function(WorkoutResult result);

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({
    super.key,
    required this.config,
    required this.poem,
    required this.contentRepository,
    required this.streakRepository,
    required this.onFinished,
  });

  final WorkoutConfig config;
  final Poem poem;
  final ContentRepository contentRepository;
  final StreakRepository streakRepository;
  final OnWorkoutFinished onFinished;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late final WorkoutTimer _timer = WorkoutTimer(config: widget.config);
  late final AudioFadeController _audio =
      AudioFadeController(AudioPlayer());

  StreamSubscription<WorkoutTick>? _tickSub;
  bool _audioStarted = false;
  bool _paused = false;
  WorkoutTick? _tick;

  @override
  void initState() {
    super.initState();
    _tickSub = _timer.ticks.listen(_onTick, onDone: _onDone);
    _timer.start();
  }

  void _onTick(WorkoutTick tick) {
    if (!_audioStarted &&
        tick.phase == WorkoutPhase.plank &&
        tick.currentSet == 0) {
      _audioStarted = true;
      _audio.playFromSource(widget.poem.audioSource);
    }
    setState(() => _tick = tick);
  }

  Future<void> _onDone() async {
    final streak = await widget.streakRepository.recordCompletedSession(DateTime.now());
    if (!mounted) return;
    widget.onFinished(
      WorkoutResult(
        poemTitle: widget.poem.title,
        poemAuthor: widget.poem.author,
        plankSeconds: widget.config.totalPlankSeconds,
        streakDays: streak.days,
      ),
    );
  }

  Future<void> _togglePause() async {
    setState(() => _paused = !_paused);
    if (_paused) {
      _timer.pause();
      await _audio.pause();
    } else {
      _timer.resume();
      await _audio.resume();
    }
  }

  String get _phaseLabel {
    return switch (_tick?.phase) {
      WorkoutPhase.getReady => 'готовься',
      WorkoutPhase.rest => 'пауза',
      WorkoutPhase.plank || null => 'планка',
    };
  }

  String? get _floatingLine {
    if (_tick?.phase == WorkoutPhase.getReady || widget.poem.lines.isEmpty) {
      return null;
    }
    final idx = (_tick!.elapsedSeconds / 4).floor() % widget.poem.lines.length;
    return widget.poem.lines[idx];
  }

  @override
  void dispose() {
    _tickSub?.cancel();
    _timer.dispose();
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tick = _tick;
    final random = Random(tick?.elapsedSeconds.toInt() ?? 0);

    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppTheme.background),
          if (_floatingLine != null)
            Positioned(
              top: 180 + random.nextDouble() * 200,
              left: 24 + random.nextDouble() * 80,
              right: 48,
              child: Text(
                _floatingLine!,
                style: TextStyle(
                  color: AppTheme.paper.withValues(alpha: 0.72),
                  fontSize: 16 + random.nextDouble() * 4,
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: _togglePause,
                        child: Text(_paused ? 'продолжить' : 'пауза'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('стоп'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.poem.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, color: AppTheme.paper),
                  ),
                  Text(
                    widget.poem.author,
                    style: const TextStyle(fontSize: 10, color: Colors.white38),
                  ),
                  const Spacer(),
                  if (tick != null)
                    Column(
                      children: [
                        Text(
                          '${tick.secondsLeft}.${tick.millisFraction}',
                          style: const TextStyle(
                            fontSize: 64,
                            color: AppTheme.neon,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          _phaseLabel,
                          style: const TextStyle(
                            letterSpacing: 4,
                            color: AppTheme.neon,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'подход ${tick.currentSet + 1}/${widget.config.sets}',
                          style: const TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
