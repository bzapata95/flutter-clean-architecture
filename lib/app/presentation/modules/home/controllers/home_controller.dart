import '../../../../domain/enums.dart';
import '../../../../domain/repositories/trending_repository.dart';
import '../../../global/state_notifier.dart';
import 'states/home_state.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController(
    super.state, {
    required this.trendingRepository,
  });

  final TrendingRepository trendingRepository;

  Future<void> init() async {
    await loadMoviesAndSeries();
    await loadPerformers();
  }

  void onTimeWindowChanged(TimeWindow timeWindow) {
    if (state.moviesAndSeries.timeWindow != timeWindow) {
      state = state.copyWith(
        moviesAndSeries: MoviesAndSeriesState.loading(timeWindow),
      );
      loadMoviesAndSeries();
    }
  }

  Future<void> loadMoviesAndSeries({
    MoviesAndSeriesState? moviesAndSeries,
  }) async {
    if (moviesAndSeries != null) {
      state = state.copyWith(
        moviesAndSeries: moviesAndSeries,
      );
    }
    final results = await trendingRepository
        .getMovieAndSeries(state.moviesAndSeries.timeWindow);
    results.when(left: (_) {
      state = state.copyWith(
          moviesAndSeries:
              MoviesAndSeriesState.failed(state.moviesAndSeries.timeWindow));
    }, right: (list) {
      state = state.copyWith(
          moviesAndSeries: MoviesAndSeriesState.loaded(
        list: list,
        timeWindow: state.moviesAndSeries.timeWindow,
      ));
    });
  }

  Future<void> loadPerformers({
    PerformersState? performers,
  }) async {
    if (performers != null) {
      state = state.copyWith(performers: performers);
    }

    final performerResult = await trendingRepository.getPerformers();
    performerResult.when(left: (_) {
      state = state.copyWith(performers: const PerformersState.failed());
    }, right: (list) {
      state = state.copyWith(performers: PerformersState.loaded(list));
    });
  }
}
