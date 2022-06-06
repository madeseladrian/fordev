import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => authenticate(any()));
  void mockAuthentication(AccountEntity data) => 
    mockAuthenticationCall().thenAnswer((_) async => data);
  void mockAuthenticationError(DomainError error) => 
    mockAuthenticationCall().thenThrow(error);
}