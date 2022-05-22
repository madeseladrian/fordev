import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

import '../../cache/cache.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});
  
  @override
  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(
      key: 'token',
      value: account.token
    );
  }
}