import '../entities/entities.dart';
import '../params/params.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}