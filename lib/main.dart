import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/data/http/http.dart';
import 'app/data/repositories_implementation/account_repository_impl.dart';
import 'app/data/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/repositories_implementation/connectivity_repository_impl.dart';
import 'app/data/repositories_implementation/movies_repository_impl.dart';
import 'app/data/repositories_implementation/trending_repository_impl.dart';
import 'app/data/services/local/session_service.dart';
import 'app/data/services/remote/account_api.dart';
import 'app/data/services/remote/authentication_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/data/services/remote/movies_api.dart';
import 'app/data/services/remote/trending_api.dart';
import 'app/domain/repositories/account_repository.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/domain/repositories/movies_repository.dart';
import 'app/domain/repositories/trending_repository.dart';
import 'app/my_app.dart';
import 'app/presentation/global/controllers/session_controller.dart';

main() {
  setPathUrlStrategy();
  final sessionService = SessionService(
    const FlutterSecureStorage(),
  );
  final httpService = Http(
    client: http.Client(),
    baseUrl: 'https://api.themoviedb.org/3',
    token:
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNzEyN2Y3ZGQ2MGViOTFmOWQwMzdkMGU1ZWZjNTlkOSIsInN1YiI6IjYxZjMzZGMyYTZmZGFhMDBjNDkxMjkyNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Ee9VlY2TQ11oB9gWMXl9d87XDJ1owgDNBrRO5sEeO7o',
  );
  runApp(MultiProvider(
    providers: [
      Provider<ConnectivityRepository>(
        create: (_) => ConnectivityRepositoryImpl(
          Connectivity(),
          InternetChecker(),
        ),
      ),
      Provider<AuthenticationRepository>(
        create: (_) => AuthenticationRepositoryImpl(
          AuthenticationAPI(httpService),
          sessionService,
          AccountAPI(httpService),
        ),
      ),
      Provider<AccountRepository>(
          create: (_) => AccountRepositoryImpl(
                AccountAPI(httpService),
                sessionService,
              )),
      Provider<TrendingRepository>(
          create: (_) => TrendingRepositoryImpl(TrendingAPI(httpService))),
      Provider<MoviesRepository>(
          create: (_) => MoviesRepositoryImpl(MoviesAPI(httpService))),
      ChangeNotifierProvider<SessionController>(
          create: (context) => SessionController(
                authenticationRepository: context.read(),
              )),
    ],
    child: const MyApp(),
  ));
}
