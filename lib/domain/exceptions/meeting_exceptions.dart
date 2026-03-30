class MeetingException implements Exception {
  final String message;
  MeetingException(this.message);

  @override
  String toString() => message;
}

class SFUFetchException extends MeetingException {
  SFUFetchException() : super('Проблема с доступом к медиа-серверу, проверьте соединение или используйте VPN/Proxy');
}
