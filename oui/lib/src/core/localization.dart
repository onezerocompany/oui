import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart' as widgets show Locale;
import 'package:flutter/widgets.dart' show BuildContext, Localizations;

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

  /// A locale representing the English language.
  static const Locale english = Locale('en');

  widgets.Locale get uiLocale {
    return countryCode == null
        ? widgets.Locale(languageCode)
        : widgets.Locale(languageCode, countryCode);
  }

  Locale fromUiLocale(widgets.Locale uiLocale) {
    return Locale(uiLocale.languageCode, uiLocale.countryCode);
  }

  @override
  String toString() {
    return countryCode == null ? languageCode : '${languageCode}_$countryCode';
  }
}

typedef Locales = List<Locale>;

extension LocaleExtension on BuildContext {
  /// Returns the current locale of the application.
  ///
  /// This method retrieves the current locale from the `AppContext` and returns it.
  Locale get currentLocale {
    final current = Localizations.localeOf(this);
    return Locale(current.languageCode, current.countryCode);
  }
}

/// A class that provides localized values for different locales.
///
/// The [Localized] class allows you to define a default value and a map of
/// localized values for different [Locale] instances. It provides methods
/// to retrieve the appropriate value based on the given locale.
///
/// Example usage:
/// ```dart
/// final localizedValue = Localized<String>(
///   'default',
///   {
///     Locale('en', 'US'): 'Hello',
///     Locale('es', 'ES'): 'Hola',
///   },
/// );
///
/// print(localizedValue.forLocale(Locale('en', 'US'))); // Output: Hello
/// print(localizedValue.forLocale(Locale('es', 'ES'))); // Output: Hola
/// print(localizedValue.forLocale(Locale('fr', 'FR'))); // Output: default
/// ```
///
/// [T] - The type of the localized value.
class Localized<T> {
  /// The default value to be used when no matching locale is found.
  final T _defaultValue;

  /// A map of localized values for different [Locale] instances.
  final Map<Locale, T> _values;

  /// Creates an instance of [Localized] with a default value and an optional
  /// map of localized values.
  ///
  /// The [_defaultValue] parameter is required and represents the default value
  /// to be used when no matching locale is found. The [_values] parameter is
  /// optional and defaults to an empty map.
  const Localized(
    this._defaultValue, [
    this._values = const {},
  ]);

  /// Creates an instance of [Localized] with a default value that is always
  /// used, regardless of the locale.
  ///
  /// The [defaultValue] parameter is required and represents the value to be
  /// used for all locales.
  factory Localized.always(T defaultValue) {
    return Localized(defaultValue);
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
  T forLocale(Locale? locale) {
    if (locale == null) {
      return _defaultValue;
    }

    // Try exact match first (language + country)
    final exactMatch = _values.keys.firstWhereOrNull(
      (key) =>
          key.languageCode.toLowerCase() == locale.languageCode.toLowerCase() &&
          (key.countryCode?.toLowerCase() ?? '') ==
              (locale.countryCode?.toLowerCase() ?? ''),
    );
    if (exactMatch != null) {
      return _values[exactMatch]!;
    }

    // Try language-only match
    final languageMatch = _values.keys.firstWhereOrNull(
      (key) =>
          key.languageCode.toLowerCase() == locale.languageCode.toLowerCase(),
    );
    if (languageMatch != null) {
      return _values[languageMatch]!;
    }

    // Fall back to default value
    return _defaultValue;
  }
}

typedef LocalizedString = Localized<String>;
typedef LocalizedMap<K, V> = Localized<Map<K, V>>;
typedef LocalizedSet<T> = Localized<Set<T>>;
