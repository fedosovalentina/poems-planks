import 'dart:math';

import 'package:poems_planks/core/theme/app_theme.dart';
import 'package:poems_planks/domain/entities/poem.dart';
import 'package:poems_planks/domain/entities/workout_config.dart';

class PoemMatcher {
  const PoemMatcher();

  DurationRange rangeFor(WorkoutConfig config) {
    final total = config.totalSeconds;
    return DurationRange(
      minSeconds: total - AppDurations.poemMatchMinOffsetSeconds,
      maxSeconds: total + AppDurations.poemMatchMaxOffsetSeconds,
    );
  }

  List<Poem> matching(List<Poem> all, WorkoutConfig config) {
    final range = rangeFor(config);
    return all
        .where(
          (p) =>
              p.durationSeconds >= range.minSeconds &&
              p.durationSeconds <= range.maxSeconds,
        )
        .toList();
  }

  Poem? pickDefault(List<Poem> all, WorkoutConfig config) {
    final matched = matching(all, config);
    if (matched.isEmpty) return null;
    return matched[Random().nextInt(matched.length)];
  }
}

class DurationRange {
  const DurationRange({required this.minSeconds, required this.maxSeconds});

  final int minSeconds;
  final int maxSeconds;
}
