import 'package:go_router/go_router.dart';
import 'package:three_phases/features/game/presentation/manger/game_cubit/game_cubit.dart';
import 'package:three_phases/features/game/presentation/views/hosted_game_view/hosted_game_view.dart';
import 'package:three_phases/features/game/presentation/views/joined_game_view/joined_game_view.dart';
import 'package:three_phases/features/game/presentation/views/words_done_view/words_done_view.dart';
import 'package:three_phases/features/home/presentation/views/custom_words/custom_words.dart';
import 'package:three_phases/features/home/presentation/views/home_view/home_view.dart';
import 'package:three_phases/features/home/presentation/views/host_game_view/host_game_view.dart';
import 'package:three_phases/core/models/game_model.dart';
import 'package:three_phases/features/home/data/repositories/intiate_game_repo.dart';
import 'package:three_phases/features/home/presentation/mangers/intiate_game/intiate_game_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AppRoutes {
  static const String hostView = '/host-game';
  static const String joinView = '/join-game';
  static const String hostedGameView = '/hosted-game';
  static const String homeView = '/';
  static const String wordsDoneView = '/words-done';
  static const String customWordsView = '/custom-words';
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder:
            (context, state) => BlocProvider(
              create:
                  (context) =>
                      IntiateGameCubit(GetIt.instance.get<IntiateGameRepo>()),
              child: const HomeView(),
            ),
      ),
      GoRoute(
        path: hostView,
        builder: (context, state) {
          final game = state.extra as GameModel;
          return BlocProvider(
            create:
                (context) =>
                    IntiateGameCubit(GetIt.instance.get<IntiateGameRepo>()),
            child: HostGameView(game: game),
          );
        },
      ),
      GoRoute(
        path: hostedGameView,
        builder: (context, state) {
          final game = state.extra as GameModel;
          return BlocProvider(
            create: (context) => GameCubit(),
            child: HostedGameView(game: game),
          );
        },
      ),
      GoRoute(
        path: joinView,
        builder: (context, state) {
          final game = state.extra as GameModel;
          return BlocProvider(
            create:
                (context) =>
                    GameCubit(),
            child: JoinedGameView(game: game),
          );
        },
      ),
      GoRoute(
        path: wordsDoneView,
        builder: (context, state) {
          final game = state.extra as GameModel;
          return BlocProvider(
            create: (context) => GameCubit(),
            child: WordsDoneView(game: game),
          );
        },
      ),
      GoRoute(
        path: customWordsView,
        builder: (context, state) {
          final game = state.extra as GameModel;
          return BlocProvider(
            create: (context) => IntiateGameCubit(GetIt.instance.get<IntiateGameRepo>()),
            child: CustomWords(game: game),
          );
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
