import 'package:mockito/mockito.dart';

import '../../../data/cache/cache.dart';
import '../../../data/http/http.dart';
import '../../decorators/decorators.dart';
import '../factories.dart';

class DeleteSecureCacheStorageSpy extends Mock implements DeleteSecureCacheStorage {}

HttpClient makeAuthorizeHttpClientDecorator() {
  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeSecureStorageAdapter(), 
    deleteSecureCacheStorage: DeleteSecureCacheStorageSpy(),
    decoratee: makeHttpAdapter()
  );
}