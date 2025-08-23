class AuthException implements Exception {
  final String key;

  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Já existe e-mail cadastrado no sistema.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente mais tarde',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado.',
    'INVALID_LOGIN_CREDENTIALS': 'Os dados informados são inválidos',
    'INVALID_PASSWORD': 'A senha informada está incorreta.',
    'USER_DISABLED': 'O usuário encontra-se desabilitado no sistema.',
  };

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro ao se autenticar no sistema';
  }
}
