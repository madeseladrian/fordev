import '../entities/entities.dart';
import '../params/params.dart';

abstract class Authentication {
  Future<AccountEntity> authenticate(AuthenticationParams params);
}