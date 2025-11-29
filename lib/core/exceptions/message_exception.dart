class MessageException implements Exception {
  MessageException(this.message) : super();

  final String message;
}

class AuthenticateException extends MessageException {
  AuthenticateException() : super('未認証です');
}