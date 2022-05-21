import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';

import '../helpers/helpers.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController {
  final Validation validation;
  
  final _emailError = Rx<UIError?>(null);

  Stream<UIError?> get emailErrorStream => _emailError.stream;

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

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
  }
}
