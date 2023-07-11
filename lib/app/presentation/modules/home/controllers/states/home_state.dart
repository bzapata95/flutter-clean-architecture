import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/enums.dart';
import '../../../../../domain/models/media/media.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    required bool loading,
    List<Media>? moviesAndSeries,
    @Default(TimeWindow.day) TimeWindow timeWindow,
  }) = _HomeState;
}
