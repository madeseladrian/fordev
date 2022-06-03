import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'components.dart';

Future<void> showErrorMessage(BuildContext context, String error) async {
  await showDialog(
    context: context,
    builder: (context) => ShowDialog(
      nameApp: R.string.nameApp, 
      subtitle: error, 
      nameButton: R.string.close, 
      onPressed: () => Navigator.of(context).pop(),
    )
  );
}
