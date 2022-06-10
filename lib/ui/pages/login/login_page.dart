import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  final LoginPresenter presenter;
  
  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(presenter);

    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);
          handleMainError(context, presenter.mainErrorStream);
          handleNavigation(presenter.navigateToStream, clear: true);
          
          return Builder(
            builder: (context) {
              return GestureDetector(
                key: const Key('keyboard-dismiss-login'),
                onTap: () => hideKeyboard(context),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LoginHeader(),
                      Headline1(text: R.string.login.toUpperCase()),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Form(
                          child: Column(
                            children: [
                              const EmailInput(),
                              const PasswordInput(),
                              const LoginButton(),
                              TextButton.icon(
                                onPressed: presenter.goToSignUp,
                                icon: const Icon(Icons.person),
                                label: Text(R.string.addAccount)
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        },
      ),
    );
  }
}