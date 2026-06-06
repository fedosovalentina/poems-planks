import 'package:flutter/material.dart';
import 'package:poems_planks/core/theme/app_theme.dart';
import 'package:poems_planks/domain/entities/poem.dart';
import 'package:poems_planks/domain/entities/workout_config.dart';
import 'package:poems_planks/domain/repositories/content_repository.dart';
import 'package:poems_planks/domain/services/poem_matcher.dart';

typedef OnWorkoutStart = void Function(WorkoutConfig config, Poem poem);

class SetupScreen extends StatefulWidget {
  const SetupScreen({
    super.key,
    required this.contentRepository,
    required this.onStart,
  });

  final ContentRepository contentRepository;
  final OnWorkoutStart onStart;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _matcher = const PoemMatcher();

  int _sets = 3;
  int _hold = 35;
  int _rest = 10;

  List<Poem> _allPoems = [];
  List<Poem> _matchedPoems = [];
  Poem? _selectedPoem;
  bool _loading = true;

  WorkoutConfig get _config =>
      WorkoutConfig(sets: _sets, holdSeconds: _hold, restSeconds: _rest);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final poems = await widget.contentRepository.getPoems();
    if (!mounted) return;
    setState(() {
      _allPoems = poems;
      _loading = false;
      _refreshMatches();
    });
  }

  void _refreshMatches() {
    _matchedPoems = _matcher.matching(_allPoems, _config);
    _selectedPoem ??= _matcher.pickDefault(_allPoems, _config);
    if (_selectedPoem != null &&
        !_matchedPoems.any((p) => p.id == _selectedPoem!.id)) {
      _selectedPoem = _matcher.pickDefault(_allPoems, _config);
    }
  }

  void _adjust(String key, int delta) {
    setState(() {
      switch (key) {
        case 'sets':
          _sets = (_sets + delta).clamp(1, 10);
        case 'hold':
          _hold = (_hold + delta).clamp(5, 300);
        case 'rest':
          _rest = (_rest + delta).clamp(5, 60);
      }
      _refreshMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _config.totalSeconds;
    final range = _matcher.rangeFor(_config);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.neon))
              : Column(
                  children: [
                    const Text(
                      'POEM & PLANK',
                      style: TextStyle(
                        letterSpacing: 4,
                        fontSize: 10,
                        color: Colors.white38,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedPoem != null) ...[
                      SizedBox(
                        height: 120,
                        child: PageView.builder(
                          controller: PageController(
                            initialPage: _matchedPoems.indexOf(_selectedPoem!).clamp(0, 999),
                          ),
                          itemCount: _matchedPoems.length,
                          onPageChanged: (i) =>
                              setState(() => _selectedPoem = _matchedPoems[i]),
                          itemBuilder: (_, i) {
                            final poem = _matchedPoems[i];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  poem.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: AppTheme.paper,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  poem.author,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 2,
                                    color: Colors.white38,
                                  ),
                                ),
                                Text(
                                  '${poem.durationSeconds} сек',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.neon,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Text(
                        'подходят: ${range.minSeconds}–${range.maxSeconds} сек',
                        style: const TextStyle(fontSize: 10, color: Colors.white24),
                      ),
                      const SizedBox(height: 24),
                    ] else
                      const Text(
                        'Нет поэм под эту длительность',
                        style: TextStyle(color: Colors.white54),
                      ),
                    _row('Подходы', 'sets', _sets, 'раз'),
                    _row('Держать', 'hold', _hold, 'сек', step: 5),
                    _row('Отдых', 'rest', _rest, 'сек', step: 5),
                    Text(
                      'итого ~$total сек',
                      style: const TextStyle(fontSize: 10, color: Colors.white38),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _selectedPoem == null
                            ? null
                            : () => widget.onStart(_config, _selectedPoem!),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.neon,
                          side: const BorderSide(color: AppTheme.neon),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: const Text('Начать', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _row(String label, String key, int value, String unit, {int step = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ),
          IconButton(
            onPressed: () => _adjust(key, -step),
            icon: const Icon(Icons.remove, color: AppTheme.paper, size: 18),
          ),
          Text('$value', style: const TextStyle(fontSize: 22, color: AppTheme.paper)),
          IconButton(
            onPressed: () => _adjust(key, step),
            icon: const Icon(Icons.add, color: AppTheme.paper, size: 18),
          ),
          Text(unit, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }
}
