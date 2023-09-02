import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/movie_controller.dart';

class MovieAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MovieAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = context.watch();
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: movieController.state.mapOrNull(
        loaded: (_) => [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_outline,
              ))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
