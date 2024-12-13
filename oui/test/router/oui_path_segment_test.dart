import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

void main() {
  group('OuiPathSegment', () {
    test('static segment', () {
      final segment = OuiPathSegment.static('home');
      expect(segment.id, 'home');
      expect(segment.isDynamic, false);
      expect(segment.pattern?.hasMatch('home'), true);
      expect(segment.pattern?.hasMatch('about'), false);
    });

    test('argument segment', () {
      final segment = OuiPathSegment.argument('id', pattern: RegExp(r'^\d+$'));
      expect(segment.id, 'id');
      expect(segment.isDynamic, true);
      expect(segment.pattern?.hasMatch('123'), true);
      expect(segment.pattern?.hasMatch('abc'), false);
    });

    test('wildcard segment', () {
      final segment = OuiPathSegment.wildcard('path');
      expect(segment.id, 'path');
      expect(segment.isDynamic, true);
      expect(segment.pattern?.hasMatch('anything/goes/here'), true);
      expect(segment.pattern?.hasMatch(''), true);
    });
  });
}
