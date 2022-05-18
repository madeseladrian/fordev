import 'package:equatable/equatable.dart';

class AuthenticationParams extends Equatable {
  final String? email;
  final String? password;

  @override
  List get props => [email, password];

  const AuthenticationParams({this.email, this.password});
}