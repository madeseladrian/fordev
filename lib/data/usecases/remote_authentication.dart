import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';

import '../http/http.dart';
import '../models/models.dart';
import '../params/params.dart';

class RemoteAuthentication {
  final String url;
  final HttpClient httpClient;

  RemoteAuthentication({required this.url, required this.httpClient});

  Future<AccountEntity> authenticate(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    final httpResponse = await httpClient.request(url: url, method: 'post', body: body);
    return RemoteAccountModel.fromJson(httpResponse).toEntity();
  }
}