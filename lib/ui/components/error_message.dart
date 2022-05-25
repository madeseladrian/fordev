import 'package:flutter/material.dart';
import 'package:fordev/ui/components/components.dart';

import '../helpers/helpers.dart';
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
