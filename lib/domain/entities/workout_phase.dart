enum WorkoutPhase { getReady, plank, rest }

class WorkoutTick {
  const WorkoutTick({
    required this.phase,
    required this.currentSet,
    required this.secondsLeft,
    required this.millisFraction,
    required this.elapsedSeconds,
  });

  final WorkoutPhase phase;
  final int currentSet;
  final int secondsLeft;
  final int millisFraction;
  final double elapsedSeconds;
}
