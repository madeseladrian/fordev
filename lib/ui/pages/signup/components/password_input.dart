import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
 
class PasswordInput extends StatelessWidget {
  const PasswordInput({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.string.password,
        icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight)
      ),
      obscureText: true
    );
  }
}