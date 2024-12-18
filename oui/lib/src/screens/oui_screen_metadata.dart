import '../utils/oui_metadata.dart';
import '../router/oui_path.dart';

/// Provider class for resolving metadata about OUI screens.
///
/// This class extends [OuiMetadata] to include additional metadata information
/// specific to OUI screens, such as the path segments.
///
/// The [path] parameter is required and represents the path segments of the screen.
/// The [name] parameter is required and represents the localized name of the screen.
/// The [icon] parameter is optional and represents the localized icon data of the screen.
/// The [attributes] parameter is optional and represents a map of additional localized
/// attributes for the screen.
class OuiScreenMetadata extends OuiMetadata {
  final OuiPathSegments path;

  OuiScreenMetadata({
    required this.path,
    required super.name,
    super.icon,
    super.attributes,
  });
}
