import 'package:equatable/equatable.dart';

import '../../presentation/helpers/helpers.dart';
import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final String valueToCompare;

  @override
  List get props => [field, valueToCompare];

  const CompareFieldsValidation({ required this.field, required this.valueToCompare});

  @override
  ValidationError? validate(String value) {
    return value == valueToCompare ? null : ValidationError.invalidField;
  }
}