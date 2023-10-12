import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../inject_repositories.dart';
import '../../../routes/routes.dart';

class OfflineView extends StatefulWidget {
  const OfflineView({super.key});

  @override
  State<OfflineView> createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView> {
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = Repositories.connectivity.onInternetChanged.listen(
      (connected) {
        if (connected) {
          Navigator.popAndPushNamed(context, Routes.splash);
        }
      },
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OfflineView'),
      ),
    );
  }
}
