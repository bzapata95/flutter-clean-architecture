import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../global/controllers/favorites/favorites_controller.dart';
import '../../../../utils/mark_as_favorite.dart';
import '../../controller/movie_controller.dart';

class MovieAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MovieAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = context.watch();
    final FavoritesController favoritesController = context.watch();

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: movieController.state.mapOrNull(
        loaded: (movieState) => [
          favoritesController.state.maybeMap(
            orElse: () => const SizedBox(),
            loaded: (favoriteState) {
              return IconButton(
                  onPressed: () => markAsFavorite(
                        context: context,
                        media: movieState.movie.toMedia(),
                        mounted: () => movieController.mounted,
                      ),
                  icon: Icon(
                    favoriteState.movies.containsKey(movieState.movie.id)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                  ));
            },
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
