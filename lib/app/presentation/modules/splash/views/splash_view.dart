import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../domain/repositories/connectivity_repository.dart';
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
    final hasInternet = await connectivityRepository.hasInternetConnection;

    if (hasInternet) {
      final isSignedIn = await authenticationRepository.isSignedIn;

      if (isSignedIn) {
        final user = await authenticationRepository.getUserData();
        if (user != null) {
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
