import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/authentication_repository.dart';
import '../../../routes/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            Provider.of<AuthenticationRepository>(context, listen: false)
                .signOut();
            Navigator.pushReplacementNamed(context, Routes.singIn);
          },
          child: const Text('Sign out'),
        ),
      ),
    );
  }
}
