import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/controllers/favorites/favorites_controller.dart';
import '../../../global/widgets/request_failed.dart';
import 'widgets/favorites_app_bar.dart';
import 'widgets/favorites_content.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController = context.watch();
    return Scaffold(
      appBar: FavoritesAppBar(tabController: _tabController),
      body: favoritesController.state.map(
        loading: (_) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
        failed: (_) => RequestFailed(onRetry: () => favoritesController.init()),
        loaded: (state) {
          return FavoritesContent(
            state: state,
            tabController: _tabController,
          );
        },
      ),
    );
  }
}
