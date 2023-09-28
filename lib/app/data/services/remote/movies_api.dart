import '../../../domain/either/either.dart';
import '../../../domain/failures/http_request/http_request_failure.dart';
import '../../../domain/models/movie/movie.dart';
import '../../../domain/models/performer/performer.dart';
import '../../http/http.dart';
import '../local/language_service.dart';
import '../utils/handle_failure.dart';

class MoviesAPI {
  final Http _http;

  MoviesAPI(this._http, this._languageService);

  final LanguageService _languageService;

  Future<Either<HttpRequestFailure, Movie>> getMovieById(int id) async {
    final result = await _http.request(
      '/movie/$id',
      queryParameters: {
        'language': _languageService.languageCode,
      },
      onSuccess: (json) {
        return Movie.fromJson(json);
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (movie) => Either.right(movie),
    );
  }

  Future<Either<HttpRequestFailure, List<Performer>>> getCastByMovie(
    int movieId,
  ) async {
    final result =
        await _http.request('/movie/$movieId/credits', queryParameters: {
      'language': _languageService.languageCode,
    }, onSuccess: (json) {
      final list = json['cast'] as List;
      return list
          .where((element) =>
              element['known_for_department'] == 'Acting' &&
              element['profile_path'] != null)
          .map(
            (e) => Performer.fromJson({...e, 'known_for': []}),
          )
          .toList();
    });

    return result.when(
        left: handleHttpFailure, right: (cast) => Either.right(cast));
  }
}
