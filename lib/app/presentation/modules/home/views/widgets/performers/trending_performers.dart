import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/either/either.dart';
import '../../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../../domain/models/performer/performer.dart';
import '../../../../../global/widgets/request_failed.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/states/home_state.dart';
import 'performer_tile.dart';

typedef EitherListPerformer = Either<HttpRequestFailure, List<Performer>>;

class TrendingPerformers extends StatefulWidget {
  const TrendingPerformers({super.key});

  @override
  State<TrendingPerformers> createState() => _TrendingPerformersState();
}

class _TrendingPerformersState extends State<TrendingPerformers> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch();
    final statePerformers = controller.state.performers;

    return Expanded(
        child: statePerformers.when(
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            failed: () => RequestFailed(onRetry: () {
                  controller.loadPerformers(
                    performers: const PerformersState.loading(),
                  );
                }),
            loaded: (performers) => Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      // padEnds: false,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        final performer = performers[index];

                        return PerformerTile(
                          performer: performer,
                        );
                      },
                      itemCount: performers.length,
                    ),
                    Positioned(
                      bottom: 30,
                      child: AnimatedBuilder(
                          animation: _pageController,
                          builder: (_, __) {
                            final currentCard =
                                _pageController.page?.toInt() ?? 1;
                            return Row(
                              children: List.generate(
                                  performers.length,
                                  (index) => Icon(
                                        Icons.circle,
                                        size: 14,
                                        color: currentCard == index
                                            ? Colors.blue
                                            : Colors.white30,
                                      )),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                )));
  }
}
