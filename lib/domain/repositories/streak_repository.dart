import 'package:poems_planks/domain/entities/streak.dart';

abstract class StreakRepository {
  Future<Streak> getStreak();
  Future<Streak> recordCompletedSession(DateTime completedAt);
}
