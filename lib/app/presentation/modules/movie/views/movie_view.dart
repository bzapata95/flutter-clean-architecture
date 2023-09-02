import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/widgets/request_failed.dart';
import '../controller/movie_controller.dart';
import '../controller/state/movie_state.dart';
import 'widgets/movie_app_bar.dart';
import 'widgets/movie_content.dart';

class MovieView extends StatelessWidget {
  const MovieView({super.key, required this.movieId});
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MovieController(
              MovieState.loading(),
              moviesRepository: context.read(),
              movieId: movieId,
            )..init(),
        builder: (context, _) {
          final MovieController movieController = context.watch();
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: const MovieAppBar(),
              body: movieController.state.map(
                loading: (_) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                failed: (_) => RequestFailed(onRetry: () {
                  movieController.init();
                }),
                loaded: (state) {
                  return MovieContent(
                    state: state,
                  );
                },
              ));
        });
  }
}
