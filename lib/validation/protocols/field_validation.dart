import '../../presentation/helpers/helpers.dart';

abstract class FieldValidation {
  String get field;
  ValidationError? validate(Map input);
}