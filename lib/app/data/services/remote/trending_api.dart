import '../../../domain/either/either.dart';
import '../../../domain/enums.dart';
import '../../../domain/failures/http_request/http_request_failure.dart';
import '../../../domain/models/media/media.dart';
import '../../../domain/models/performer/performer.dart';
import '../../../domain/typedefs.dart';
import '../../http/http.dart';
import '../utils/handle_failure.dart';

class TrendingAPI {
  final Http _http;

  TrendingAPI(this._http);

  Future<Either<HttpRequestFailure, List<Media>>> getMovieAndSeries(
      TimeWindow timeWindow) async {
    final result = await _http.request(
      '/trending/all/${timeWindow.name}',
      onSuccess: (json) {
        final list = List<Json>.from(json['results']);
        final items = getMediaList(list);
        return items;
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (list) => Either.right(list),
    );
  }

  Future<Either<HttpRequestFailure, List<Performer>>> getPerformer(
      TimeWindow timeWindow) async {
    final result = await _http.request(
      '/trending/person/${timeWindow.name}',
      onSuccess: (json) {
        final list = List<Json>.from(json['results']);
        return list
            .where(
              (element) =>
                  element['known_for_department'] == 'Acting' &&
                  element['profile_path'] != null,
            )
            .map((e) => Performer.fromJson(e))
            .toList();
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (list) => Either.right(list),
    );
  }
}
