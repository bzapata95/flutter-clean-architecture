import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData getTheme(bool darkMode) {
  if (darkMode) {
    return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.dark,
        elevation: 0,
      ),
      scaffoldBackgroundColor: AppColors.darkLight,
      canvasColor: AppColors.dark,
      switchTheme: SwitchThemeData(
        thumbColor: const MaterialStatePropertyAll(Colors.blue),
        trackColor: MaterialStatePropertyAll(Colors.lightBlue.withOpacity(0.5)),
      ),
    );
  }
  return ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.dark,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.dark,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.dark,
    ),
  );
}
