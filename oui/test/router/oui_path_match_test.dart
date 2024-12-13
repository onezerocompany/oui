import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

class TestScreen extends OuiScreen {
  @override
  final String id;
  final Localized<OuiPath> localizedPath;

  TestScreen(this.id, this.localizedPath);

  @override
  Localized<OuiPath> get path => localizedPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

void main() {
  group('OuiPathMatch', () {
    test('forScreen matches path', () {
      final screen = TestScreen(
        'test',
        Localized(OuiPath([OuiPathSegment.static('test')])),
      );
      final match = OuiPathMatch.forScreen(screen, ['test'], Locale('en'));
      expect(match.isMatch, true);
      expect(match.screens.length, 1);
      expect(match.screens.first.id, 'test');
    });

    test('forScreen does not match path', () {
      final screen = TestScreen(
        'test',
        Localized(OuiPath([OuiPathSegment.static('test')])),
      );
      final match = OuiPathMatch.forScreen(screen, ['no-match'], Locale('en'));
      expect(match.isMatch, false);
    });

    test('add combines matches', () {
      final screen1 = TestScreen(
        'screen1',
        Localized(OuiPath([OuiPathSegment.static('screen1')])),
      );
      final screen2 = TestScreen(
        'screen2',
        Localized(OuiPath([OuiPathSegment.static('screen2')])),
      );

      final match1 = OuiPathMatch.forScreen(screen1, ['screen1'], Locale('en'));
      final match2 = OuiPathMatch.forScreen(screen2, ['screen2'], Locale('en'));

      final combinedMatch = match1.add(match2);
      expect(combinedMatch.isMatch, true);
      expect(combinedMatch.screens.length, 2);
      expect(combinedMatch.screens[0].id, 'screen1');
      expect(combinedMatch.screens[1].id, 'screen2');
    });

    test('noMatch represents no match', () {
      final noMatch = OuiPathMatch.noMatch;
      expect(noMatch.isMatch, false);
      expect(noMatch.screens.isEmpty, true);
    });
  });
}
