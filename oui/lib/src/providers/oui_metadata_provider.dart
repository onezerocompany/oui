import 'package:oui/oui.dart';

/// Context object holding information needed for metadata resolution
class MetadataContext {
  /// The build context
  final BuildContext context;

  /// The current locale
  final Locale locale;

  /// Creates a new [MetadataContext]
  ///
  /// Both [context] and [locale] are required.
  MetadataContext({
    required this.context,
    required this.locale,
  });
}

/// Provider class for resolving metadata about OUI components
class OuiMetadataProvider {
  /// Function that returns an icon widget for the component
  final Widget Function(MetadataContext) icon;

  /// Function that returns the localized name of the component
  final String Function(MetadataContext) name;

  /// Function that returns additional attributes for the component
  ///
  /// The returned map can contain any additional metadata needed.
  final Map<String, dynamic> Function(MetadataContext) attributes;

  /// Creates a new [OuiMetadataProvider]
  ///
  /// All parameters are required:
  /// - [icon]: Provides the component's icon
  /// - [name]: Provides the component's localized name
  /// - [attributes]: Provides additional component metadata
  const OuiMetadataProvider({
    required this.icon,
    required this.name,
    required this.attributes,
  });
}
