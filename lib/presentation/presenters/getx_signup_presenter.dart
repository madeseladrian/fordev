import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';

import '../helpers/helpers.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  final _nameError = Rx<UIError?>(null);
  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _passwordConfirmationError = Rx<UIError?>(null);
  final _isFormValid = Rx<bool>(false);

  Stream<UIError?> get nameErrorStream => _nameError.stream;
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<UIError?> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({
    required this.validation
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
    _isFormValid.value = false; 
  }

  void validateName(String name) {
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmationError.value = _validateField(
      field: 'passwordConfirmation', 
      value: passwordConfirmation
    );
    _validateForm();
  }
}