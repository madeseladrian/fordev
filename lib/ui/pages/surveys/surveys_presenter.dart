import 'package:flutter/material.dart';

abstract class SurveysPresenter implements Listenable {
  Stream<bool> get isLoadingStream;

  Future<void> loadData();
}