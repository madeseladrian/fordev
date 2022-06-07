import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'login_presenter.dart';



class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> 
with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, widget.presenter.isLoadingStream);
          handleMainError(context, widget.presenter.mainErrorStream);
          handleNavigation(widget.presenter.navigateToStream, clear: true);
          
          return Builder(
            builder: (context) {
              return GestureDetector(
                key: const Key('keyboard-dismiss'),
                onTap: () => hideKeyboard(context),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LoginHeader(),
                      Headline1(text: R.string.login.toUpperCase(),),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: ListenableProvider(
                          create: (_) => widget.presenter,
                          child: Form(
                            child: Column(
                              children: [
                                const EmailInput(),
                                const PasswordInput(),
                                const LoginButton(),
                                TextButton.icon(
                                  onPressed: widget.presenter.goToSignUp,
                                  icon: const Icon(Icons.person),
                                  label: Text(R.string.addAccount)
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
            }
          );
        },
      ),
    );
  }
}