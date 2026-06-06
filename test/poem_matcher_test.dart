import 'package:flutter_test/flutter_test.dart';
import 'package:poems_planks/domain/entities/poem.dart';
import 'package:poems_planks/domain/entities/workout_config.dart';
import 'package:poems_planks/domain/services/poem_matcher.dart';

void main() {
  test('poem matcher uses total workout duration window', () {
    const matcher = PoemMatcher();
    const config = WorkoutConfig(sets: 3, holdSeconds: 35, restSeconds: 10);

    const poems = [
      Poem(
        id: 'short',
        title: 'a',
        author: 'b',
        durationSeconds: 100,
        audioSource: 'x',
        lines: [],
      ),
      Poem(
        id: 'fit',
        title: 'a',
        author: 'b',
        durationSeconds: 125,
        audioSource: 'x',
        lines: [],
      ),
      Poem(
        id: 'long',
        title: 'a',
        author: 'b',
        durationSeconds: 200,
        audioSource: 'x',
        lines: [],
      ),
    ];

    final matched = matcher.matching(poems, config);
    expect(config.totalSeconds, 125);
    expect(matched.map((p) => p.id), ['fit']);
  });
}
