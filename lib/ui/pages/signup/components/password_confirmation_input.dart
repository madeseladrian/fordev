import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../signup_presenter.dart';
 
class PasswordConfirmationInput extends StatelessWidget {
  const PasswordConfirmationInput({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: R.string.confirmPassword,
          icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight)
        ),
        obscureText: true,
        onChanged: presenter.validatePasswordConfirmation
      ),
    );
  }
}