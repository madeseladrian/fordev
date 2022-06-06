import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/components/app_theme.dart';

ThemeData get themeData => makeAppTheme(); 

Widget makePage({required String path, required Widget Function() page}) {
  final getPages = [
    GetPage(name: path, page: page),
    GetPage(name: '/any_route', page: () => Scaffold(
      appBar: AppBar(title: const Text('any title')), 
      body: const Text('fake page')
    ))
  ];
  if (path != '/login') {
    getPages.add(GetPage(name: '/login', page: () => const Scaffold(body: Text('fake login'))));
  }
  return GetMaterialApp(
    initialRoute: path,
    theme: themeData,
    navigatorObservers: [Get.put<RouteObserver>(RouteObserver<PageRoute>())],
    getPages: getPages,
  );
}

String get currentRoute => Get.currentRoute;