import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../signup_presenter.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.data == true 
            ? presenter.signUp : null,
          child: Text(R.string.addAccount.toUpperCase()),
        );
      }
    );
  }
}