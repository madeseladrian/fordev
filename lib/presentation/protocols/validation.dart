import '../helpers/helpers.dart';

abstract class Validation {
  ValidationError? validate({
    required String field,
    required String value
  });
}
