String createRandomEmail() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return 'testuser$timestamp@example.com';
}
