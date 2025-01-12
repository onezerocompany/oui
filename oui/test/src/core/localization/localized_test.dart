import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/localization.dart';

void main() {
  group('Locale', () {
    test('should create an instance with language code only', () {
      const locale = Locale('en');
      expect(locale.languageCode, 'en');
      expect(locale.countryCode, isNull);
    });

    test('should create an instance with language code and country code', () {
      const locale = Locale('en', 'US');
      expect(locale.languageCode, 'en');
      expect(locale.countryCode, 'US');
    });

    test('should handle invalid language codes', () {
      expect(() => Locale('invalid'), throwsAssertionError);
      expect(() => Locale('e'), throwsAssertionError);
    });

    test('should handle empty strings', () {
      expect(() => Locale(''), throwsAssertionError);
      expect(() => Locale('en', ''), throwsAssertionError);
    });

    test('should implement toString correctly', () {
      expect(const Locale('en').toString(), 'en');
      expect(const Locale('en', 'US').toString(), 'en_US');
    });

    test('should implement equality correctly', () {
      expect(const Locale('en'), equals(const Locale('en')));
      expect(const Locale('en', 'US'), equals(const Locale('en', 'US')));
      expect(const Locale('en'), isNot(equals(const Locale('fr'))));
    });

    test('should have consistent hashCode', () {
      expect(
        const Locale('en').hashCode,
        equals(const Locale('en').hashCode),
      );
      expect(
        const Locale('en', 'US').hashCode,
        equals(const Locale('en', 'US').hashCode),
      );
    });
  });

  group('Localized', () {
    test('should return default value when no locale is provided', () {
      const localized = Localized<String>('default');
      expect(localized.forLocale(null), 'default');
    });

    test('should return localized value for exact match', () {
      const localized = Localized<String>(
        'default',
        {
          Locale('en', 'US'): 'Hello',
        },
      );
      expect(localized.forLocale(const Locale('en', 'US')), 'Hello');
    });

    test('should return localized value for language-only match', () {
      const localized = Localized<String>(
        'default',
        {
          Locale('en'): 'Hello',
        },
      );
      expect(localized.forLocale(const Locale('en', 'GB')), 'Hello');
    });

    test('should return default value when no match is found', () {
      const localized = Localized<String>(
        'default',
        {
          Locale('en', 'US'): 'Hello',
        },
      );
      expect(localized.forLocale(const Locale('fr', 'FR')), 'default');
    });

    test('should return default value for always factory', () {
      final localized = Localized<String>.always('always');
      expect(localized.forLocale(const Locale('en', 'US')), 'always');
      expect(localized.forLocale(const Locale('fr', 'FR')), 'always');
    });

    test('should be case insensitive for language/country codes', () {
      const localized = Localized<String>(
        'default',
        {
          Locale('en', 'US'): 'Hello',
        },
      );
      expect(localized.forLocale(const Locale('EN', 'us')), 'Hello');
    });
  });
}
