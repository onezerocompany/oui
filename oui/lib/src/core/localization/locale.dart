/// A class representing a locale with a language code and an optional country code.
class Locale {
  /// The language code for localization, typically a two-letter code (e.g., 'en' for English).
  final String languageCode;

  /// The optional country code for localization, typically a two-letter code (e.g., 'US' for United States).
  final String? countryCode;

  /// Creates an instance of `Locale` with the given language code and an optional country code.
  ///
  /// The `languageCode` parameter is required and should be a valid ISO 639-1 language code.
  /// The `countryCode` parameter is optional and should be a valid ISO 3166-1 alpha-2 country code.
  ///
  /// Example:
  ///
  /// ```dart
  /// // Creating a locale for English language
  /// var locale = Locale('en');
  ///
  /// // Creating a locale for English language in the United States
  /// var localeUS = Locale('en', 'US');
  /// ```
  ///
  /// Parameters:
  /// - `languageCode`: A string representing the language code.
  /// - `countryCode`: An optional string representing the country code.
  const Locale(this.languageCode, [this.countryCode])
      : assert(
          languageCode.length == 2,
          'Language code must be ISO 639-1 compliant (2 letters)',
        ),
        assert(
          countryCode == null || countryCode.length == 2,
          'Country code must be ISO 3166-1 alpha-2 compliant (2 letters)',
        );

  @override
  String toString() {
    return countryCode == null ? languageCode : '${languageCode}_$countryCode';
  }
}
