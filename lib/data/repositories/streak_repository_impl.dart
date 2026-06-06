import 'package:poems_planks/data/datasources/local/local_streak_datasource.dart';
import 'package:poems_planks/domain/entities/streak.dart';
import 'package:poems_planks/domain/repositories/streak_repository.dart';

class StreakRepositoryImpl implements StreakRepository {
  StreakRepositoryImpl(this._local);

  final LocalStreakDataSource _local;

  @override
  Future<Streak> getStreak() async {
    return Streak(days: await _local.getDays());
  }

  @override
  Future<Streak> recordCompletedSession(DateTime completedAt) async {
    final days = await _local.recordSession(completedAt);
    return Streak(days: days);
  }
}
