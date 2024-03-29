import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../inject_repositories.dart';
import '../../../global/widgets/my_scaffold.dart';
import '../../../routes/routes.dart';
import '../controllers/home_controller.dart';
import '../controllers/states/home_state.dart';
import 'widgets/movies_and_series/trending_list.dart';
import 'widgets/performers/trending_performers.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return ChangeNotifierProvider(
      key: Key('home-$languageCode'),
      create: (_) => HomeController(
        HomeState(),
        trendingRepository: Repositories.trending,
      )..init(),
      child: MyScaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.favorites);
              },
              icon: const Icon(
                Icons.favorite,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.profile);
              },
              icon: const Icon(
                Icons.person,
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: LayoutBuilder(
          builder: (context, constraints) => RefreshIndicator.adaptive(
            onRefresh: () async {
              await context.read<HomeController>().init();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: constraints.maxHeight,
                child: const Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TrendingList(),
                    SizedBox(
                      height: 20,
                    ),
                    TrendingPerformers(),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
