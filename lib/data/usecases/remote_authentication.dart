import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/params/params.dart';
import '../../domain/usecases/usecases.dart';

import '../http/http.dart';
import '../models/models.dart';
import '../params/params.dart';

class RemoteAuthentication implements Authentication {
  final String url;
  final HttpClient httpClient;

  RemoteAuthentication({required this.url, required this.httpClient});

  @override
  Future<AccountEntity> authenticate(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpResponse = await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized 
        ? DomainError.invalidCredentials
        : DomainError.unexpected;
    }
  }
}