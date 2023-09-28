import 'package:flutter/material.dart';

import '../../../generated/assets.gen.dart';
import '../../../generated/translations.g.dart';

class RequestFailed extends StatelessWidget {
  const RequestFailed({
    super.key,
    required this.onRetry,
    this.text,
  });

  final VoidCallback onRetry;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Assets.images.error404.image()),
          Text(text ?? translation.mics.requestFailed),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: onRetry,
            color: Colors.blue,
            child: Text(
              translation.mics.retry,
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
