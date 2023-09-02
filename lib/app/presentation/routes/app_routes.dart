import 'package:flutter/widgets.dart';

import '../modules/favorites/views/favorite_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/offline/views/offline_view.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/splash/views/splash_view.dart';
import 'routes.dart';

Map<String, Widget Function(BuildContext)> get apRoutes {
  return {
    Routes.splash: (_) => const SplashView(),
    Routes.singIn: (_) => const SignInView(),
    Routes.home: (_) => const HomeView(),
    Routes.offline: (_) => const OfflineView(),
    Routes.favorites: (_) => const FavoriteView(),
  };
}
