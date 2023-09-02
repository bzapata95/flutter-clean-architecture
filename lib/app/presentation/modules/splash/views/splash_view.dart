import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../domain/repositories/connectivity_repository.dart';
import '../../../global/controllers/favorites/favorites_controller.dart';
import '../../../global/controllers/session_controller.dart';
import '../../../routes/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    final authenticationRepository =
        Provider.of<AuthenticationRepository>(context, listen: false);
    final connectivityRepository =
        Provider.of<ConnectivityRepository>(context, listen: false);
    final AccountRepository accountRepository = context.read();
    final SessionController sessionController = context.read();
    final FavoritesController favoritesController = context.read();

    final hasInternet = await connectivityRepository.hasInternetConnection;

    if (hasInternet) {
      final isSignedIn = await authenticationRepository.isSignedIn;

      if (isSignedIn) {
        final user = await accountRepository.getUserData();
        if (user != null) {
          sessionController.setUser(user);
          favoritesController.init();
          _goTo(Routes.home);
        } else {
          _goTo(Routes.singIn);
        }
      } else if (mounted) {
        _goTo(Routes.singIn);
      }
    } else {
      _goTo(Routes.offline);
    }
  }

  void _goTo(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
