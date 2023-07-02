import '../either/either.dart';
import '../enums.dart';
import '../failures/http_request/http_request_failure.dart';
import '../models/media/media.dart';

abstract class TrendingRepository {
  Future<Either<HttpRequestFailure, List<Media>>> getMovieAndSeries(
      TimeWindow timeWindow);
}
