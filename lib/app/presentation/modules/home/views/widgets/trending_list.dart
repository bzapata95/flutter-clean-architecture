import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/either/either.dart';
import '../../../../../domain/enums.dart';
import '../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../domain/models/media/media.dart';
import '../../../../../domain/repositories/trending_repository.dart';
import 'trending_tile.dart';
import 'trending_time_window.dart';

typedef EitherListMedia = Either<HttpRequestFailure, List<Media>>;

class TrendingList extends StatefulWidget {
  const TrendingList({super.key});

  @override
  State<TrendingList> createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {
  TrendingRepository get _repository => context.read();
  late Future<EitherListMedia> _future;
  TimeWindow _timeWindow = TimeWindow.day;

  @override
  void initState() {
    super.initState();

    _future = _repository.getMovieAndSeries(_timeWindow);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrendingTimeWindow(
            timeWindow: _timeWindow,
            onChanged: (timeWindow) {
              setState(() {
                _timeWindow = timeWindow;
                _future = _repository.getMovieAndSeries(_timeWindow);
              });
            }),
        const SizedBox(
          height: 10,
        ),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: LayoutBuilder(
            builder: (_, constrains) {
              final width = constrains.maxHeight * 0.65;
              return Center(
                child: FutureBuilder<EitherListMedia>(
                    key: ValueKey(_future),
                    future: _future,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      // if (snapshot.hasError) {
                      //   return const Text('Error');
                      // }

                      return snapshot.data!.when(
                        left: (failure) {
                          return Text(failure.toString());
                        },
                        right: (list) {
                          return ListView.separated(
                              separatorBuilder: (_, __) {
                                return const SizedBox(
                                  width: 10,
                                );
                              },
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length,
                              itemBuilder: (_, index) {
                                final media = list[index];
                                return TrendingTile(
                                  media: media,
                                  width: width,
                                );
                              });
                        },
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
