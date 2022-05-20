import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ui/components/components.dart';
import '../ui/pages/pages.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      home: const LoginPage(),
    );
  }
}