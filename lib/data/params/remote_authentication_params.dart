import '../../domain/params/params.dart';

class RemoteAuthenticationParams {
  String? email;
  String? password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password
  });
  
  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) => 
    RemoteAuthenticationParams(email: params.email, password: params.password);

  Map toJson() => {'email': email, 'password': password};
}