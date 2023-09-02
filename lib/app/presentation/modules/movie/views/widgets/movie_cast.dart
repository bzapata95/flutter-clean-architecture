import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/either/either.dart';
import '../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../domain/models/performer/performer.dart';
import '../../../../../domain/repositories/movies_repository.dart';
import '../../../../global/utils/get_image_url.dart';
import '../../../../global/widgets/request_failed.dart';

class MovieCast extends StatefulWidget {
  const MovieCast({
    super.key,
    required this.movieId,
  });
  final int movieId;

  @override
  State<MovieCast> createState() => _MovieCastState();
}

class _MovieCastState extends State<MovieCast> {
  late Future<Either<HttpRequestFailure, List<Performer>>> _future;

  @override
  void initState() {
    super.initState();
    _initFuture();
  }

  void _initFuture() {
    _future = context.read<MoviesRepository>().getCastByMovie(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either<HttpRequestFailure, List<Performer>>>(
      key: ValueKey(_future),
      future: _future,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        return snapshot.data!.when(
            left: (_) => RequestFailed(onRetry: () {
                  setState(() {
                    _initFuture();
                  });
                }),
            right: (performers) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Cast',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        separatorBuilder: (_, __) => const SizedBox(
                          width: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final performer = performers[index];
                          return Column(
                            children: [
                              Expanded(
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  final size = constraints.maxHeight;
                                  return ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(size / 2),
                                    child: ExtendedImage.network(
                                      getImageUrl(performer.profilePath),
                                      height: size,
                                      width: size,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                performer.name,
                                style: const TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: performers.length,
                      ),
                    ),
                  ],
                ));
      },
    );
  }
}
