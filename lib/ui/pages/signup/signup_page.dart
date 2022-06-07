import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatelessWidget 
with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  final SignUpPresenter presenter;
  
  const SignUpPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);
          handleMainError(context, presenter.mainErrorStream);
          handleNavigation(presenter.navigateToStream, clear: true);
          
          return Builder(
            builder: (context) {
              return GestureDetector(
                key: const Key('keyboard-dismiss-signup'),
                onTap: () => hideKeyboard(context),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LoginHeader(),
                      Headline1(text: R.string.addAccount.toUpperCase(),),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: ListenableProvider(
                          create: (_) => presenter,
                          child: Form(
                            child: Column(
                              children: [
                                const NameInput(),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: EmailInput(),
                                ),
                                const PasswordInput(),
                                const Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 32),
                                  child: PasswordConfirmationInput(),
                                ),
                                const SignUpButton(),
                                TextButton.icon(
                                  onPressed: presenter.goToLogin,
                                  icon: const Icon(Icons.exit_to_app),
                                  label: Text(R.string.login)
                                )
                              ],
                            ),
                          ),
                        )
                      )
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
