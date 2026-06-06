import 'dart:async';

import 'package:poems_planks/core/theme/app_theme.dart';
import 'package:poems_planks/domain/entities/workout_config.dart';
import 'package:poems_planks/domain/entities/workout_phase.dart';

class WorkoutTimer {
  WorkoutTimer({required this.config});

  final WorkoutConfig config;

  final _controller = StreamController<WorkoutTick>.broadcast();
  Stream<WorkoutTick> get ticks => _controller.stream;

  Timer? _timer;
  WorkoutPhase _phase = WorkoutPhase.getReady;
  int _currentSet = 0;
  int _secondsLeft = AppDurations.getReadySeconds;
  int _millis = 0;
  double _elapsed = 0;
  bool _running = false;

  void start() {
    if (_running) return;
    _running = true;
    _emit();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }

  void resume() {
    if (_running) return;
    _running = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }

  void _tick() {
    _elapsed += 0.1;
    _millis -= 1;
    if (_millis < 0) {
      _secondsLeft--;
      _millis = 9;
    }

    if (_secondsLeft < 0 || (_secondsLeft == 0 && _millis <= 0)) {
      _advance();
      return;
    }

    _emit();
  }

  void _advance() {
    switch (_phase) {
      case WorkoutPhase.getReady:
        _phase = WorkoutPhase.plank;
        _secondsLeft = config.holdSeconds;
        _millis = 0;
      case WorkoutPhase.plank:
        if (_currentSet >= config.sets - 1) {
          _finish();
          return;
        }
        _phase = WorkoutPhase.rest;
        _secondsLeft = config.restSeconds;
        _millis = 0;
      case WorkoutPhase.rest:
        _currentSet++;
        _phase = WorkoutPhase.plank;
        _secondsLeft = config.holdSeconds;
        _millis = 0;
    }
    _emit();
  }

  void _finish() {
    pause();
    _controller.close();
  }

  void _emit() {
    if (_controller.isClosed) return;
    _controller.add(
      WorkoutTick(
        phase: _phase,
        currentSet: _currentSet,
        secondsLeft: _secondsLeft.clamp(0, 999),
        millisFraction: _millis.clamp(0, 9),
        elapsedSeconds: _elapsed,
      ),
    );
  }
}
