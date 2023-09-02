import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => HomeController(
        HomeState(),
        trendingRepository: context.read(),
      )..init(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.favorites);
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                color: Colors.black,
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
