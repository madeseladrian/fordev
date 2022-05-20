import 'package:get/get.dart';

import '../protocols/protocols.dart';


class GetxLoginPresenter extends GetxController {
  final Validation validation;
  
  GetxLoginPresenter({
    required this.validation,
  });

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}