import '../../../data/http/http.dart';
import '../../decorators/decorators.dart';
import '../factories.dart';

HttpClient makeAuthorizeHttpClientDecorator() {
  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeSecureStorageAdapter(), 
    decoratee: makeHttpAdapter()
  );
}