import 'package:collection/collection.dart';

import 'locale.dart';

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
