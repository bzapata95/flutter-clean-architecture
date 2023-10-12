import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/translations.g.dart';
import '../../../../inject_repositories.dart';
import '../controller/sign_in_controller.dart';
import '../controller/state/sign_in_state.dart';
import 'widgets/submit_button.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (_) => SignInController(
        const SignInState(),
        authenticationRepository: Repositories.authentication,
        sessionController: context.read(),
        favoritesController: context.read(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: Builder(builder: (context) {
                final controller = Provider.of<SignInController>(
                  context,
                );
                return AbsorbPointer(
                  absorbing: controller.state.fetching,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onUsernameChanged(text);
                        },
                        decoration: InputDecoration(
                          hintText: translation.signIn.username,
                        ),
                        validator: (value) {
                          value = value?.trim().toLowerCase() ?? '';
                          if (value.isEmpty) {
                            return translation.signIn.errors.username;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onPasswordChanged(text);
                        },
                        decoration: InputDecoration(
                          hintText: translation.signIn.password,
                        ),
                        validator: (value) {
                          value = value?.replaceAll(' ', '') ?? '';
                          if (value.length < 4) {
                            return translation.signIn.errors.password;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SubmitButton(),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
