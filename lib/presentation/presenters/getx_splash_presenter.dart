import '../../domain/usecases/usecases.dart';

class GetxSplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  Future<void> checkAccount() async {
    await loadCurrentAccount.load();
  }
}