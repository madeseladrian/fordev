import 'package:fordev/main/factories/cache/cache.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../data/usecases/usecases.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
    saveSecureCacheStorage: makeLocalStorageAdapter()
  );
}