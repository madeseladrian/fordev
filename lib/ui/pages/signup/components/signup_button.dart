import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
 
class SignUpButton extends StatelessWidget {
  const SignUpButton({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: Text(R.string.addAccount.toUpperCase()),
    );
  }
}