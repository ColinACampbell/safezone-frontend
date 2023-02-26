class APIExecption implements Exception {
  final String _message;
  APIExecption(this._message);
  String get message {
    return _message;
  }
}
