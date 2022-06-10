import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../signup_presenter.dart';
 
class PasswordInput extends StatelessWidget {
  const PasswordInput({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();
    return StreamBuilder<UIError?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          key: const Key('password-input-signup'),
          decoration: InputDecoration(
            labelText: R.string.password,
            icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
            errorText: snapshot.data?.description
          ),
          obscureText: true,
          onChanged: presenter.validatePassword
        );
      }
    );
  }
}