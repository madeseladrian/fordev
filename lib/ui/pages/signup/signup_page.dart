import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';

class SignUpPage extends StatelessWidget with NavigationManager {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(),
                  Headline1(text: R.string.addAccount.toUpperCase(),),
                  Padding(
                    padding: const EdgeInsets.all(32),
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
                            onPressed: () {},
                            icon: const Icon(Icons.exit_to_app),
                            label: Text(R.string.login)
                          )
                        ],
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
