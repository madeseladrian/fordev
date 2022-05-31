import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({ required this.cacheStorage });

  List<SurveyEntity> _mapToEntity(dynamic list) =>
    list.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data?.isEmpty == true) {
        throw Exception();
      }
      return _mapToEntity(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    final data = await cacheStorage.fetch('surveys');
    try {
      _mapToEntity(data);
    } catch (error) {
      await cacheStorage.delete('surveys');
    }
  }
}