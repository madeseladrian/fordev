enum UIError {
  invalidCredentials,
  invalidField,
  requiredField,
  unexpected
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials: return 'Credenciais inválidas.';
      case UIError.requiredField: return 'Campo obrigatório';
      case UIError.invalidField: return 'Campo inválido';
      default: return 'Algo errado aconteceu. Tente novamente em breve.';
    }
  }
}