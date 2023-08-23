class AppException implements Exception {
  final String? message;

  AppException([this.message]);

  factory AppException.unknown() => AppException('Unknown error occurred');

  @override
  String toString() {
    final message = this.message;
    if (message == null) return 'Unknown error occurred';
    return message;
  }
}
