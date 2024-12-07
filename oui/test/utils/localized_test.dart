import 'package:oui/oui.dart';
import 'package:test/test.dart';

void main() {
  group('Localized', () {
    test('returns exact match when available', () {
      final localized = Localized(
        'default',
        {
          const Locale('en', 'US'): 'American English',
          const Locale('en', 'GB'): 'British English',
        },
      );

      expect(localized.forLocale(const Locale('en', 'US')), 'American English');
      expect(localized.forLocale(const Locale('en', 'GB')), 'British English');
    });

    test('returns language-only match when no exact match exists', () {
      final localized = Localized(
        'default',
        {
          const Locale('es'): 'Spanish',
          const Locale('fr'): 'French',
        },
      );

      expect(localized.forLocale(const Locale('es', 'ES')), 'Spanish');
      expect(localized.forLocale(const Locale('fr', 'FR')), 'French');
    });

    test('returns default value when no match exists', () {
      final localized = Localized(
        'default',
        {
          const Locale('es'): 'Spanish',
        },
      );

      expect(localized.forLocale(const Locale('de', 'DE')), 'default');
    });

    test('works with different value types', () {
      final localized = Localized<int>(
        0,
        {
          const Locale('en'): 1,
          const Locale('es'): 2,
        },
      );

      expect(localized.forLocale(const Locale('en')), 1);
      expect(localized.forLocale(const Locale('es')), 2);
      expect(localized.forLocale(const Locale('fr')), 0);
    });
  });
}
