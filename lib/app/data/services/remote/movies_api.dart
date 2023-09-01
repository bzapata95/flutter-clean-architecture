import '../../../domain/either/either.dart';
import '../../../domain/failures/http_request/http_request_failure.dart';
import '../../../domain/models/movie/movie.dart';
import '../../http/http.dart';
import '../utils/handle_failure.dart';

class MoviesAPI {
  final Http _http;

  MoviesAPI(this._http);

  Future<Either<HttpRequestFailure, Movie>> getMovieById(int id) async {
    final result = await _http.request(
      '/movie/$id',
      onSuccess: (json) {
        return Movie.fromJson(json);
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (movie) => Either.right(movie),
    );
  }
}
