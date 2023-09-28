import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../generated/translations.g.dart';
import '../../../../routes/routes.dart';
import '../../controller/sign_in_controller.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController controller = Provider.of(context);
    if (controller.state.fetching) {
      return const CircularProgressIndicator();
    }

    return MaterialButton(
      onPressed: () {
        final isValid = Form.of(context).validate();
        if (isValid) {
          _submit(context);
        }
      },
      color: Colors.blue,
      child: Text(
        translation.signIn.signIn,
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final SignInController controller = context.read();

    final result = await controller.submit();

    if (!controller.mounted) return;

    result.when(
      left: (failure) {
        final message = failure.when(
          notFound: () => translation.signIn.errors.submit.notFound,
          network: () => translation.signIn.errors.submit.network,
          unauthorized: () => translation.signIn.errors.submit.unauthorized,
          unknown: () => translation.signIn.errors.submit.unknown,
          notVerified: () => translation.signIn.errors.submit.notVerified,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
      right: (_) => Navigator.pushReplacementNamed(
        context,
        Routes.home,
      ),
    );
  }
}
