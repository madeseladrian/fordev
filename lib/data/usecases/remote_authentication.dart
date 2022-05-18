import '../../domain/params/params.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final String url;
  final HttpClient httpClient;

  RemoteAuthentication({required this.url, required this.httpClient});

  Future<void> authenticate(AuthenticationParams params) async {
    final body = {
      'email': params.email,
      'password': params.password
    };
    await httpClient.request(url: url, method: 'post', body: body);
  }
}