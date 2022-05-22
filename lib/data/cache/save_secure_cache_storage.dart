abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({
    required String key, 
    required dynamic value
  });
}