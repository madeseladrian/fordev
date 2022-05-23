import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
 
class Headline1 extends StatelessWidget {
  const Headline1({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Text(
      R.string.login.toUpperCase(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline1
    );
  }
}