import 'package:oui/src/core/metadata/version.dart';

import 'metadata.dart';

class AppDetails extends Metadata {
  final Version version;

  const AppDetails({
    required super.name,
    super.icon,
    super.attributes,
    required this.version,
  });
}
