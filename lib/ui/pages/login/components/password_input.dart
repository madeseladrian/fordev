import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../login_presenter.dart';
 
class PasswordInput extends StatelessWidget {
  const PasswordInput({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 32),
          child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Senha',
            icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
            errorText: snapshot.data?.description
          ),
          obscureText: true,
          onChanged: presenter.validatePassword,
        ),
        );
      }
    );
  }
}