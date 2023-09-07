import 'package:flutter/material.dart';

import '../../../../global/controllers/favorites/state/favorites_state.dart';

class FavoritesContent extends StatelessWidget {
  const FavoritesContent({
    super.key,
    required this.state,
    required this.tabController,
  });

  final FavoritesStateLoaded state;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: const [
        Text('Movies'),
        Text('Series'),
      ],
    );
  }
}
