import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../components/components.dart';
import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          presenter.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context, error.description);
            }
          });

          presenter.navigateToStream.listen((page) {
            if (page != null && page.isNotEmpty) {
              Get.toNamed(page);
            }
          });

          return GestureDetector(
            onTap: () {},
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(),
                  const Headline1(),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: ListenableProvider(
                      create: (_) => presenter,
                      child: Form(
                        child: Column(
                          children: [
                            const EmailInput(),
                            const PasswordInput(),
                            const LoginButton(),
                            TextButton.icon(
                              onPressed: presenter.goToSignUp,
                              icon: const Icon(Icons.person),
                              label: const Text('Criar conta')
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
