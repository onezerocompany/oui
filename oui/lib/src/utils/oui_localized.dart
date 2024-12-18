import 'package:collection/collection.dart';

/// A class representing a locale with a language code and an optional country code.
class OuiLocale {
  /// The language code for localization, typically a two-letter code (e.g., 'en' for English).
  final String languageCode;

  /// The optional country code for localization, typically a two-letter code (e.g., 'US' for United States).
  final String? countryCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OuiLocale &&
          other.languageCode == languageCode &&
          other.countryCode == countryCode;

  @override
  int get hashCode => Object.hash(languageCode, countryCode);

  /// Creates an instance of `OuiLocale` with the given language code and an optional country code.
  ///
  /// The `languageCode` parameter is required and should be a valid ISO 639-1 language code.
  /// The `countryCode` parameter is optional and should be a valid ISO 3166-1 alpha-2 country code.
  ///
  /// Example:
  ///
  /// ```dart
  /// // Creating a locale for English language
  /// var locale = OuiLocale('en');
  ///
  /// // Creating a locale for English language in the United States
  /// var localeUS = OuiLocale('en', 'US');
  /// ```
  ///
  /// Parameters:
  /// - `languageCode`: A string representing the language code.
  /// - `countryCode`: An optional string representing the country code.
  const OuiLocale(this.languageCode, [this.countryCode])
      : assert(
          languageCode.length == 2,
          'Language code must be ISO 639-1 compliant (2 letters)',
        ),
        assert(
          countryCode == null || countryCode.length == 2,
          'Country code must be ISO 3166-1 alpha-2 compliant (2 letters)',
        );
}

/// A class that provides localized values for different locales.
///
/// The [OuiLocalized] class allows you to define a default value and a map of
/// localized values for different [OuiLocale] instances. It provides methods
/// to retrieve the appropriate value based on the given locale.
///
/// Example usage:
/// ```dart
/// final localizedValue = OuiLocalized<String>(
///   'default',
///   {
///     OuiLocale('en', 'US'): 'Hello',
///     OuiLocale('es', 'ES'): 'Hola',
///   },
/// );
///
/// print(localizedValue.forLocale(OuiLocale('en', 'US'))); // Output: Hello
/// print(localizedValue.forLocale(OuiLocale('es', 'ES'))); // Output: Hola
/// print(localizedValue.forLocale(OuiLocale('fr', 'FR'))); // Output: default
/// ```
///
/// [T] - The type of the localized value.
class OuiLocalized<T> {
  /// The default value to be used when no matching locale is found.
  final T _defaultValue;

  /// A map of localized values for different [OuiLocale] instances.
  final Map<OuiLocale, T> _values;

  /// Creates an instance of [OuiLocalized] with a default value and an optional
  /// map of localized values.
  ///
  /// The [_defaultValue] parameter is required and represents the default value
  /// to be used when no matching locale is found. The [_values] parameter is
  /// optional and defaults to an empty map.
  const OuiLocalized(
    this._defaultValue, [
    this._values = const {},
  ]);

  /// Creates an instance of [OuiLocalized] with a default value that is always
  /// used, regardless of the locale.
  ///
  /// The [defaultValue] parameter is required and represents the value to be
  /// used for all locales.
  factory OuiLocalized.always(T defaultValue) {
    return OuiLocalized(defaultValue);
  }

  /// Returns the default value.
  T get base => _defaultValue;

  /// Returns the localized value for the given [locale].
  ///
  /// If the [locale] is `null`, the default value is returned. If an exact match
  /// for the [locale] is found in the [_values] map, the corresponding value is
  /// returned. If no exact match is found, a language-only match is attempted.
  /// If a language-only match is found, the corresponding value is returned.
  /// If no match is found, the default value is returned.
  T forLocale(OuiLocale? locale) {
    if (locale == null) {
      return _defaultValue;
    }

    // Try exact match first (language + country)
    if (_values.containsKey(locale)) {
      return _values[locale]!;
    }

    // Try language-only match
    final languageMatch = _values.keys
        .firstWhereOrNull((key) => key.languageCode == locale.languageCode);
    if (languageMatch != null) {
      return _values[languageMatch]!;
    }

    if (_values.containsKey(languageMatch)) {
      return _values[languageMatch]!;
    }

    // Fall back to default value
    return _defaultValue;
  }
}
