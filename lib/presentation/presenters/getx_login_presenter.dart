import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/params/params.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mixins/mixins.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController 
with LoadingManager, NavigationManager, FormManager, UIErrorManager 
implements LoginPresenter {
  final Authentication authentication;
  final Validation validation;
  final SaveCurrentAccount saveCurrentAccount;
  
  String? _email;
  String? _password;

  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  GetxLoginPresenter({
    required this.authentication,
    required this.validation,
    required this.saveCurrentAccount
  });

  UIError? _validateField({required String field}) {
    final formData = {
      'email': _email,
      'password': _password
    };
    final error = validation.validate(field: field, input: formData);
    switch(error) {
      case ValidationError.invalidField: return UIError.invalidField;
      case ValidationError.requiredField: return UIError.requiredField;
      default: return null;
    }
  }

  void _validateForm() {
    isFormValid = _emailError.value == null
      && _passwordError.value == null 
      && _email != null
      && _password != null;
  }

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password');
    _validateForm();
  }

  @override
  Future<void> authenticate() async {
    try {
      mainError = null;
      isLoading = true;
      final accountEntity = await authentication.authenticate(
        AuthenticationParams(email: _email, password: _password)
      );
      await saveCurrentAccount.save(accountEntity);
      navigateTo = '/surveys';
    } on DomainError catch(error) {
      isLoading = false;
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials; break;        
        default: mainError = UIError.unexpected;
      }
    }
  }

  @override
  void goToSignUp() {
    navigateTo = '/signup';
  }
}