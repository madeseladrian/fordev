import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';

import '../helpers/helpers.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  final _nameError = Rx<UIError?>(null);

  Stream<UIError?> get nameErrorStream => _nameError.stream;

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

  void validateName(String name) {
    _validateField(field: 'name', value: name);
  }
}
