import 'package:flutter/widgets.dart';

/// Provider class for resolving metadata about OUI components.
///
/// This class is used to encapsulate metadata information for OUI components,
/// including their name, icon, and additional attributes. The metadata can be
/// localized to support multiple languages.
///
/// The [name] parameter is required and represents the localized name of the component.
/// The [icon] parameter is optional and represents the localized icon data of the component.
/// The [attributes] parameter is optional and represents a map of additional localized
/// attributes for the component.
class OuiMetadata {
  final String name;
  final IconData? icon;
  final Map<String, dynamic> attributes;

  /// Creates an instance of [OuiMetadata].
  ///
  /// The [name] parameter must be provided and cannot be null.
  /// The [icon] parameter defaults to a localized null value if not provided.
  /// The [attributes] parameter defaults to an empty localized map if not provided.
  OuiMetadata({
    required this.name,
    this.icon,
    this.attributes = const {},
  }) : assert(name.isNotEmpty);

  OuiMetadata copyWith({
    String? name,
    IconData? icon = const IconData(0),
    Map<String, dynamic>? attributes,
  }) {
    return OuiMetadata(
      name: name ?? this.name,
      icon: icon == const IconData(0) ? this.icon : icon,
      attributes: attributes ?? this.attributes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is OuiMetadata &&
        other.name == name &&
        other.icon == icon &&
        other.attributes == attributes;
  }

  @override
  int get hashCode => name.hashCode ^ icon.hashCode ^ attributes.hashCode;
}
