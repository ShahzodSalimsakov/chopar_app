import 'dart:math';

String randomAlphaNumeric(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}
