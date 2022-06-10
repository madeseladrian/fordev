import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../login_presenter.dart';
 
class LoginButton extends StatelessWidget {
  const LoginButton({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();

    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.data == true
            ? presenter.authenticate : null,
          child: Text(R.string.enter.toUpperCase()),
        );
      }
    );
  }
}