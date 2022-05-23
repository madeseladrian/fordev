import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.string.name,
        icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight)
      ),
      keyboardType: TextInputType.name
    );
  }
}