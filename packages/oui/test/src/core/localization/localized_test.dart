import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/locales.dart' show Locale;
import 'package:oui/src/core/localization.dart';

void main() {
  group('Locale', () {
    test('should create an instance with language code only', () {
      const locale = Locale.en;
      expect(locale.languageCode, 'en');
      expect(locale.countryCode, isNull);
    });

    test('should create an instance with language code and country code', () {
      const locale = Locale.en_us;
      expect(locale.languageCode, 'en');
      expect(locale.countryCode, 'us');
    });

    test('should implement toString correctly', () {
      expect(Locale.en.toString(), 'en');
      expect(Locale.en_us.toString(), 'en_us');
    });
    test('should implement equality correctly', () {
      expect(Locale.en, equals(Locale.en));
      expect(Locale.en_us, equals(Locale.en_us));
      expect(Locale.en, isNot(equals(Locale.fr)));
    });

    test('should have consistent hashCode', () {
      expect(Locale.en.hashCode, equals(Locale.en.hashCode));
      expect(
        Locale.en_us.hashCode,
        equals(Locale.en_us.hashCode),
      );
    });
  });

  group('Localized', () {
    test('should return default value when no locale is provided', () {
      // const localized = Localized<String>('default');
      const Localized<String> localized = {Locale.any: 'default'};
      expect(localized.forLocale(null), 'default');
    });

    test('should return localized value for exact match', () {
      // const localized = Localized<String>('default', {Locale.en_us: 'Hello'});
      const Localized<String> localized = {Locale.en_us: 'Hello'};
      expect(localized.forLocale(Locale.en_us), 'Hello');
    });

    test('should return localized value for language-only match', () {
      const Localized<String> localized = {Locale.en: 'Hello'};
      expect(localized.forLocale(Locale.en_gb), 'Hello');
    });

    test('should return default value when no match is found', () {
      const Localized<String> localized = {Locale.en_us: 'default'};
      expect(localized.forLocale(Locale.fr_fr), 'default');
    });

    test('should return default value for always factory', () {
      const Localized<String> localized = {Locale.any: 'always'};
      expect(localized.forLocale(Locale.en_us), 'always');
      expect(localized.forLocale(Locale.fr_fr), 'always');
    });

    test('should be case insensitive for language/country codes', () {
      const Localized<String> localized = {Locale.en_us: 'Hello'};
      expect(localized.forLocale(Locale.en_us), 'Hello');
    });
  });
}
