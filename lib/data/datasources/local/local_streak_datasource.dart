import 'package:shared_preferences/shared_preferences.dart';

class LocalStreakDataSource {
  static const _keyDays = 'streak_days';
  static const _keyLastDate = 'streak_last_date';

  Future<int> getDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDays) ?? 0;
  }

  Future<int> recordSession(DateTime completedAt) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _dateKey(completedAt);
    final last = prefs.getString(_keyLastDate);
    var days = prefs.getInt(_keyDays) ?? 0;

    if (last == today) return days;

    if (last == _dateKey(completedAt.subtract(const Duration(days: 1)))) {
      days += 1;
    } else {
      days = 1;
    }

    await prefs.setInt(_keyDays, days);
    await prefs.setString(_keyLastDate, today);
    return days;
  }

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
