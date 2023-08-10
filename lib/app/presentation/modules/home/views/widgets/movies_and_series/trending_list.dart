import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../global/widgets/request_failed.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/states/home_state.dart';
import 'trending_tile.dart';
import 'trending_time_window.dart';

class TrendingList extends StatelessWidget {
  const TrendingList({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = context.watch();
    final moviesAndSeries = homeController.state.moviesAndSeries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrendingTimeWindow(
          timeWindow: moviesAndSeries.timeWindow,
          onChanged: homeController.onTimeWindowChanged,
        ),
        const SizedBox(
          height: 10,
        ),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: LayoutBuilder(
            builder: (_, constrains) {
              final width = constrains.maxHeight * 0.65;
              return Center(child: Builder(builder: (_) {
                return moviesAndSeries.when(
                    loading: (_) => const CircularProgressIndicator.adaptive(),
                    failed: (_) => RequestFailed(onRetry: () {
                          homeController.loadMoviesAndSeries(
                              moviesAndSeries: MoviesAndSeriesState.loading(
                            moviesAndSeries.timeWindow,
                          ));
                        }),
                    loaded: (_, list) => ListView.separated(
                        separatorBuilder: (_, __) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        itemBuilder: (_, index) {
                          final media = list[index];
                          return TrendingTile(
                            media: media,
                            width: width,
                          );
                        }));
              }));
            },
          ),
        ),
      ],
    );
  }
}
