import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/cache.dart';

class SecureStorageAdapter implements SaveSecureCacheStorage, FetchSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageAdapter({required this.secureStorage});
  
  @override
  Future<void> save({required String key, required dynamic value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> fetch(String key) async {
    return await secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    await secureStorage.delete(key: key);
  }
}