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
  });
}
