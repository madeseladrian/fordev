import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../signup_presenter.dart';
 
class PasswordConfirmationInput extends StatelessWidget {
  const PasswordConfirmationInput({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();
    return StreamBuilder<UIError?>(
      stream: presenter.passwordConfirmationErrorStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 32),
          child: TextFormField(
            key: const Key('passwordConfirmation-input-signup'),
            decoration: InputDecoration(
              labelText: R.string.confirmPassword,
              icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
              errorText: snapshot.data?.description
            ),
            obscureText: true,
            onChanged: presenter.validatePasswordConfirmation
          ),
        );
      }
    );
  }
}