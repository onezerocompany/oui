import 'package:contour/contour.dart';
import 'package:test/test.dart';

void main() {
  group('ContourUnion', () {
    test('returns first successful type parse', () {
      final u = union([string().pattern(RegExp(r'^[a-z]+$')), string()]);
      expect(u.parse('abc'), equals('abc'));
    });

    test('returns second type parse if first fails', () {
      final u = union([string().pattern(RegExp(r'^[a-z]+$')), string().min(1)]);
      expect(u.parse('123'), equals('123'));
    });

    test('throws error if none type match', () {
      final u = union([
        string().pattern(RegExp(r'^[a-z]+$')),
        string().pattern(RegExp(r'^[0-9]+$')),
      ]);
      expect(() => u.parse('abc123'), throwsA(isA<ContourParseError>()));
    });
  });
}
