import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

void main() {
  group('OuiPath', () {
    test('matches static segments', () {
      final path = OuiPath([
        OuiPathSegment.static('home'),
        OuiPathSegment.static('about'),
      ]);

      final matches = path.matches(['home', 'about']);
      expect(matches.length, 2);
      expect(matches[0].content, 'home');
      expect(matches[1].content, 'about');
    });

    test('matches dynamic segments', () {
      final path = OuiPath([
        OuiPathSegment.static('user'),
        OuiPathSegment.argument('id'),
      ]);

      final matches = path.matches(['user', '123']);
      expect(matches.length, 2);
      expect(matches[0].content, 'user');
      expect(matches[1].content, '123');
    });

    test('matches wildcard segments', () {
      final path = OuiPath([
        OuiPathSegment.static('files'),
        OuiPathSegment.wildcard('path'),
      ]);

      final matches = path.matches(['files', 'documents/report.pdf']);
      expect(matches.length, 2);
      expect(matches[0].content, 'files');
      expect(matches[1].content, 'documents/report.pdf');
    });

    test('does not match when segments do not align', () {
      final path = OuiPath([
        OuiPathSegment.static('home'),
        OuiPathSegment.static('about'),
      ]);

      final matches = path.matches(['home', 'contact']);
      expect(matches.length, 1);
      expect(matches[0].content, 'home');
    });

    test('parses empty path', () {
      final path = OuiPath.empty;
      final matches = path.matches([]);
      expect(matches.length, 0);
    });
  });
}
