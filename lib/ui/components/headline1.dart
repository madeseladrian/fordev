import 'package:flutter/material.dart';
 
class Headline1 extends StatelessWidget {
  const Headline1({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Text(
      'LOGIN',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline1
    );
  }
}