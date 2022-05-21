import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:get/get.dart';

import '../../domain/params/params.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/helpers.dart';

import '../helpers/helpers.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController {
  final Authentication authentication;
  final Validation validation;
  final SaveCurrentAccount saveCurrentAccount;
  
  String? _email;
  String? _password;

  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _mainError = Rx<UIError?>(null);
  final _navigateTo = Rx<String?>(null);
  final _isFormValid = Rx<bool>(false);
  final _isLoading = Rx<bool>(false);

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  Stream<String?> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter({
    required this.authentication,
    required this.validation,
    required this.saveCurrentAccount
  });

  UIError? _validateField({required String field, required String value}) {
    final error = validation.validate(field: field, value: value);
    switch(error) {
      case ValidationError.invalidField: return UIError.invalidField;
      case ValidationError.requiredField: return UIError.requiredField;
      default: return null;
    }
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null
      && _passwordError.value == null 
      && _email != null
      && _password != null;
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  Future<void> authenticate() async {
    try {
      _isLoading.value = true;
      final account = await authentication.authenticate(
        AuthenticationParams(email: _email, password: _password)
      );
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch(error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials; break;
        default: _mainError.value = UIError.unexpected;
      }
      _isLoading.value = false;
    }
  }
}
