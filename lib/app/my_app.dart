import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/global/controllers/theme_controller.dart';
import 'presentation/global/theme.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = context.watch();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        initialRoute: Routes.splash,
        routes: apRoutes,
        theme: getTheme(themeController.darkMode),
        onUnknownRoute: (_) => MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('404'),
                  ),
                )),
      ),
    );
  }
}
