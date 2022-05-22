import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';

class GetxSplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  final _navigateTo = Rx<String?>(null);

  Stream<String?> get navigateToStream => _navigateTo.stream;

  Future<void> checkAccount() async {
    try {
      await loadCurrentAccount.load();
      _navigateTo.value = '/surveys';
    } catch (error) {
      _navigateTo.value = '/login';
    }
  }
}