import 'package:flutter/widgets.dart';

import '../modules/splash/views/splash_view.dart';
import 'routes.dart';

Map<String, Widget Function(BuildContext)> get apRoutes {
  return {
    Routes.splash: (_) => const SplashView(),
  };
}
