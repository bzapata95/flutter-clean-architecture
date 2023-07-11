import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/either/either.dart';
import '../../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../../domain/models/media/media.dart';
import '../../../../../global/widgets/request_failed.dart';
import '../../../controllers/home_controller.dart';
import 'trending_tile.dart';
import 'trending_time_window.dart';

typedef EitherListMedia = Either<HttpRequestFailure, List<Media>>;

class TrendingList extends StatelessWidget {
  const TrendingList({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = context.watch();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrendingTimeWindow(
          timeWindow: homeController.state.timeWindow,
          onChanged: (timeWindow) {},
        ),
        const SizedBox(
          height: 10,
        ),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: LayoutBuilder(
            builder: (_, constrains) {
              final width = constrains.maxHeight * 0.65;
              return Center(
                child: homeController.state.loading
                    ? const CircularProgressIndicator.adaptive()
                    : homeController.state.moviesAndSeries == null
                        ? RequestFailed(onRetry: () {})
                        : ListView.separated(
                            separatorBuilder: (_, __) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                homeController.state.moviesAndSeries!.length,
                            itemBuilder: (_, index) {
                              final media =
                                  homeController.state.moviesAndSeries![index];
                              return TrendingTile(
                                media: media,
                                width: width,
                              );
                            }),
              );
            },
          ),
        ),
      ],
    );
  }
}
