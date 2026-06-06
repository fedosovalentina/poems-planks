class WorkoutConfig {
  const WorkoutConfig({
    required this.sets,
    required this.holdSeconds,
    required this.restSeconds,
  });

  final int sets;
  final int holdSeconds;
  final int restSeconds;

  int get totalSeconds => sets * holdSeconds + (sets - 1) * restSeconds;

  int get totalPlankSeconds => sets * holdSeconds;
}
