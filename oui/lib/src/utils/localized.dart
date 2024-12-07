import 'package:oui/oui.dart';

class Localized<T> {
  final T _defaultValue;
  final Map<Locale, T> _values;

  const Localized(
    this._defaultValue, [
    this._values = const {},
  ]);

  T forLocale(Locale locale) {
    // Try exact match first (language + country)
    if (_values.containsKey(locale)) {
      return _values[locale]!;
    }

    // Try language-only match
    final languageMatch = _values.keys.firstWhere(
      (key) => key.languageCode == locale.languageCode,
      orElse: () => locale,
    );

    if (_values.containsKey(languageMatch)) {
      return _values[languageMatch]!;
    }

    // Fall back to default value
    return _defaultValue;
  }
}
