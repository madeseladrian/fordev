import 'package:equatable/equatable.dart';

class AddAccountParams extends Equatable {
  final String? name;
  final String? email;
  final String? password;
  final String? passwordConfirmation;

  @override
  List get props => [name, email, password, passwordConfirmation];

  const AddAccountParams({
    this.name, 
    this.email, 
    this.password,
    this.passwordConfirmation
  });
}