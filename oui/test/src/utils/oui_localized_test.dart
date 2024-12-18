import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/utils/oui_localized.dart';

void main() {
  group('OuiLocale', () {
    test('should create an instance with language code only', () {
      const locale = OuiLocale('en');
      expect(locale.languageCode, 'en');
      expect(locale.countryCode, isNull);
    });

    test('should create an instance with language code and country code', () {
      const locale = OuiLocale('en', 'US');
      expect(locale.languageCode, 'en');
      expect(locale.countryCode, 'US');
    });
  });

  test('should handle invalid language codes', () {
    expect(() => OuiLocale('invalid'), throwsAssertionError);
    expect(() => OuiLocale('e'), throwsAssertionError);
  });

  test('should handle empty strings', () {
    expect(() => OuiLocale(''), throwsAssertionError);
    expect(() => OuiLocale('en', ''), throwsAssertionError);
  });

  test('should implement toString correctly', () {
    expect(const OuiLocale('en').toString(), 'en');
    expect(const OuiLocale('en', 'US').toString(), 'en_US');
  });

  test('should implement equality correctly', () {
    expect(const OuiLocale('en'), equals(const OuiLocale('en')));
    expect(const OuiLocale('en', 'US'), equals(const OuiLocale('en', 'US')));
    expect(const OuiLocale('en'), isNot(equals(const OuiLocale('fr'))));
  });

  test('should have consistent hashCode', () {
    expect(
      const OuiLocale('en').hashCode,
      equals(const OuiLocale('en').hashCode),
    );
    expect(
      const OuiLocale('en', 'US').hashCode,
      equals(const OuiLocale('en', 'US').hashCode),
    );
  });

  group('OuiLocalized', () {
    test('should return default value when no locale is provided', () {
      const localized = OuiLocalized<String>('default');
      expect(localized.forLocale(null), 'default');
    });

    test('should return localized value for exact match', () {
      const localized = OuiLocalized<String>(
        'default',
        {
          OuiLocale('en', 'US'): 'Hello',
        },
      );
      expect(localized.forLocale(const OuiLocale('en', 'US')), 'Hello');
    });

    test('should return localized value for language-only match', () {
      const localized = OuiLocalized<String>(
        'default',
        {
          OuiLocale('en'): 'Hello',
        },
      );
      expect(localized.forLocale(const OuiLocale('en', 'GB')), 'Hello');
    });

    test('should return default value when no match is found', () {
      const localized = OuiLocalized<String>(
        'default',
        {
          OuiLocale('en', 'US'): 'Hello',
        },
      );
      expect(localized.forLocale(const OuiLocale('fr', 'FR')), 'default');
    });

    test('should return default value for always factory', () {
      final localized = OuiLocalized<String>.always('always');
      expect(localized.forLocale(const OuiLocale('en', 'US')), 'always');
      expect(localized.forLocale(const OuiLocale('fr', 'FR')), 'always');
    });

    test('should be case insensitive for language/country codes', () {
      const localized = OuiLocalized<String>(
        'default',
        {
          OuiLocale('en', 'US'): 'Hello',
        },
      );
      expect(localized.forLocale(const OuiLocale('EN', 'us')), 'Hello');
    });
  });
}
