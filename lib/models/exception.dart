class APIExecption implements Exception {
  final String _message;
  APIExecption(this._message);
  get message {
    return _message;
  }
}
