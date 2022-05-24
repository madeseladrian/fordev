import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/helpers/helpers.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/ui/helpers/errors/ui_error.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late String name;
  late ValidationSpy validation;
  late GetxSignUpPresenter sut;
 
  
  When mockValidationCall(String? field) => when(() => validation.validate(
    field: field ?? any(named: 'field'),
    value: any(named: 'value'),
  ));
  void mockValidation({String? field}) => mockValidationCall(field).thenReturn(null);
  void mockValidationError({String? field, required ValidationError value}) => 
    mockValidationCall(field).thenReturn(value);
    
  setUp(() {
    name = faker.person.name();
    validation = ValidationSpy();
    mockValidation();
    sut = GetxSignUpPresenter(
      validation: validation
    );
  });

  test('1 - Should call Validation with correct name', () async {
    sut.validateName(name);
    
    verify(() => validation.validate(field: 'name', value: name)).called(1);
  });

  
  test('2,3,4 - Should invalidFieldError if name is empty', () async {
    mockValidationError(value: ValidationError.invalidField);
   
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

} 