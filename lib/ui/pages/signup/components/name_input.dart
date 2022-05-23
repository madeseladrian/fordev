import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../signup_presenter.dart';

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.string.name,
        icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight)
      ),
      keyboardType: TextInputType.name,
      onChanged: presenter.validateName,
    );
  }
}