import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../signup.dart';
 
class SignUpButton extends StatelessWidget {
  const SignUpButton({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: presenter.signUp,
          child: Text(R.string.addAccount.toUpperCase()),
        );
      }
    );
  }
}