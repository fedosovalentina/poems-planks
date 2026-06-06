import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poems_planks/core/theme/app_theme.dart';
import 'package:poems_planks/data/datasources/local/asset_content_datasource.dart';
import 'package:poems_planks/data/datasources/local/local_streak_datasource.dart';
import 'package:poems_planks/data/repositories/content_repository_impl.dart';
import 'package:poems_planks/data/repositories/streak_repository_impl.dart';
import 'package:poems_planks/domain/entities/poem.dart';
import 'package:poems_planks/domain/entities/workout_config.dart';
import 'package:poems_planks/features/setup/setup_screen.dart';
import 'package:poems_planks/features/summary/summary_screen.dart';
import 'package:poems_planks/features/workout/workout_screen.dart';

class PoemPlankApp extends StatefulWidget {
  const PoemPlankApp({super.key});

  @override
  State<PoemPlankApp> createState() => _PoemPlankAppState();
}

class _PoemPlankAppState extends State<PoemPlankApp> {
  late final _contentRepo = ContentRepositoryImpl(AssetContentDataSource());
  late final _streakRepo = StreakRepositoryImpl(LocalStreakDataSource());
  late final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SetupScreen(
          contentRepository: _contentRepo,
          onStart: (config, poem) => context.go('/workout', extra: (config, poem)),
        ),
      ),
      GoRoute(
        path: '/workout',
        builder: (context, state) {
          final (config, poem) = state.extra! as (WorkoutConfig, Poem);
          return WorkoutScreen(
            config: config,
            poem: poem,
            contentRepository: _contentRepo,
            streakRepository: _streakRepo,
            onFinished: (result) => context.go('/summary', extra: result),
          );
        },
      ),
      GoRoute(
        path: '/summary',
        builder: (context, state) {
          final result = state.extra! as WorkoutResult;
          return SummaryScreen(
            result: result,
            onAgain: () => context.go('/'),
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Poem & Plank',
      theme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}

class WorkoutResult {
  const WorkoutResult({
    required this.poemTitle,
    required this.poemAuthor,
    required this.plankSeconds,
    required this.streakDays,
  });

  final String poemTitle;
  final String poemAuthor;
  final int plankSeconds;
  final int streakDays;
}
