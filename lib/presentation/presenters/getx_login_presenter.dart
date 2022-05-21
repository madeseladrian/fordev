import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';

import '../helpers/helpers.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController {
  final Validation validation;
  
  final _emailError = Rx<UIError?>(null);
  final _isFormValid = Rx<bool>(false);

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxLoginPresenter({
    required this.validation,
  });

  UIError? _validateField({required String field, required String value}) {
    final error = validation.validate(field: field, value: value);
    switch(error) {
      case ValidationError.invalidField: return UIError.invalidField;
      default: return null;
    }
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null;
  }

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }
}
