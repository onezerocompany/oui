import 'package:flutter/widgets.dart' show BuildContext;
import 'package:oui/src/core/_index.dart';

typedef Localized<T> = Map<Locale, T>;

extension LocalizedExtension<T> on Localized<T> {
  /// Returns the localized value for the given [locale].
  ///
  /// If the [locale] is `null`, the default value is returned. If an exact match
  /// for the [locale] is found in the [_values] map, the corresponding value is
  /// returned. If no exact match is found, a language-only match is attempted.
  /// If a language-only match is found, the corresponding value is returned.
  /// If no match is found, the [fallback] locale is used. If the [fallback] locale
  /// is also not found, the first entry in the [_values] map is returned.
  ///
  /// - [locale]: The locale for which the localized value is to be retrieved.
  /// - [fallback]: An optional fallback locale to be used if no match is found for
  ///   the [locale]. Defaults to `Locale.en`.
  ///
  /// Returns the localized value corresponding to the [locale] or [fallback] locale,
  /// or the first entry in the [_values] map if no match is found.
  /// If no match is found, the default value is returned.
  T? _forLocale(Locale? locale, [Locale? fallback = Locale.en]) {
    if (locale != null) {
      // Try exact match first (language + country)
      final exactMatch = keys.firstWhereOrNull(
        (key) =>
            key.languageCode == locale.languageCode &&
            key.countryCode == locale.countryCode,
      );
      if (exactMatch != null) {
        return this[exactMatch];
      }

      // Try language-only match
      final languageMatch = keys.firstWhereOrNull(
        (key) => key.languageCode == locale.languageCode,
      );
      if (languageMatch != null) {
        return this[languageMatch];
      }
    }

    // Try fallback locale
    if (fallback != null) {
      final fallbackMatch = keys.firstWhereOrNull(
        (key) =>
            key.languageCode == fallback.languageCode &&
            key.countryCode == fallback.countryCode,
      );
      if (fallbackMatch != null) {
        return this[fallbackMatch];
      }

      final fallbackLanguageMatch = keys.firstWhereOrNull(
        (key) => key.languageCode == fallback.languageCode,
      );
      if (fallbackLanguageMatch != null) {
        return this[fallbackLanguageMatch];
      }
    }

    // Return the first entry if no match is found
    return values.firstOrNull;
  }

  /// Returns the localized value for the current locale of the application.
  /// This method retrieves the current locale from the [BuildContext] and
  /// returns the corresponding localized value.
  T? resolve(LocaleContext context) {
    return _forLocale(context.locale);
  }

  /// Maps the localized values to a new type using the provided [transform] function.
  /// The [transform] function is applied to each value in the [_values] map.
  Localized<M> mapped<M>(M Function(T value) transform) {
    return Map.fromEntries(
      entries.map(
        (entry) => MapEntry<Locale, M>(entry.key, transform(entry.value)),
      ),
    );
  }
}

typedef Locales = List<Locale>;
