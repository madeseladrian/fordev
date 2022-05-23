import 'package:fordev/domain/entities/entities.dart';

import '../../../domain/params/params.dart';

import '../../http/http.dart';
import '../../models/models.dart';
import '../../params/params.dart';

class RemoteAddAccount {
  final String url;
  final HttpClient httpClient;

  RemoteAddAccount({required this.url, required this.httpClient});

  Future<AccountEntity> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();
    final httpResponse = await httpClient.request(url: url, method: 'post', body: body);
    return RemoteAccountModel.fromJson(httpResponse).toEntity();
  }
}