import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/data/http/http.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/generated/translations.g.dart';
import 'app/inject_repositories.dart';
import 'app/my_app.dart';
import 'app/presentation/global/controllers/favorites/favorites_controller.dart';
import 'app/presentation/global/controllers/favorites/state/favorites_state.dart';
import 'app/presentation/global/controllers/session_controller.dart';
import 'app/presentation/global/controllers/theme_controller.dart';

main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale(); // Language application
  Intl.defaultLocale = LocaleSettings.currentLocale.languageTag;

  final httpService = Http(
    client: http.Client(),
    baseUrl: 'https://api.themoviedb.org/3',
    token:
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNzEyN2Y3ZGQ2MGViOTFmOWQwMzdkMGU1ZWZjNTlkOSIsInN1YiI6IjYxZjMzZGMyYTZmZGFhMDBjNDkxMjkyNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Ee9VlY2TQ11oB9gWMXl9d87XDJ1owgDNBrRO5sEeO7o',
  );
  final systemDarkMode =
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;

  await injectRepository(
    systemDarkMode: systemDarkMode,
    http: httpService,
    languageCode: LocaleSettings.currentLocale.languageCode,
    secureStorage: const FlutterSecureStorage(),
    preferences: await SharedPreferences.getInstance(),
    connectivity: Connectivity(),
    internetChecker: InternetChecker(),
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeController>(
        create: (context) {
          final preferencesRepository = Repositories.preferences;
          return ThemeController(
            preferencesRepository.darkMode,
            preferencesRepository: preferencesRepository,
          );
        },
      ),
      ChangeNotifierProvider<SessionController>(
          create: (context) => SessionController(
                authenticationRepository: Repositories.authentication,
              )),
      ChangeNotifierProvider<FavoritesController>(
          create: (context) => FavoritesController(
                FavoritesState.loading(),
                accountRepository: Repositories.account,
              )),
    ],
    child: TranslationProvider(
      child: const MyApp(),
    ),
  ));
}
